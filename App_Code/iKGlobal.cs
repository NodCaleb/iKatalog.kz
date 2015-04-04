using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Drawing;
using System.Threading;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using System.Security.Cryptography;

namespace iKGlobal
{
    public partial class GlobalClass : System.Web.UI.Page
    {
	public MembershipUser AuthorizedUser;
    
	static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
	static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
	static string UserQueryString = "select top 1 FullName, FirstName, IsAdmin, Customer_id, Alias, Email, ContractNumber from CustomerInfo where User_id = @User_id";
	static string RegisterRequestString = "insert into AskMeRequests (Name, Email, Phone, Request, Source) values (@Name, @Email, @Phone, @Request, @Source)";
	static string XrateReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, GETDATE())";
	static string XrateWriteString = "insert into Xrates (Xrate) values (@Xrate)";
	static string CartContentString = "select case count(*) when 0 then 'пусто' else '<b>' + convert (nvarchar(10), count (*)) +'</b> (' + REPLACE(CONVERT (nvarchar(10), ROUND (SUM (OI.Price * C.PriceIndex), 2)), '.', ',') + ' €)' end as CartContent from OrderItems as OI join Catalogues as C on C.Catalogue_id = OI.Catalogue_id where OI.Session_id = @Session_id and Order_id = -1";
	SqlCommand XrateRead = new SqlCommand(XrateReadString, iKConnection);
	SqlCommand XrateWrite = new SqlCommand(XrateWriteString, iKConnection);
	SqlCommand CartContent = new SqlCommand(CartContentString, iKConnection);
	XmlTextReader Xreader = new XmlTextReader("http://www.nationalbank.kz/rss/rates_all.xml");
	
	SqlCommand UserInfo = new SqlCommand(UserQueryString, iKConnection);
	SqlCommand RegisterRequest = new SqlCommand(RegisterRequestString, iKConnection);    

	private static string CreateSalt(int size)
	{
	    //Generate a cryptographic random number.
	    RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
	    byte[] buff = new byte[size];
	    rng.GetBytes(buff);
    
	    // Return a Base64 string representation of the random number.
	    return Convert.ToBase64String(buff);
	}
	
	public bool CheckEmailExistence (string email)
	{
	    EnsureDatabaseConnection();
	    
	    String CheckEmailString = "select Email from aspnet_Membership where LoweredEmail = LOWER (@Email)";
	    SqlCommand CheckEmail = new SqlCommand(CheckEmailString, iKConnection);
	    
	    CheckEmail.Parameters.Clear();
	    CheckEmail.Parameters.AddWithValue("Email", email);
	    
	    if (CheckEmail.ExecuteScalar() != null)
	    {
		return true;
	    }
	    else
	    {
		return false;
	    }
	}
	
	public bool RegisterCustomerLite(string email, string name, string phone)
	{
	    EnsureDatabaseConnection();
	    
	    String RegisterUserString = "Ktrade_CreateUser";
	    SqlCommand RegisterUser = new SqlCommand(RegisterUserString, iKConnection);
	    
	    RegisterUser.CommandType = CommandType.StoredProcedure;
	    RegisterUser.Parameters.Clear();
	    
	    string ApplicationNameValue = "/";
	    string UserNameValue = email;
	    string PasswordValue = Guid.NewGuid().ToString().Substring(1,6);
	    string PasswordSaltValue = CreateSalt(18);
	    string EmailValue = email;
	    string FirstNameValue = name;
	    string LastNameValue = "";

	    SqlParameter ApplicationName = new SqlParameter("@ApplicationName", SqlDbType.NVarChar);
	    ApplicationName.Direction = ParameterDirection.Input;
	    ApplicationName.Value = ApplicationNameValue;
	    RegisterUser.Parameters.Add(ApplicationName);

	    SqlParameter UserName = new SqlParameter("@UserName", SqlDbType.NVarChar);
	    UserName.Direction = ParameterDirection.Input;
	    UserName.Value = UserNameValue;
	    RegisterUser.Parameters.Add(UserName);

	    SqlParameter Password = new SqlParameter("@Password", SqlDbType.NVarChar);
	    Password.Direction = ParameterDirection.Input;
	    Password.Value = PasswordValue;
	    RegisterUser.Parameters.Add(Password);

	    SqlParameter PasswordSalt = new SqlParameter("@PasswordSalt", SqlDbType.NVarChar);
	    PasswordSalt.Direction = ParameterDirection.Input;
	    PasswordSalt.Value = PasswordSaltValue;
	    RegisterUser.Parameters.Add(PasswordSalt);

	    SqlParameter Email = new SqlParameter("@Email", SqlDbType.NVarChar);
	    Email.Direction = ParameterDirection.Input;
	    Email.Value = EmailValue;
	    RegisterUser.Parameters.Add(Email);

	    SqlParameter FirstName = new SqlParameter("@FirstName", SqlDbType.NVarChar);
	    FirstName.Direction = ParameterDirection.Input;
	    FirstName.Value = FirstNameValue;
	    RegisterUser.Parameters.Add(FirstName);

	    SqlParameter LastName = new SqlParameter("@LastName", SqlDbType.NVarChar);
	    LastName.Direction = ParameterDirection.Input;
	    LastName.Value = LastNameValue;
	    RegisterUser.Parameters.Add(LastName);

	    //SqlParameter Alias = new SqlParameter("@Alias", SqlDbType.NVarChar);
	    //Alias.Direction = ParameterDirection.Output;
	    ////Alias.Value = null;
	    //RegisterUser.Parameters.Add(Alias);
	    
	    string SourceCookie = "Более не используется"; //Depricated due to implememtation of GoogleAnalytics covertion targets
	    
	    SqlParameter Source = new SqlParameter("@Source", SqlDbType.NVarChar);
	    Source.Direction = ParameterDirection.Input;
	    Source.Value = SourceCookie.ToString();
	    RegisterUser.Parameters.Add(Source);

	    bool Success;

	    try
	    {
		RegisterUser.ExecuteNonQuery();
		return true;
	    }
	    catch
	    {
		return false;		
	    }
	}
	public void SendRegisterNotifcations(string Email, string FirstName, string Phone)
	{
	    EnsureDatabaseConnection();
	    
	    SmtpClient KtradeSMTP = new SmtpClient();
    
	    MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
	    MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
	    MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
	    MailAddress Customer = new MailAddress(Email, FirstName);
	    
	    string GetStandartMailString = "select Subject, Body from StandartMail where id = @id";
	    SqlCommand GetStandartMail = new SqlCommand(GetStandartMailString, iKConnection);
	    
	    string GetUserAliasString = "select Alias, ContractNumber, Password from UserView where UserName = @UserName";
	    SqlCommand GetUserAlias = new SqlCommand(GetUserAliasString, iKConnection);
    
	    GetUserAlias.Parameters.Clear();
	    GetUserAlias.Parameters.AddWithValue("UserName", Email);
		    
	    SqlDataReader AliasReader = GetUserAlias.ExecuteReader();
	    AliasReader.Read();
    
	    string Alias = AliasReader["Alias"].ToString();
	    string ContractNumber = AliasReader["ContractNumber"].ToString();
	    string Password = AliasReader["Password"].ToString();
		    
	    AliasReader.Close();
    
	    //Сообщение для продавца
	    MailMessage NotifySeller = new MailMessage();
	    NotifySeller.From = Admin;
	    NotifySeller.To.Add(Sale);
	    NotifySeller.To.Add(Office);
	    NotifySeller.To.Add(Admin); //Для тестирования
	    NotifySeller.IsBodyHtml = true;
	    NotifySeller.BodyEncoding = System.Text.Encoding.UTF8;
	    NotifySeller.SubjectEncoding = System.Text.Encoding.UTF8;
	    NotifySeller.Subject = "Новый пользователь на сайте: " + FirstName;
	    NotifySeller.Body = "";
	    NotifySeller.Body += "<h3>У нас на сайте завелся новый пользователь:</h3>";
	    NotifySeller.Body += "<table border=\"0\" style=\"border-style:none\" cellspacing=\"0\" cellpadding=\"5px\"> ";
	    NotifySeller.Body += "<tr> <td> Имя </td> <td> " + FirstName + " </td> </tr> ";
	    NotifySeller.Body += "<tr> <td> Email (логин) </td> <td> " + Email + " </td> </tr> ";
	    NotifySeller.Body += "<tr> <td> Пароль </td> <td> " + Password + " </td> </tr> ";       
	    NotifySeller.Body += "<tr> <td> Псевдоним </td> <td> " + Alias + " </td> </tr> ";
	    NotifySeller.Body += "<tr> <td> Телефон </td> <td> " + Phone + " </td> </tr> ";
	    NotifySeller.Body += "<tr> <td> Договор № </td> <td> " + ContractNumber + " </td> </tr> ";
	    NotifySeller.Body += "</trable>";
    
	    //Сообщение для покупателя
	    MailMessage NotifyCustomer = new MailMessage();
	    NotifyCustomer.From = Admin;
	    NotifyCustomer.To.Add(Customer);
	    NotifyCustomer.ReplyTo = Office;
	    //NotifyCustomer.To.Add(Admin); //Для тестирования
	    NotifyCustomer.IsBodyHtml = true;
	    NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
	    NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
	    NotifyCustomer.Subject = "Подтверждение регистрации на iKatalog.kz";
	    NotifyCustomer.Body = "";
	    NotifyCustomer.Body = "<p>Здравствуйте, " + FirstName + ", ";
	    NotifyCustomer.Body += "ваша регистрация на <a href=\"http://ikatalog.kz\">iKatalog</a> подтверждена. </p>";
	    NotifyCustomer.Body += "<p>Имя пользователя для входа в систему — ваш Email: " + Email + "<br />";
	    NotifyCustomer.Body += "Пароль для входа в систему: " + Password + ", вы можете поменять его в <a href=\"http://ikatalog.kz/Customer/AccountInfo.aspx\">Личном кабинете на сайте</a><br />";
	    //NotifyCustomer.Body += "Номер договора для оплаты через терминалы Qiwi: " + ContractNumber + "</p>";
	    //NotifyCustomer.Body += "<p><b><small>Пожалуйста, не отвечайте на это письмо, робот читать не умеет!</small></b></p><p><small>Чтобы связаться с нами, пишите на <a href=\"mailto:sale@ikatalog.kz\">sale@ikatalog.kz</a>.</small></p>";
    
	    //И еще одно для покупателя
	    
	    GetStandartMail.Parameters.Clear();
	    GetStandartMail.Parameters.AddWithValue("id", 0);
		    
	    SqlDataReader MailReader = GetStandartMail.ExecuteReader();
	    MailReader.Read();
    
	    string ThankCustomerSubject = MailReader["Subject"].ToString();
	    string ThankCustomerBody = MailReader["Body"].ToString();
		    
	    MailReader.Close();
	    
	    MailMessage ThankCustomer = new MailMessage();
    
	    ThankCustomer.From = Admin;
	    ThankCustomer.To.Add(Customer);
	    //ThankCustomer.To.Add(Admin); //Для тестирования
	    ThankCustomer.ReplyTo = Sale;
	    ThankCustomer.IsBodyHtml = true;
	    ThankCustomer.BodyEncoding = System.Text.Encoding.UTF8;
	    ThankCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
    
	    //TestMessage.Sender = MailSender;
	    //TestMessage.To.Add(MailReceiver);
	    ThankCustomer.Subject = ThankCustomerSubject;
	    ThankCustomer.Body = ThankCustomerBody.Replace("%USER_NAME%", FirstName);
    
	    KtradeSMTP.Send(NotifySeller);
	    KtradeSMTP.Send(NotifyCustomer);
	    KtradeSMTP.Send(ThankCustomer);
    
	    NotifyCustomer.Dispose();
	    NotifySeller.Dispose();
	    ThankCustomer.Dispose();
	}

	public float getCurrencyRate()
	{
	    EnsureDatabaseConnection();
	    
	    string XrateReadString = "select top 1 Xrate from Xrates order by Date desc";
	    SqlCommand XrateRead = new SqlCommand(XrateReadString, iKConnection);
	    
	    float Xrate;
	    
	    try
	    {
		Xrate = Single.Parse(XrateRead.ExecuteScalar().ToString());
	    }
	    catch
	    {
		Xrate = 0;
	    }
	    
	    return Xrate;
	}
	public float getCatalogueIndex(string Catalogue_id)
	{
	    EnsureDatabaseConnection();
	    
	    string IndexReadString = "select PriceIndex from Catalogues where Catalogue_id = @Catalogue_id";
	    SqlCommand IndexRead = new SqlCommand(IndexReadString, iKConnection);
	    IndexRead.Parameters.Clear();
	    IndexRead.Parameters.AddWithValue("Catalogue_id", Catalogue_id);
	    
	    float Index;
	    
	    try
	    {
		Index = Single.Parse(IndexRead.ExecuteScalar().ToString());
	    }
	    catch
	    {
		Index = 0;
	    }
	    
	    return Index;
	}
	public float getCatalogueWeightFee(string Catalogue_id)
	{
	    EnsureDatabaseConnection();
	    
	    string FeeReadString = "select WeightFee from Catalogues where Catalogue_id = @Catalogue_id";
	    SqlCommand FeeRead = new SqlCommand(FeeReadString, iKConnection);
	    FeeRead.Parameters.Clear();
	    FeeRead.Parameters.AddWithValue("Catalogue_id", Catalogue_id);
	    
	    float Fee;
	    
	    try
	    {
		Fee = Single.Parse(FeeRead.ExecuteScalar().ToString());
	    }
	    catch
	    {
		Fee = 0;
	    }
	    
	    return Fee;
	}
	public void CreateLog (string Message, string FileName)
	{
	    string LogFile = Server.MapPath("~/Logs/") + FileName;
	    string LogString = DateTime.Now.ToShortDateString().ToString()+" "+DateTime.Now.ToLongTimeString().ToString()+" ==> " + Message;
	    
	    StreamWriter SW = new StreamWriter(LogFile,true);
	    SW.WriteLine(LogString);
	    SW.Flush();
	    SW.Close();
	}
	private void EnsureDatabaseConnection()
	{
	    if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	}
	public string CraftCoupon(int customer_id, float discountValue, int durationDays)
	{
	    EnsureDatabaseConnection();
	    
	    string CraftCouponString = "CraftDiscountCoupon";
	    SqlCommand CraftCoupon = new SqlCommand(CraftCouponString, iKConnection);
	    
	    CraftCoupon.Parameters.Clear();            
            CraftCoupon.CommandType = CommandType.StoredProcedure;
            
            SqlParameter Customer_id = new SqlParameter("@Customer_id", SqlDbType.Int);
            Customer_id.Value = customer_id.ToString();
            Customer_id.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(Customer_id);
            
            SqlParameter DiscountValue = new SqlParameter("@Value", SqlDbType.SmallMoney);
            DiscountValue.Value = discountValue;
            DiscountValue.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(DiscountValue);
            
            SqlParameter Duration = new SqlParameter("@DurationDays", SqlDbType.Int);
            Duration.Value = durationDays;
            Duration.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(Duration);
            
            SqlParameter Number = new SqlParameter("@Number", SqlDbType.VarChar);
            Number.Direction = ParameterDirection.Output;
            Number.Size = 10;
            CraftCoupon.Parameters.Add(Number);
            
            CraftCoupon.ExecuteNonQuery();
	    
	    return Number.Value.ToString();
	}
	public int GetCustomerIDByLogin(string login)
	{
	    EnsureDatabaseConnection();
	    
	    string GetCustomerIDString = "select Customer_id from UserView where UserName = @userName";
	    SqlCommand GetCustomerID = new SqlCommand(GetCustomerIDString, iKConnection);
	    
	    GetCustomerID.Parameters.Clear();
	    GetCustomerID.Parameters.AddWithValue("userName", login);
	    
	    if (GetCustomerID.ExecuteScalar() != null)
	    {
		return Int16.Parse(GetCustomerID.ExecuteScalar().ToString());
	    }
	    else
	    {
		return -1;
	    }
	}
	public string GetCustomerLoginByID(string C_ID)
	{
	    EnsureDatabaseConnection();
	    
	    string GetCustomerLoginString = "select UserName from UserView where Customer_id = @Customer_id";
	    SqlCommand GetCustomerLogin = new SqlCommand(GetCustomerLoginString, iKConnection);
	    
	    GetCustomerLogin.Parameters.Clear();
	    GetCustomerLogin.Parameters.AddWithValue("Customer_id", C_ID);
	    
	    if (GetCustomerLogin.ExecuteScalar() != null)
	    {
		return GetCustomerLogin.ExecuteScalar().ToString();
	    }
	    else
	    {
		return "";
	    }
	}
	public string GetMailSubject(int mail_id)
	{
	    EnsureDatabaseConnection();
	    
	    string GetStandartMailString = "select Subject from StandartMail where id = @id";
	    SqlCommand GetStandartMail = new SqlCommand(GetStandartMailString, iKConnection);
	    	    
	    GetStandartMail.Parameters.Clear();
	    GetStandartMail.Parameters.AddWithValue("id", mail_id);
	    
	    if (GetStandartMail.ExecuteScalar() != null)
	    {
		return GetStandartMail.ExecuteScalar().ToString();
	    }
	    else
	    {
		return "";
	    }
	}
	public string GetMailBody(int mail_id)
	{
	    EnsureDatabaseConnection();
	    
	    string GetStandartMailString = "select Body from StandartMail where id = @id";
	    SqlCommand GetStandartMail = new SqlCommand(GetStandartMailString, iKConnection);
	    	    
	    GetStandartMail.Parameters.Clear();
	    GetStandartMail.Parameters.AddWithValue("id", mail_id);
	    
	    if (GetStandartMail.ExecuteScalar() != null)
	    {
		return GetStandartMail.ExecuteScalar().ToString();
	    }
	    else
	    {
		return "";
	    }
	}
	public void SendCouponIssueNotifcations(string couponNumber)
	{
	    EnsureDatabaseConnection();
	    
	    string GetCouponDataString = "select * from CouponData where Number = @couponNumber";
	    SqlCommand GetCouponData = new SqlCommand(GetCouponDataString, iKConnection);
	    
	    GetCouponData.Parameters.Clear();
	    GetCouponData.Parameters.AddWithValue("couponNumber", couponNumber);
	    
	    SqlDataReader CouponDataReader = GetCouponData.ExecuteReader();
	    CouponDataReader.Read();
	    
	    if (CouponDataReader.HasRows)
	    {
		string fullName = CouponDataReader["FullName"].ToString();
		string email = CouponDataReader["Email"].ToString();
		string durationDays = CouponDataReader["DurationDays"].ToString();
		string discountValue = CouponDataReader["DiscountValue"].ToString();
		string MessageSubject = GetMailSubject(1);
		string MessageBody = GetMailBody(1);
				
		SmtpClient KtradeSMTP = new SmtpClient();
		
		MailMessage CouponIssueNote = new MailMessage();
		
		MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
		MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
		MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
		MailAddress Customer = new MailAddress(email, fullName);
	
		CouponIssueNote.From = Admin;
		CouponIssueNote.To.Add(Customer);
		CouponIssueNote.To.Add(Admin); //Для тестирования
		CouponIssueNote.ReplyTo = Sale;
		CouponIssueNote.IsBodyHtml = true;
		CouponIssueNote.BodyEncoding = System.Text.Encoding.UTF8;
		CouponIssueNote.SubjectEncoding = System.Text.Encoding.UTF8;
	
		CouponIssueNote.Subject = MessageSubject;
		CouponIssueNote.Body = MessageBody.Replace("%USER_NAME%", fullName).Replace("%COUPON_NUMBER%", couponNumber).Replace("%COUPON_DURATION%", durationDays).Replace("%COUPON_VALUE%", discountValue);
	
		KtradeSMTP.Send(CouponIssueNote);
		CouponIssueNote.Dispose();
	    }
	    CouponDataReader.Close();
	}
	public void SendCouponReminder(string couponNumber)
	{
	    EnsureDatabaseConnection();
	    
	    string GetCouponDataString = "select * from CouponData where Number = @couponNumber";
	    SqlCommand GetCouponData = new SqlCommand(GetCouponDataString, iKConnection);
	    
	    GetCouponData.Parameters.Clear();
	    GetCouponData.Parameters.AddWithValue("couponNumber", couponNumber);
	    
	    SqlDataReader CouponDataReader = GetCouponData.ExecuteReader();
	    CouponDataReader.Read();
	    
	    if (CouponDataReader.HasRows)
	    {
		string fullName = CouponDataReader["FullName"].ToString();
		string email = CouponDataReader["Email"].ToString();
		string daysLeft = CouponDataReader["DaysLeft"].ToString();
		string discountValue = CouponDataReader["DiscountValue"].ToString();
		string MessageSubject = GetMailSubject(2);
		string MessageBody = GetMailBody(2);
				
		SmtpClient KtradeSMTP = new SmtpClient();
		
		MailMessage CouponIssueNote = new MailMessage();
		
		MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
		MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
		MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
		MailAddress Customer = new MailAddress(email, fullName);
	
		CouponIssueNote.From = Admin;
		CouponIssueNote.To.Add(Customer);
		CouponIssueNote.To.Add(Admin); //Для тестирования
		CouponIssueNote.ReplyTo = Sale;
		CouponIssueNote.IsBodyHtml = true;
		CouponIssueNote.BodyEncoding = System.Text.Encoding.UTF8;
		CouponIssueNote.SubjectEncoding = System.Text.Encoding.UTF8;
	
		CouponIssueNote.Subject = MessageSubject;
		CouponIssueNote.Body = MessageBody.Replace("%USER_NAME%", fullName).Replace("%COUPON_NUMBER%", couponNumber).Replace("%DAYS_LEFT%", daysLeft).Replace("%COUPON_VALUE%", discountValue);
	
		KtradeSMTP.Send(CouponIssueNote);
		CouponIssueNote.Dispose();
	    }
	    CouponDataReader.Close();
	}
	public float GetCumulatedOrders(string Customer_id)
	{
	    EnsureDatabaseConnection();
	    
	    string GetAmmountString = "select CumulatedOrders from CumulatedOrders where Customer_id = @Customer_id";
	    SqlCommand GetAmmount = new SqlCommand(GetAmmountString, iKConnection);
	    
	    GetAmmount.Parameters.Clear();
	    GetAmmount.Parameters.AddWithValue("Customer_id", Customer_id);
	    
	    float amount;
	    
	    if (GetAmmount.ExecuteScalar() != null)
	    {
		try
		{
		    amount = Single.Parse(GetAmmount.ExecuteScalar().ToString());
		}
		catch
		{
		    amount = 0;
		}
	    }
	    else amount = 0;
	    
	    return amount;
	}
	public void SendActivationCouponNotifcations(string couponNumber)
	{
	    EnsureDatabaseConnection();
	    
	    string GetCouponDataString = "select * from CouponData where Number = @couponNumber";
	    SqlCommand GetCouponData = new SqlCommand(GetCouponDataString, iKConnection);
	    
	    GetCouponData.Parameters.Clear();
	    GetCouponData.Parameters.AddWithValue("couponNumber", couponNumber);
	    
	    SqlDataReader CouponDataReader = GetCouponData.ExecuteReader();
	    CouponDataReader.Read();
	    
	    if (CouponDataReader.HasRows)
	    {
		string fullName = CouponDataReader["FullName"].ToString();
		string email = CouponDataReader["Email"].ToString();
		string durationDays = CouponDataReader["DurationDays"].ToString();
		string discountValue = CouponDataReader["DiscountValue"].ToString();
		string MessageSubject = GetMailSubject(3);
		string MessageBody = GetMailBody(3);
				
		SmtpClient KtradeSMTP = new SmtpClient();
		
		MailMessage CouponIssueNote = new MailMessage();
		
		MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
		MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
		MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
		MailAddress Customer = new MailAddress(email, fullName);
	
		CouponIssueNote.From = Admin;
		CouponIssueNote.To.Add(Customer);
		CouponIssueNote.To.Add(Admin); //Для тестирования
		CouponIssueNote.ReplyTo = Sale;
		CouponIssueNote.IsBodyHtml = true;
		CouponIssueNote.BodyEncoding = System.Text.Encoding.UTF8;
		CouponIssueNote.SubjectEncoding = System.Text.Encoding.UTF8;
	
		CouponIssueNote.Subject = MessageSubject;
		CouponIssueNote.Body = MessageBody.Replace("%USER_NAME%", fullName).Replace("%COUPON_NUMBER%", couponNumber).Replace("%COUPON_DURATION%", durationDays).Replace("%COUPON_VALUE%", discountValue);
	
		KtradeSMTP.Send(CouponIssueNote);
		CouponIssueNote.Dispose();
	    }
	    CouponDataReader.Close();
	}
	public decimal GetXrate()
	{
	    EnsureDatabaseConnection();
	    
	    string XrateReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, GETDATE())";
	    string XrateLastString = "select top 1 Xrate from Xrates order by Date desc";
	    string XrateWriteString = "insert into Xrates (Xrate) values (@Xrate)";
	    SqlCommand XrateRead = new SqlCommand(XrateReadString, iKConnection);
	    SqlCommand XrateWrite = new SqlCommand(XrateWriteString, iKConnection);
	    SqlCommand XrateLast = new SqlCommand(XrateLastString, iKConnection);
	    XmlTextReader Xreader = new XmlTextReader("http://www.nationalbank.kz/rss/rates_all.xml");
	    
	    if (XrateRead.ExecuteScalar() != null)
	    {
		return Decimal.Parse(XrateRead.ExecuteScalar().ToString());
	    }
	    else
	    {
		try
		{
		    do
		    {
			Xreader.Read();
		    }
		    while (Xreader.Value != "EUR");
    
		    for (int i = 0; i < 6; i++)
		    {
			Xreader.Read();
		    }
    
		    XrateWrite.Parameters.AddWithValue("Xrate", Math.Round(Double.Parse(Xreader.Value.Replace(".", ",")) * 1.015, 2));
		    XrateWrite.ExecuteNonQuery();
		    return Decimal.Parse(XrateRead.ExecuteScalar().ToString());
		}
		catch
		{
		    return Decimal.Parse(XrateLast.ExecuteScalar().ToString());
		}
	    }
	}
    }
}
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
using iKGlobal;

public partial class iKMasterPage : System.Web.UI.MasterPage
{
    public MembershipUser AuthorizedUser;
    
    static GlobalClass iClass = new GlobalClass();

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
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	
	//Page.MetaDescription = "Мы предоставляем услуги доставки товаров по каталогам - OTTO, H&M, Lacoste, ZARA, MEXX, Amazon и других - из Германии. Вашему вниманию предлагаются более 130 европейских каталогов одежды онлайн с огромным ассортиментом товаров на любой вкус для людей разного возраста.";
	CheckAuthorization();
        UpdateXrate();
	UpdateCartContent();
	
	//CreateLog(Guid.NewGuid().ToString().Substring(1,6));
    }
    void CheckAuthorization()
    {
	AuthorizedUser = Membership.GetUser(); //Вот это надо писать при логине в параметры сесии, при отсутствии оных, читать из базы, также приверять их при открытии страницы оформления заказа
        if (AuthorizedUser != null)
        {
            if (Session["UserName"] == null)
            {
		UserInfo.Parameters.AddWithValue("User_id", AuthorizedUser.ProviderUserKey.ToString());
		SqlDataReader UserCredentials = UserInfo.ExecuteReader();
		UserCredentials.Read();
	
		if (UserCredentials.HasRows)
		{
		    if (UserCredentials["IsAdmin"].ToString() == "True")
		    {
			Session["Admin"] = "true";
			AdminHyperLink.Visible = true;
		    }
		    else Session["Admin"] = "false";
		    Session["Customer"] = UserCredentials["Customer_id"].ToString();

		    UserNameLabel.Text = UserCredentials["FullName"].ToString();
		    Session["UserName"] = UserCredentials["FirstName"].ToString();
		    Session["UserFullName"] = UserCredentials["FullName"].ToString();
		    Session["UserMail"] = UserCredentials["Email"].ToString();
		    Session["ContractNumber"] = UserCredentials["ContractNumber"].ToString();
		}
		else
		{
		    //UserFullNameDisplay.Text = "Здравствуйте, " + AuthorizedUser.UserName.ToString();
		    //Session["UserName"] = "До свидания.";
		    Session["Customer"] = "-1";
		}
		UserCredentials.Close();
	    }
	    else
	    {
		UserNameLabel.Text = Session["UserFullName"].ToString();
	    }
            LoginMultiView.ActiveViewIndex = 1;
            if (Session["Admin"] == "true")	AdminHyperLink.Visible = true;
        }
        else
        {
            Session["Customer"] = "-1";
            LoginMultiView.ActiveViewIndex = 0;
        }
    }
    void UpdateXrate()
    {
	if (XrateRead.ExecuteScalar() != null)
        {
            XrateLabel.Text = XrateRead.ExecuteScalar().ToString();
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
                XrateLabel.Text = XrateRead.ExecuteScalar().ToString();
            }
            catch
            {
                XrateLabel.Text = "---";
            }
        }
    }
    void UpdateCartContent()
    {
	CartContent.Parameters.Clear();
	CartContent.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	CartLabel.Text = CartContent.ExecuteScalar().ToString();
	CartContent.Parameters.Clear();
    }
    protected void LogoutButton_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Roles.DeleteCookie();
        Session.Clear();
        Response.Redirect(Request.RawUrl);
    }
    protected void LoginButton_Click(object sender, EventArgs e)
    {
	string GetUsernameString = "select U.LoweredUserName from aspnet_Users as U join aspnet_Membership as M on M.UserId = U.UserId where U.LoweredUserName = @Login OR M.LoweredEmail = @Login";
	SqlCommand GetUsername = new SqlCommand(GetUsernameString, iKConnection);
	
	string UserName;
	string UserPass;
	
	GetUsername.Parameters.Clear();
	GetUsername.Parameters.AddWithValue("Login", UserNameTextBox.Text.ToLower());	
	
	if (GetUsername.ExecuteScalar() != null)
	{
	    UserName = GetUsername.ExecuteScalar().ToString();
	}
	else
	{
	    UserName = "";
	}
	
	UserPass = PasswordTextBox.Text;
	
	if (Membership.ValidateUser(UserName, UserPass))
        {
            if (Request.QueryString["ReturnUrl"] != null) FormsAuthentication.RedirectFromLoginPage(UserName, true);
	    else
	    {
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(UserName, true, 30);
		string encTicket = FormsAuthentication.Encrypt(ticket);
		Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
		Response.Redirect(Request.RawUrl);
	    }
        }
        else
        {
            UserNameTextBox.BackColor = Color.OrangeRed;
            PasswordTextBox.BackColor = Color.OrangeRed;
        }
    }
    protected void LoginLinkButton_Click(object sender, EventArgs e)
    {
	LoginFormPanel.Visible = true;
    }
    protected void CancelButton_Click(object sender, EventArgs e)
    {
	LoginFormPanel.Visible = false;
	CalculatorPanel.Visible = false;
	RegisterFormPanel.Visible = false;
	CalculationUpdatePanel.Update();
    }
    protected void RegisterLinkButton_Click(object sender, EventArgs e)
    {
	//Response.Redirect("~/Customer/Register.aspx");
	RegisterFormPanel.Visible = true;
    }
    private static string CreateSalt(int size)
    {
        //Generate a cryptographic random number.
        RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
        byte[] buff = new byte[size];
        rng.GetBytes(buff);

        // Return a Base64 string representation of the random number.
        return Convert.ToBase64String(buff);
    }
    protected void RegisterCustomer(object sender, EventArgs e)
    {
	if (iClass.CheckEmailExistence(EmailTextBox.Text))
        {
            EmailUniquenessValidator.IsValid = false;
        }
        else
        {
            EmailUniquenessValidator.IsValid = true;
        }
	
	if (Page.IsValid)
        {   
	    //Здесь и далее в качестве имени пользователя используется email
	    if (iClass.RegisterCustomerLite(EmailTextBox.Text, UserFullNameTextBox.Text, PhoneTextBox.Text))
	    {
		iClass.SendRegisterNotifcations(EmailTextBox.Text, UserFullNameTextBox.Text, PhoneTextBox.Text);
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(EmailTextBox.Text, true, 30);
		string encTicket = FormsAuthentication.Encrypt(ticket);
		Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
		Response.Redirect(Request.RawUrl);
	    }
	    else
	    {
		Response.Redirect("~/Customer/RegisterFail.aspx");
	    }
        }
    }
    protected void SendNotifcations(string Email, string Password, string FirstName, string Phone)
    {
        SmtpClient KtradeSMTP = new SmtpClient();

        MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
        MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
        MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
        MailAddress Customer = new MailAddress(Email, FirstName);
	
	string GetUserAliasString = "select Alias, ContractNumber from UserView where UserName = @UserName";
	SqlCommand GetUserAlias = new SqlCommand(GetUserAliasString, iKConnection);

        GetUserAlias.Parameters.Clear();
        GetUserAlias.Parameters.AddWithValue("UserName", Email);
		
	SqlDataReader AliasReader = GetUserAlias.ExecuteReader();
        AliasReader.Read();

        string Alias = AliasReader["Alias"].ToString();
	string ContractNumber = AliasReader["ContractNumber"].ToString();
		
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
        NotifyCustomer.To.Add(Admin); //Для тестирования
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
        MailMessage ThankCustomer = new MailMessage();

        ThankCustomer.From = Admin;
        ThankCustomer.To.Add(Customer);
	ThankCustomer.To.Add(Admin); //Для тестирования
        ThankCustomer.ReplyTo = Sale;
        ThankCustomer.IsBodyHtml = true;
        ThankCustomer.BodyEncoding = System.Text.Encoding.UTF8;
        ThankCustomer.SubjectEncoding = System.Text.Encoding.UTF8;

        //TestMessage.Sender = MailSender;
        //TestMessage.To.Add(MailReceiver);
        ThankCustomer.Subject = "Благодарим за регистрацию!";
        ThankCustomer.Body = "<h4>Здравствуйте, " + FirstName + "</h4><html><head>	<title></title></head><body><p>Благодарим вас за проявленный интерес к нашим услугам!</p><p>В этом письме мы постораемся ответить на вопросы, которые могут у вас возникнуть.</p><h4>Что делать дальше?</h4><p>Если вы уже оформили заказ, необходимо внести предоплату в размере не менее 25% от стоимости заказа, чтобы ваш заказ был отправлен в работу, до того, ваши заказы будут находиться в режиме ожидания. При регулярных заказах рекомендуем оформить договор, чтобы вы смогли получать накомительные бонусы.</p><p>Если вы еще не сделили заказ, рекомендуем ознакомиться со <a href=\"http://ikatalog.kz/Catalogues.aspx?Tag=active\">списком электронных каталогов</a> и <a href=\"http://ikatalog.kz/UpsellOffers.aspx\">горячих предожений</a>, также вы можете <a href=\"http://ikatalog.kz/Customer/OrdersPry.aspx\">посмотреть, что заказывают другие</a>.</p><h4>Какие данные нужны для заключения договора?</h4><p>Для оформления договора с нами и регистрации вас в бонусной системе вам необходимо предоставить следующие данные: ФИО, домашний адрес, дата рождения, номер удостоверения личности (или вид на жительство), дата выдачи и кем выдано УДЛ (ВНЖ).</p><h4>Как оплатить?</h4><p>Оплатить можно платежной картой на сайте или&nbsp;же наличными у нас в офисе. На странице <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=14\">Оплата</a> есть подобная информация о способах оплаты.</p><h4>Как заказать?</h4><p>Рекомендуем вам подробно ознакомиться с <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=1\">инструкцией о том, как это делать</a>.</p><h4>Из чего выбирать?!</h4><p>Для начала предлагаем вам ознакомиться со <a href=\"http://ikatalog.kz/Catalogues.aspx?Tag=active\">списком электронных каталогов</a>, по которым вы можете делать заказы on-line, не выходя из дома. Для Вашего удобства каталоги размещены по категориям. Также вы можете посмотреть текущие <a href=\"http://ikatalog.kz/UpsellOffers.aspx\">горячие предложения</a>, и&nbsp;<a href=\"http://ikatalog.kz/Customer/OrdersPry.aspx\">что заказывают другие</a>.</p><h4>Какой размер выбирать?!</h4><p>Для определения вашего размера на сайте в разделе Информация размещены <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=10\">таблицы соответствия и таблицы размеров одежды и обуви</a>.</p><h4>Есть ли накрутка на цену в каталоге?</h4><p>При заказе из некоторых каталогов взимается дополнительный сбор. Это указано под логотипом каталога, например: +18%. Если ничего не указано &mdash; вы получаете товар по цене каталога + доставка.</p><h4>Какова стоимость доставки?</h4><p>Стоимость доставки до нашего офиса в Алматы составляет 5 &euro; / килограмм, также мы можем сделать для вас курьерскую доставку в пределах Алматы или в другие города, подробнее &mdash; в разделе <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=15\">Доставка</a>.</p><h4>Можно ли вернуть заказанный товар?</h4><p>Некоторые из он-лайн магазинов, к сожалению, работают без возвратов (MyToys, YOOX, ZARA и др.). Это так же обозначено специальным значком рядом с логотипом каталога. При заказе c остальных каталогов можно вернуть заказанный товар, оплатив при этом стоимость доставки.</p><hr /><p>С уважением, Галина<br />Руководитель проекта <a href=\"http://ikatalog.kz/\">iKatalog.kz</a><br />Skype: ikatalog<br />Тел.: +7 701 543 62 59<br />мкн Аксай 5<br /><a href=\"http://ikatalog.kz/Contacts.aspx\">Схема проезда</a></p></body></html>";

        KtradeSMTP.Send(NotifySeller);
        KtradeSMTP.Send(NotifyCustomer);
        KtradeSMTP.Send(ThankCustomer);

        NotifyCustomer.Dispose();
        NotifySeller.Dispose();
        ThankCustomer.Dispose();
    }
    protected void AccountLinkButton_Click(object sender, EventArgs e)
    {
	Response.Redirect("~/Customer/OrdersInfo.aspx");
    }
    protected void ShowCalculator(object sender, EventArgs e)
    {
	CalculatorPanel.Visible = true;
	DeliveryLabel.Text = "";
	CalculationUpdatePanel.Update();
    }
    protected void CalculateButton_Click(object sender, EventArgs e)
    {
	float price;
	float weight;
	float percent;
	
	try
	{
	    price = Single.Parse(PriceInput.Text);
	    weight = Single.Parse(WeightInput.Text);
	}
	catch
	{
	    price = 0;
	    weight = 0;
	}
	
	float index = getCatalogueIndex(CatalogueList.SelectedValue);
	//float index = 1 + percent / 100;
	float WeightFee = getCatalogueWeightFee(CatalogueList.SelectedValue.ToString());
	float Xrate = getCurrencyRate();
	
	double finalPrice = Math.Round (price * index + weight*WeightFee, 2);
	double advance = Math.Round (price * index / 2, 2);
	double finalPriceTenge = Math.Round (finalPrice * Xrate);
	double advanceTenge = Math.Round (advance * Xrate);
	
	if (finalPrice == 0)
	{
	    DeliveryLabel.Text = "Не удалось посчитать, возможно не выбран каталог или неверно указаны цена и вес товара.";
	}
	else
	{
	    DeliveryLabel.Text = "Стоимость заказа с доставкой до Алматы: <b>" + finalPrice.ToString() + " €</b><br/> В тенге по текущему курсу: " + finalPriceTenge.ToString() + " &#8376;";
	}

	CalculationUpdatePanel.Update();
    }
    public float getCurrencyRate()
    {
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
    protected void CreateLog (string Message)
    {
	string LogFile = Server.MapPath("~/Logs/") + "Main";
	string LogString = DateTime.Now.ToShortDateString().ToString()+" "+DateTime.Now.ToLongTimeString().ToString()+" ==> " + Message;
	
	StreamWriter SW = new StreamWriter(LogFile,true);
	SW.WriteLine(LogString);
	SW.Flush();
	SW.Close();
    }
}

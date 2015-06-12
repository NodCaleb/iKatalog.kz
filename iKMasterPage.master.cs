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
	
	//iClass.CreateLog("Class imported", "ClassTest");
	//CreateLog(Guid.NewGuid().ToString().Substring(1,6));
	if (Request.QueryString["action"] == "register") RegisterFormPanel.Visible = true;
	if (Request.QueryString["action"] == "calc") CalculatorPanel.Visible = true;
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

		    string userFullName = UserCredentials["FullName"].ToString();

		    if (userFullName.Length > 25) UserNameLabel.Text = userFullName.Substring(0,22) + "...";
		    else UserNameLabel.Text = userFullName;
		    
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
	XrateLabel.Text = iClass.GetXrate().ToString();
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
		
		if (Request.QueryString["ReturnUrl"] != null) FormsAuthentication.RedirectFromLoginPage(EmailTextBox.Text, true);
		else
		{
		    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(EmailTextBox.Text, true, 30);
		    string encTicket = FormsAuthentication.Encrypt(ticket);
		    Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
		    Response.Redirect("~/Customer/RegisterSuccess.aspx?username=" + EmailTextBox.Text);
		}
	    }
	    else
	    {
		Response.Redirect("~/Customer/RegisterFail.aspx");
	    }
        }
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
	
	float index = iClass.getCatalogueIndex(CatalogueList.SelectedValue);
	//float index = 1 + percent / 100;
	float WeightFee = iClass.getCatalogueWeightFee(CatalogueList.SelectedValue.ToString());
	float Xrate = iClass.getCurrencyRate();
	
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
}

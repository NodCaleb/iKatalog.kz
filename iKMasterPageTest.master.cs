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

public partial class iKMasterPage : System.Web.UI.MasterPage
{
    public MembershipUser AuthorizedUser;

    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string UserQueryString = "select top 1 FullName, FirstName, IsAdmin, Customer_id, Alias, Email, ContractNumber from CustomerInfo where User_id = @User_id";
    static string RegisterRequestString = "insert into AskMeRequests (Name, Email, Phone, Request, Source) values (@Name, @Email, @Phone, @Request, @Source)";
    
    SqlCommand UserInfo = new SqlCommand(UserQueryString, iKConnection);
    SqlCommand RegisterRequest = new SqlCommand(RegisterRequestString, iKConnection);    
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	
	//Page.MetaDescription = "Мы предоставляем услуги доставки товаров по каталогам - OTTO, H&M, Lacoste, ZARA, MEXX, Amazon и других - из Германии. Вашему вниманию предлагаются более 130 европейских каталогов одежды онлайн с огромным ассортиментом товаров на любой вкус для людей разного возраста.";

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

					//UserFullNameDisplay.Text = "Здравствуйте, " + UserCredentials["FirstName"].ToString();
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
			
            LoginMultiView.ActiveViewIndex = 1;
        	if (Session["Admin"] == "true")	AdminHyperLink.Visible = true;
        }
        else
        {
            Session["Customer"] = "-1";
            LoginMultiView.ActiveViewIndex = 0;
        }        
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
        if (Membership.ValidateUser(UserNameTextBox.Text, PasswordTextBox.Text))
        {
            if (Request.QueryString["ReturnUrl"] != null) FormsAuthentication.RedirectFromLoginPage(UserNameTextBox.Text, true);
	    else
	    {
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(UserNameTextBox.Text, true, 30);
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
    protected void AskMeButton_Click(object sender, EventArgs e)
    {
	if (Page.IsValid)
	{
	    string SourceCookie;

            if(Request.Cookies["Visitor source"] != null)
            {
                SourceCookie = Request.Cookies["Visitor source"].Value;
            }
            else
            {
                SourceCookie = "Unknown";
            }
	    
	    if (RegisterRequest.Parameters.Count != 0) RegisterRequest.Parameters.Clear();    
	    RegisterRequest.Parameters.AddWithValue("Name", NameInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Email", EmailInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Phone", PhoneInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Request", SearchInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Source", SourceCookie);
	    RegisterRequest.ExecuteNonQuery();
	    
	    SmtpClient iKatalogSMTP = new SmtpClient();

	    MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
	    MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
	    MailAddress Office = new MailAddress("es@ikatalog.kz", "Офис");
	    MailMessage NotifyOffice = new MailMessage();
	    NotifyOffice.From = Admin;
	    NotifyOffice.To.Add(Sale);
	    NotifyOffice.To.Add(Office);
	    NotifyOffice.To.Add(Admin);
	    NotifyOffice.IsBodyHtml = true;
	    NotifyOffice.BodyEncoding = System.Text.Encoding.UTF8;
	    NotifyOffice.SubjectEncoding = System.Text.Encoding.UTF8;
	    NotifyOffice.Subject = "Запрос на сайте, автор: " + NameInput.Text.ToString();
	    
	    NotifyOffice.Body = "<h2>Поступил такой запрос на сайте:</h2><p>Имя: " + NameInput.Text.ToString() + "</p><p>Телефон: " + PhoneInput.Text.ToString() + "</p><p>Email: <a href=\"mailto:" + EmailInput.Text.ToString() + "\">" + EmailInput.Text.ToString() + "</a></p><p>Чем интересуется: " + SearchInput.Text.ToString() + "</p>";
	
	    iKatalogSMTP.Send(NotifyOffice);
	    
            NameInput.Text = "";
            EmailInput.Text = "";
            PhoneInput.Text = "";
            SearchInput.Text = "";
	    
	    AskMultiView.ActiveViewIndex = 1;
	    
            AskMeUpdatePanel.Update();
	}
    }
    protected void FastOrderButton_Click(object sender, EventArgs e)
    {
	SmtpClient iKatalogSMTP = new SmtpClient();
	
	MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
	MailAddress Office = new MailAddress("eg@ikatalog.kz", "Офис");
	
	MailMessage FastOrder = new MailMessage();
	FastOrder.From = Admin;
	FastOrder.To.Add(Office);
        FastOrder.To.Add(Admin); //Для тестирования
	
	FastOrder.IsBodyHtml = true;
        FastOrder.BodyEncoding = System.Text.Encoding.UTF8;
        FastOrder.SubjectEncoding = System.Text.Encoding.UTF8;
        FastOrder.Subject = "Быстрый заказ на сайте от:" + NameInput.Text.ToString();
	
	FastOrder.Body = "<h2>На сайте был оформлен быстрый заказ</h2><p>Имя заказчика: " + NameTextBox.Text.ToString() + "</p><p>Телефон: " + PhoneTextBox.Text.ToString() + "</p><p>Email: <a href=\"mailto:" + EmailTextBox.Text.ToString() + "\">" + EmailTextBox.Text.ToString() + "</a></p><p>Товар: <a href=\"mailto:" + URLTextBox.Text.ToString() + "\">" + URLTextBox.Text.ToString() + "</a></p>";
	
	iKatalogSMTP.Send(FastOrder);
	
	NameTextBox.Text = "";
	PhoneTextBox.Text = "";
	EmailTextBox.Text = "";
	URLTextBox.Text = "";
	
	Response.Redirect("~/UpsellOffers.aspx?order=true");
    }
    protected void FastOrderLinkButton_Click(object sender, EventArgs e)
    {
	FastOrderPanel.Visible = true;
    }
    protected void LoginLinkButton_Click(object sender, EventArgs e)
    {
	LoginFormPanel.Visible = true;
    }
    protected void CancelButton_Click(object sender, EventArgs e)
    {
	LoginFormPanel.Visible = false;
	FastOrderPanel.Visible = false;
    }
    protected void RegisterLinkButton_Click(object sender, EventArgs e)
    {
	Response.Redirect("~/Customer/Register.aspx");
    }
    protected void AccountLinkButton_Click(object sender, EventArgs e)
    {
	Response.Redirect("~/Customer/OrdersInfo.aspx");
    }
}

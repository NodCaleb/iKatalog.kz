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

public partial class About : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string RegisterRequestString = "insert into AskMeRequests (Name, Email, Phone, Request, Source) values (@Name, @Email, @Phone, @Request, @Source)";
    static string SubcribeString = "insert into Subscribtion (Name, Email, Source) values (@Name,@Email,@Source)";
    SqlCommand RegisterRequest = new SqlCommand(RegisterRequestString, iKConnection);
    SqlCommand Subcribe = new SqlCommand(SubcribeString, iKConnection);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("~/LandingPage03.aspx");
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        //AskMultiView.ActiveViewIndex = 1;
        if (Request.QueryString["source"] != null)
        {
            Response.Cookies["Visitor source"].Value = Request.QueryString["source"].ToString();
            Response.Cookies["Visitor source"].Expires = DateTime.Now.AddDays(7);
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
	    
	    RequestMultiView.ActiveViewIndex = 1;
	    
            RequestUpdatePanel.Update();
	}
    }
    protected void SubscribeButton_Click(object sender, EventArgs e)
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
            
	    if (Subcribe.Parameters.Count != 0) Subcribe.Parameters.Clear();    
	    Subcribe.Parameters.AddWithValue("Name", SubscribeNameInput.Text);
	    Subcribe.Parameters.AddWithValue("Email", SubscribeEmailInput.Text);
            Subcribe.Parameters.AddWithValue("Source", SourceCookie);
	    Subcribe.ExecuteNonQuery();
	    
	    SubscribeMultiView.ActiveViewIndex = 1;
	    
            SubscribeUpdatePanel.Update();
	}
    }
}
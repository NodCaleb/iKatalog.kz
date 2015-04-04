using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data.Common;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using System.Configuration;
using iKGlobal;

public partial class Test_TestGeneral : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    
    static GlobalClass iClass = new GlobalClass();
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string RegisterRequestString = "insert into AskMeRequests (Name, Email, Phone, Request) values (@Name, @Email, @Phone, @Request)";
    SqlCommand RegisterRequest = new SqlCommand(RegisterRequestString, iKConnection);
    
    private static string CreateSalt(int size)
    {
        //Generate a cryptographic random number.
        RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
        byte[] buff = new byte[size];
        rng.GetBytes(buff);

        // Return a Base64 string representation of the random number.
        return Convert.ToBase64String(buff);
    
	//iClass.CreateLog(iClass.GetCumulatedOrders("204").ToString(), "ClassTest.txt");
    }    
    protected void Page_Load(object sender, EventArgs e)
    {
	iClass.CreateLog(iClass.GetCumulatedOrders("204").ToString(), "ClassTest.txt");
    }
    protected void AskMeButton_Click(object sender, EventArgs e)
    {
	if (Page.IsValid)
	{
	    if (RegisterRequest.Parameters.Count != 0) RegisterRequest.Parameters.Clear();    
	    RegisterRequest.Parameters.AddWithValue("Name", NameInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Email", EmailInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Phone", PhoneInput.Text);
	    RegisterRequest.Parameters.AddWithValue("Request", SearchInput.Text);
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
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    public MembershipUser AuthorizedUser;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);

    static string EcomPaymentDataString = "select top 1 convert (nvarchar (10), EComChargePayments.PaymentTime, 104) as PaymentDate , EComChargePayments.Ammount, C.FirstName, C.FirstName + ' ' + C.LastName as FullName, M.Email from EComChargePayments join Customers as C on EComChargePayments.Customer_id = C.Customer_id join aspnet_Membership as M on M.UserId = C.User_id where EComChargePayments.transaction_uid = @transaction_uid";
    
    SqlCommand EcomPaymentData = new SqlCommand(EcomPaymentDataString, iKConnection);    
    static string PaymentNo;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        String transaction_uid = Request.Params.Get("transaction_uid");
        if (transaction_uid != null)
        {
            bool Notified = IsNotificationSent(transaction_uid);
	    
	    if (!Notified)
	    {
		NoPaymentPanel.Visible = false;
		PaymentPanel.Visible = true;
		EcomPaymentData.Parameters.AddWithValue("transaction_uid", transaction_uid);
    
		SqlDataReader PaymentDataReader = EcomPaymentData.ExecuteReader();
		PaymentDataReader.Read();
		PaymentNo = transaction_uid + "";
		PaymentNoLabel.Text = PaymentNo;
		AmmountLabel.Text = PaymentDataReader["Ammount"].ToString();
    
		SmtpClient KtradeSMTP = new SmtpClient();
    
		//Адреса
		MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
		MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
		MailAddress Office = new MailAddress("es@ikatalog.kz", "Офис");
		MailAddress Customer = new MailAddress(PaymentDataReader["Email"].ToString(), PaymentDataReader["FullName"].ToString());
		MailMessage NotifySeller = new MailMessage();
		MailMessage NotifyCustomer = new MailMessage();
    
		//Сообщение для продавца
		NotifySeller.From = Admin;
		NotifySeller.To.Add(Sale);
		NotifySeller.To.Add(Office);
		NotifySeller.To.Add(Admin); //Для тестирования
		NotifySeller.IsBodyHtml = true;
		NotifySeller.BodyEncoding = System.Text.Encoding.UTF8;
		NotifySeller.SubjectEncoding = System.Text.Encoding.UTF8;
		NotifySeller.Subject = "Новый платеж через eComCharge от покупателя: " + PaymentDataReader["FullName"].ToString();
    
		//Сообщение для покупателя
		NotifyCustomer.From = Admin;
		NotifyCustomer.To.Add(Customer);
		NotifyCustomer.ReplyTo = Office;
		//NotifyCustomer.To.Add(Admin); //Для тестирования
		NotifyCustomer.IsBodyHtml = true;
		NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
		NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
		NotifyCustomer.Subject = "От вас принят платеж на сумму: " + PaymentDataReader["Ammount"].ToString();
    
		//Тела сообщений
		NotifyCustomer.Body = "<h3>Здравствуйте, от вас принят платеж через систему eComCharge:</h3><ul><li>№ счета: " + PaymentNo + "</li><li>Дата: " + PaymentDataReader["PaymentDate"].ToString() + "</li><li>Сумма: " + PaymentDataReader["Ammount"].ToString() + "</li></ul><p>Спасибо, что пользуетесь нашими услугами.</p>";
		NotifySeller.Body = "<h3>Поступил платеж через систему eComCharge:</h3><ul><li>Покупатель: " + PaymentDataReader["FullName"].ToString() + "</li><li>№ счета: " + PaymentNo + "</li><li>Дата: " + PaymentDataReader["PaymentDate"].ToString() + "</li><li>Сумма: " + PaymentDataReader["Ammount"].ToString() + "</li></ul>";
		KtradeSMTP.Send(NotifySeller);
		KtradeSMTP.Send(NotifyCustomer);
		
		CreateLog("Notification sent for: " + transaction_uid);
		
		ConfirmNotification(transaction_uid);
	    }
	    else
	    {
		CreateLog("Notification has been already sent for: " + transaction_uid);
	    }
        }
	
	
    }
    protected void CreateLog (string Message)
    {
	string LogFile = Server.MapPath("~/Logs/") + "eComCharge";
	string LogString = DateTime.Now.ToShortDateString().ToString()+" "+DateTime.Now.ToLongTimeString().ToString()+" ==> " + Message;
	
	StreamWriter SW = new StreamWriter(LogFile,true);
	SW.WriteLine(LogString);
	SW.Flush();
	SW.Close();
    }
    protected bool IsNotificationSent(string transaction_uid)
    {
	string CheckNotificationString = "select ISnull(EmailSent, 0) from eComChargePayments where transaction_uid = @transaction_uid";
	SqlCommand CheckNotification = new SqlCommand(CheckNotificationString, iKConnection);
	CheckNotification.Parameters.Clear();
	CheckNotification.Parameters.AddWithValue("transaction_uid", transaction_uid);
	try
	{
	    return (bool)CheckNotification.ExecuteScalar();
	}
	catch
	{
	    return false;
	}
    }
    protected void ConfirmNotification(string transaction_uid)
    {
	string ConfirmationString = "update eComChargePayments set EmailSent = 1 where transaction_uid = @transaction_uid";
	SqlCommand Confirmation = new SqlCommand(ConfirmationString, iKConnection);
	Confirmation.Parameters.Clear();
	Confirmation.Parameters.AddWithValue("transaction_uid", transaction_uid);
	Confirmation.ExecuteNonQuery();
	Confirmation.Parameters.Clear();
    }
}
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

public partial class Admin_OrderManagement : System.Web.UI.Page
{
	public ClientScriptManager CSM;
	public MembershipUser AuthorizedUser;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string CommitPaymentString = "update Zpayments set Committed = 1 where id = @Payment_id";
    static string PaymentDataString = "select top 1 convert (nvarchar (10), Z.PaymentTime, 104) as PaymentDate , Z.Ammount, C.FirstName, C.FirstName + ' ' + C.LastName as FullName, M.Email from ZPayments as Z join Customers as C on Z.Customer_id = C.Customer_id join aspnet_Membership as M on M.UserId = C.User_id where Z.id = @Payment_id";
    SqlCommand CommitPayment = new SqlCommand(CommitPaymentString, iKConnection);
    SqlCommand PaymentData = new SqlCommand(PaymentDataString, iKConnection);
    static int Payment_id;
    static string PaymentNo;
    
    
	protected void Page_Load(object sender, EventArgs e)
	{		
		if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
		
		//Session["SessionZPayment_id"] = 1; //Это для тестирования
		//HttpCookie Zcookie = Request.Cookies["ZPaymentData"];
		
		if (Request.Form["LMI_PAYMENT_NO"] != null)
		{
			PaymentNo = Request.Form["LMI_PAYMENT_NO"].ToString();
			Payment_id = Convert.ToInt32(PaymentNo);
	   
			NoPaymentPanel.Visible=false;
			PaymentPanel.Visible=true;
			
			//Payment_id = Session["SessionZPayment_id"].ToString();
			//Payment_id = Zcookie["ZPaymentid"].ToString();
			//PaymentNo = Payment_id;// ("000000").Substring(0,6 - Payment_id.Length) + Payment_id;
			
			CommitPayment.Parameters.AddWithValue("Payment_id", Payment_id);
			CommitPayment.ExecuteNonQuery();
			CommitPayment.Parameters.Clear();
			
			//Session.Remove("SessionZPayment_id");
			
			PaymentData.Parameters.AddWithValue("Payment_id", Payment_id);
			
			SqlDataReader PaymentDataReader = PaymentData.ExecuteReader();
			PaymentDataReader.Read();
			
			PaymentNoLabel.Text = PaymentNo;
			AmmountLabel.Text = PaymentDataReader["Ammount"].ToString();
			
			SmtpClient KtradeSMTP = new SmtpClient();

			//Адреса
			MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
			MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
			MailAddress Office = new MailAddress("eg@ikatalog.kz", "Офис");
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
			NotifySeller.Subject = "Новый платеж через Z-Payment от покупателя: " + PaymentDataReader["FullName"].ToString();
			
			//Сообщение для покупателя
			//NotifyCustomer.From = Admin;
			NotifyCustomer.To.Add(Customer);
			NotifyCustomer.ReplyTo = Office;
			//NotifyCustomer.To.Add(Admin); //Для тестирования
			NotifyCustomer.IsBodyHtml = true;
			NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
			NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
			NotifyCustomer.Subject = "От вас принят платеж на сумму: " + PaymentDataReader["Ammount"].ToString();
			
			//Тела сообщений
			NotifyCustomer.Body = "<h3>Здравствуйте, от вас принят платеж через сисетму Z-Payment:</h3><ul><li>№ счета: " + PaymentNo + "</li><li>Дата: " + PaymentDataReader["PaymentDate"].ToString() + "</li><li>Сумма: " + PaymentDataReader["Ammount"].ToString() + "</li></ul><p>Спасибо, что пользуетесь нашими услугами.</p>";
			NotifySeller.Body = "<h3>Поступил платеж через сисетму Z-Payment:</h3><ul><li>Покупатель: " + PaymentDataReader["FullName"].ToString() + "</li><li>№ счета: " + PaymentNo + "</li><li>Дата: " + PaymentDataReader["PaymentDate"].ToString() + "</li><li>Сумма: " + PaymentDataReader["Ammount"].ToString() + "</li></ul>";
			
			KtradeSMTP.Send(NotifySeller);
			KtradeSMTP.Send(NotifyCustomer);
			
			/*if (Request.Cookies["ZPaymentData"] != null)
			{
				HttpCookie OldCookie = new HttpCookie("ZPaymentData");
				OldCookie.Expires = DateTime.Now.AddDays(-1d);
				Response.Cookies.Add(OldCookie);
			}*/
		}
        }
}
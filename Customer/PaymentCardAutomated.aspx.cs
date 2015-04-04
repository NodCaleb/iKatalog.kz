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
using System.Xml;
using WoopayWs;
using EcomCharge;
using Newtonsoft.Json;
using log4net;
using log4net.Config;

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    public MembershipUser AuthorizedUser;
	ILog logger = LogManager.GetLogger("PaymentOnline");
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string UserQueryString = "select top 1 FullName, FirstName, IsAdmin, Customer_id, Alias, Email, ContractNumber from CustomerInfo where User_id = @User_id";
    static string GetCustomerDataString = "select CustomerFullName, CustomerEmail from OrdersMetaData where Order_id = @Order_id";
    SqlCommand UserInfo = new SqlCommand(UserQueryString, iKConnection);
    SqlCommand GetCustomerData = new SqlCommand(GetCustomerDataString, iKConnection);
    static string Customer = "-1";
    static string CustomerName;
    static string UserMail;
    static string ContractNumber;
    static string Payment_id;

    static String CreateZTransactionString = "CreateZPaymentTransaction";
    static String CreateWoopayTransactionString = "CreateWoopayTransaction";
    static String CreateEcomTransactionString = "CreateEComChargeTransaction";
    static SqlCommand CreateZTransaction = new SqlCommand(CreateZTransactionString, iKConnection);
    static SqlCommand CreateWoopayTransaction = new SqlCommand(CreateWoopayTransactionString, iKConnection);
    static SqlCommand CreateEcomTransaction = new SqlCommand(CreateEcomTransactionString, iKConnection);
    static string AddWoopayIdString = "update WoopayPayments set Woopay_id = @Woopay_id where id = @Payment_id";
    static string SetEcomTranIdString = "update EComChargePayments set token = @token where tracking_id = @tracking_id";
    SqlCommand AddWoopayId = new SqlCommand(AddWoopayIdString, iKConnection);
    SqlCommand SetEcomTranId = new SqlCommand(SetEcomTranIdString, iKConnection);
    static String testLocation = "https://www-test.wooppay.com/api/wsdl?ws=1";
    static String prodLocation = "https://www.wooppay.com/api/wsdl?ws=1";
    //XmlControllerService webService = new XmlControllerService(prodLocation);
    XmlControllerService webService = new XmlControllerService(prodLocation);
    float currencyRate = 0;
    static string Order_id = "-1";
    static float Ammount = 0;


    protected void Page_Load(object sender, EventArgs e)
    {
        WebRequest myWebRequest = WebRequest.Create("http://ikatalog.kz/Customer/log4netConfig.xml");		
		WebResponse myWebResponse = myWebRequest.GetResponse();
		log4net.Config.DOMConfigurator.Configure(myWebResponse.GetResponseStream());
		logger.InfoFormat("Page_load");

		CSM = Page.ClientScript;
        //MethodsList.Items[0].Text += Server.HtmlDecode("<img src='../images/zlogo.png'>");  

	if (iKConnection.State.ToString() == "Closed") iKConnection.Open();

	if (Request.QueryString["ammount"] != null) Ammount = Single.Parse(Request.QueryString["ammount"].ToString().Replace(".",","));
	if (Request.QueryString["order"] != null) Order_id = Request.QueryString["order"].ToString();
	
	GetCustomerData.Parameters.Clear();
	GetCustomerData.Parameters.AddWithValue("Order_id", Order_id);
	SqlDataReader CustomerData = GetCustomerData.ExecuteReader();
	CustomerData.Read();

	if (CustomerData.HasRows)
	{
	    CustomerName = CustomerData["CustomerFullName"].ToString();
	}
	CustomerData.Close();
	
	AuthorizedUser = Membership.GetUser(); //если вдруг залогинен
        if (AuthorizedUser != null)
        {
            UserInfo.Parameters.AddWithValue("User_id", AuthorizedUser.ProviderUserKey.ToString());
            SqlDataReader UserCredentials = UserInfo.ExecuteReader();
            UserCredentials.Read();

            if (UserCredentials.HasRows)
            {
                Customer = UserCredentials["Customer_id"].ToString();
                UserMail = UserCredentials["Email"].ToString();
                ContractNumber = UserCredentials["ContractNumber"].ToString();
            }
            UserCredentials.Close();
        }
	
	if (Ammount > 0 && Order_id != "-1") ProcessPayment();
    }
    protected override void Render(HtmlTextWriter writer)
    {
        base.Render(writer);
    }
    protected void ProcessPayment()
    {
	logger.InfoFormat("eCommCharge choosed");
		    System.Net.ServicePointManager.ServerCertificateValidationCallback = (sender1, certificate, chain, errors) => true;
	logger.InfoFormat("Preparing sql for eCommCharge");
		    CreateEcomTransaction.CommandType = CommandType.StoredProcedure;
	if (CreateEcomTransaction.Parameters.Count != 0) CreateEcomTransaction.Parameters.Clear();

	SqlParameter Customer_id = new SqlParameter("@Customer_id", SqlDbType.NVarChar);
	Customer_id.Direction = ParameterDirection.Input;
	Customer_id.Value = Customer.ToString();
	CreateEcomTransaction.Parameters.Add(Customer_id);
	
	SqlParameter OrderId = new SqlParameter("@Order_id", SqlDbType.NVarChar);
	OrderId.Direction = ParameterDirection.Input;
	OrderId.Value = Order_id;
	CreateEcomTransaction.Parameters.Add(OrderId);

	SqlParameter AmmountValue = new SqlParameter("@Ammount", SqlDbType.NVarChar);
	AmmountValue.Direction = ParameterDirection.Input;
	AmmountValue.Value = Ammount.ToString().Replace(",", ".");//для SQL сервера;
	CreateEcomTransaction.Parameters.Add(AmmountValue);


	SqlParameter GetPayment_id = new SqlParameter("@Payment_id", SqlDbType.NVarChar);
	GetPayment_id.Direction = ParameterDirection.Output;
	GetPayment_id.Size = 38;
	CreateEcomTransaction.Parameters.Add(GetPayment_id);

	CreateEcomTransaction.ExecuteNonQuery();
	CreateEcomTransaction.Parameters.Clear();
	Payment_id = GetPayment_id.Value.ToString();
	CreateEcomTransaction.Parameters.Clear();
		    logger.InfoFormat("Sql execution finished");

	logger.InfoFormat("Preparing CheckoutRequest eCommCharge");
		    CheckoutRequest checkoutRequest = new CheckoutRequest();            
	Checkout checkout = new Checkout();
	checkout.transaction_type = "payment";
	
	Settings settings = new Settings();
	settings.success_url = "http://ikatalog.kz/Customer/ProcessEcomAutomated.aspx?result=success";
	settings.cancel_url = "http://ikatalog.kz/Customer/ProcessEcomAutomated.aspx?result=cancel";
	settings.fail_url = "http://ikatalog.kz/Customer/ProcessEcomAutomated.aspx?result=fail";
	settings.decline_url = "http://ikatalog.kz/Customer/ProcessEcomAutomated.aspx?result=decline";            
	settings.language = Languages.ru.ToString();
	checkout.settings = settings;
	
	Order order = new Order();
	order.amount = Math.Round(Ammount * 100).ToString();
	order.currency = "EUR";
	order.description = "Заказ №" + Order_id + ", покупатель: " + CustomerName;
	order.tracking_id = "I_KATALOG"+Payment_id;
	settings.notification_url = "http://ikatalog.kz/EcomCallbackNotification/EcomCallbackNotification.aspx?tracking_id=" + "I_KATALOG" + Payment_id; ;
	checkout.order = order;

	Customer customer = new Customer();
	checkout.customer = customer;
	checkoutRequest.checkout = checkout;
	string json = JsonConvert.SerializeObject(checkoutRequest);			
		    logger.InfoFormat("Finished CheckoutRequest eCommCharge");
		    logger.InfoFormat("Starting executing CheckoutRequest eCommCharge");
	RestClient restClient = new RestClient("https://checkout.ecomcharge.com/ctp/api/checkouts", HttpVerb.POST, json, "320", "c59a26ca8de335b3e39f4deb2884783b052ef4e9606279c36ffddbddf30c7ed2");
	string response = restClient.MakeRequest("application/json");
		    logger.InfoFormat("Finished executing CheckoutRequest eCommCharge");
		    logger.InfoFormat("Saving token in DB");
	CheckoutResponse resp = JsonConvert.DeserializeObject<CheckoutResponse>(response);
	SetEcomTranId.Parameters.AddWithValue("token", resp.checkout.token);//сохраняем полученный токен для нашего перевода
	SetEcomTranId.Parameters.AddWithValue("tracking_id", "I_KATALOG" + Payment_id);
	SetEcomTranId.ExecuteNonQuery();
	SetEcomTranId.Parameters.Clear();
		    logger.InfoFormat("Saved token in DB");
	Response.Redirect("https://checkout.ecomcharge.com/checkout?token=" + resp.checkout.token);
		    logger.InfoFormat("finished");
    }
    protected void CreateLog (string Message)
    {
	string LogFile = Server.MapPath("~/Logs/") + "Checkout";
	string LogString = DateTime.Now.ToShortDateString().ToString()+" "+DateTime.Now.ToLongTimeString().ToString()+" ==> " + Message;
	
	StreamWriter SW = new StreamWriter(LogFile,true);
	SW.WriteLine(LogString);
	SW.Flush();
	SW.Close();
    }
}
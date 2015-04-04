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
    SqlCommand UserInfo = new SqlCommand(UserQueryString, iKConnection);
    static string Customer;
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


    protected void Page_Load(object sender, EventArgs e)
    {
        WebRequest myWebRequest = WebRequest.Create("http://ikatalog.kz/Customer/log4netConfig.xml");		
		WebResponse myWebResponse = myWebRequest.GetResponse();
		log4net.Config.DOMConfigurator.Configure(myWebResponse.GetResponseStream());
		logger.InfoFormat("Page_load");

		CSM = Page.ClientScript;
        //MethodsList.Items[0].Text += Server.HtmlDecode("<img src='../images/zlogo.png'>");  

        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();

        AuthorizedUser = Membership.GetUser();
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
	if (Request.QueryString["ammount"] != null)
        {
            AmmountInput.Text = Request.QueryString["ammount"].ToString();
        }
	if (Request.QueryString["order"] != null) Order_id = Request.QueryString["order"].ToString();
	
	MethodsList.SelectedIndex = 0;
	
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(MethodsList.UniqueID.ToString());
        CSM.RegisterForEventValidation(ZPaymentButton.UniqueID.ToString());
        base.Render(writer);
    }
    protected void ZPaymentButton_Click(object sender, EventArgs e)
    {
        /* Это была попытка сделать POST-запрос, жаль, что пока не сработало
        ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(AcceptAllCertifications);
        System.Net.WebRequest ZpaymentPOST = System.Net.WebRequest.Create(@"https://z-payment.com/merchant.php");
        ZpaymentPOST.Method = "POST"; // Устанавливаем метод передачи данных в POST
        ZpaymentPOST.Timeout = 120000; // Устанавливаем таймаут соединения
        ZpaymentPOST.ContentType = "application/x-www-form-urlencoded"; // указываем тип контента
        // передаем список пар параметров / значений для запрашиваемого скрипта методом POST
        // здесь используется кодировка cp1251 для кодирования кирилицы и спец. символов в значениях параметров
        // Если скрипт должен принимать данные в utf-8, то нужно выбрать Encodinf.UTF8
        byte[] ZPaymentData = Encoding.GetEncoding(1251).GetBytes("LMI_PAYEE_PURSE=" + System.Web.HttpUtility.UrlEncode("12142", Encoding.GetEncoding(1251)));
        ZpaymentPOST.ContentLength = ZPaymentData.Length;
        Stream ZStream = ZpaymentPOST.GetRequestStream();
        ZStream.Write(ZPaymentData, 0, ZPaymentData.Length);
        ZStream.Close();
        //System.Net.WebResponse result = reqPOST.GetResponse();
    	
        //SomeBytes = Encoding.GetEncoding(1251).GetBytes("ParamName1=" + HttpUtility.UrlEncode("ParamValue1", Encoding.GetEncoding(1251)));
        */
        string amountString1 = AmmountInput.Text.Replace(",", "."); //число с точкой разделителем
        string amountString2 = AmmountInput.Text.Replace(".", ","); //и с запятой есть
        float amount=0;
        
        //если хоть одно валидно как число то это точно было число
        if (!float.TryParse(amountString1, out amount) && !float.TryParse(amountString2, out amount))
        {
            return;
        }

        /* if (MethodsList.SelectedIndex == 0)
        {
            CreateZTransaction.CommandType = CommandType.StoredProcedure;
            if (CreateZTransaction.Parameters.Count != 0) CreateZTransaction.Parameters.Clear();

            SqlParameter Customer_id = new SqlParameter("@Customer_id", SqlDbType.NVarChar);
            Customer_id.Direction = ParameterDirection.Input;
            Customer_id.Value = Customer.ToString();
            CreateZTransaction.Parameters.Add(Customer_id);

            SqlParameter Ammount = new SqlParameter("@Ammount", SqlDbType.NVarChar);
            Ammount.Direction = ParameterDirection.Input;
            Ammount.Value = amount.ToString().Replace(",", ".");//для SQL сервера;
            CreateZTransaction.Parameters.Add(Ammount);

            SqlParameter GetPayment_id = new SqlParameter("@Payment_id", SqlDbType.NVarChar);
            GetPayment_id.Direction = ParameterDirection.Output;
            GetPayment_id.Size = 38;
            //Payment_id.Value = Payment_id;
            CreateZTransaction.Parameters.Add(GetPayment_id);

            CreateZTransaction.ExecuteNonQuery();
            Payment_id = GetPayment_id.Value.ToString();
            CreateZTransaction.Parameters.Clear();

            //Session["SessionZPayment_id"] = Payment_id;

            HttpCookie Zcookie = Request.Cookies["ZPaymentData"];
            if (Zcookie == null)
            {
                Zcookie = new HttpCookie("ZPaymentData");
            }

            Zcookie["ZPaymentid"] = Payment_id.ToString();
            Zcookie.Expires = DateTime.Now.AddMinutes(60);
            Response.Cookies.Add(Zcookie);

            Response.Redirect("~/Customer/ProcessZPayment.aspx?ContractNumber=" + ContractNumber + "&LMI_PAYMENT_AMOUNT=" + AmmountInput.Text.ToString() + "&CLIENT_MAIL=" + UserMail + "&Payment_id=" + Payment_id);
        }
        else if (MethodsList.SelectedIndex == 1) //если выбран Woopay
        {
            CreateWoopayTransaction.CommandType = CommandType.StoredProcedure;
            if (CreateWoopayTransaction.Parameters.Count != 0) CreateWoopayTransaction.Parameters.Clear();

            SqlParameter Customer_id = new SqlParameter("@Customer_id", SqlDbType.NVarChar);
            Customer_id.Direction = ParameterDirection.Input;
            Customer_id.Value = Customer.ToString();
            CreateWoopayTransaction.Parameters.Add(Customer_id);

            SqlParameter Ammount = new SqlParameter("@Ammount", SqlDbType.NVarChar);
            Ammount.Direction = ParameterDirection.Input;
            if (getCurrencyRate() != null)
            {
                currencyRate = float.Parse(getCurrencyRate());
            }
            Ammount.Value = Math.Round(amount,2).ToString().Replace(",", "."); //для SQL разделитель десятичной дроби точка;
            CreateWoopayTransaction.Parameters.Add(Ammount);

            SqlParameter GetPayment_id = new SqlParameter("@Payment_id", SqlDbType.NVarChar);
            GetPayment_id.Direction = ParameterDirection.Output;
            GetPayment_id.Size = 38;
            CreateWoopayTransaction.Parameters.Add(GetPayment_id);

            CreateWoopayTransaction.ExecuteNonQuery();
            CreateWoopayTransaction.Parameters.Clear();
            Payment_id = GetPayment_id.Value.ToString();
            CreateWoopayTransaction.Parameters.Clear();
            LoginToWoopay();
            Response.Redirect(CreateWoopayInvoce(Payment_id,amount));
        }
        else */ if (MethodsList.SelectedIndex == 0) //если выбран eCommCharge
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
	    
	    SqlParameter Order = new SqlParameter("@Order_id", SqlDbType.NVarChar);
            Order.Direction = ParameterDirection.Input;
            Order.Value = Order_id;
            CreateEcomTransaction.Parameters.Add(Order);

            SqlParameter Ammount = new SqlParameter("@Ammount", SqlDbType.NVarChar);
            Ammount.Direction = ParameterDirection.Input;
            Ammount.Value = amount.ToString().Replace(",", ".");//для SQL сервера;
            CreateEcomTransaction.Parameters.Add(Ammount);


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
            settings.success_url = "http://ikatalog.kz/Customer/ProcessEcom.aspx?result=success";
            settings.cancel_url = "http://ikatalog.kz/Customer/ProcessEcom.aspx?result=cancel";
            settings.fail_url = "http://ikatalog.kz/Customer/ProcessEcom.aspx?result=fail";
            settings.decline_url = "http://ikatalog.kz/Customer/ProcessEcom.aspx?result=decline";            
            settings.language = Languages.ru.ToString();
            checkout.settings = settings;
            
            Order order = new Order();
            order.amount = Math.Round(amount * 100).ToString();
            order.currency = "EUR";
            order.description = "Платеж iKatalog";
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
    }

    /// <summary>
    /// Логин мерчанта(нас) на Woopay
    /// </summary>
    private void LoginToWoopay()
    {
        webService.CookieContainer = new System.Net.CookieContainer();
        //webService.Credentials = new System.Net.NetworkCredential("test", "gjvtyzqgfhjkm!");//только для тестового сервера            
        CoreLoginRequest login = new CoreLoginRequest();
        login.username = "ktrade";
        //login.password = "PXbk263W";//test
        login.password = "VcZZKKbH";//prod
        CoreLoginResponse resp = webService.core_login(login);
    }

    /// <summary>
    /// создание инвойса
    /// </summary>
    /// <param name="orderId">наш номер платежа</param>
    /// <param name="amount">сумма в евро</param>
    /// <returns>возвращает уникальный урл платежа для Woopay</returns>
    private string CreateWoopayInvoce(String orderId, float amount)
    {
        CashCreateInvoiceRequest req = new CashCreateInvoiceRequest();
        req.addInfo = "Перевод номер №" + orderId;        
        if (getCurrencyRate()!=null)
        {
            currencyRate=float.Parse(getCurrencyRate());
        }
        req.amount = (float)Math.Round((amount * currencyRate),2); //сумма перевода в тенге по курсу
        req.backUrl = "http://ikatalog.kz/Customer/ProcessWoopay.aspx?opid=" + orderId; //сюда вернется с Woopay после платежа
        DateTime date = DateTime.Now.AddDays(1);
        req.deathDate = date.ToString("yyyy-MM-dd hh:mm:ss");//дата истечения срока платежа текущий день+1
        req.description = "Запрос перевода №" + orderId; //то что отобразиться на страничке Woopay в заголовке
        req.referenceId = orderId;//наш номер платежа для "Woopay
        req.requestUrl = "http://ikatalog.kz/Customer/ProcessWoopay.aspx?opid=" + orderId;// + "-" + date.ToString("yyyy-MM-dd-hh-mm-ss");
        CashCreateInvoiceResponse resp = webService.cash_createInvoice(req);
        if (resp.error_code == 5) //если необходима авторизация
        {
            LoginToWoopay();//снова логинимся
            CreateWoopayInvoce(orderId,amount); //и снова пытаемся сделать платеж
        }
        else if ((resp.error_code==0) && (resp.response != null)) //если получен ответ
        {
            AddWoopayId.Parameters.AddWithValue("Woopay_id", resp.response.operationId);//сохраняем полученный от woopay ИХ код для нашего перевода
            AddWoopayId.Parameters.AddWithValue("Payment_id", orderId);
            AddWoopayId.ExecuteNonQuery();
            AddWoopayId.Parameters.Clear();
            Session.Add("WoopayPaymentid", resp.response.operationId);            
            return resp.response.operationUrl;
        }
        return "~/Customer/PaymentOnline.aspx";
    }

    /// <summary>
    /// получение курса валюты
    /// </summary>
    /// <returns>текущий курс</returns>
    public string getCurrencyRate()
    {
        string XrateReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, GETDATE())";
        string XrateWriteString = "insert into Xrates (Xrate) values (@Xrate)";
        string XrateMorningReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, DATEADD(DD,-1,GETDATE()))";
        string XratMorningeWriteString = "insert into Xrates ([Date], Xrate) values (DATEADD(DD,-1,GETDATE()), @Xrate)";
        XmlTextReader Xreader = new XmlTextReader("http://www.nationalbank.kz/rss/rates_all.xml");
        SqlCommand XrateRead = new SqlCommand(XrateReadString, iKConnection);
        SqlCommand XrateWrite = new SqlCommand(XrateWriteString, iKConnection);
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        if (XrateRead.ExecuteScalar() != null)
        {
            return XrateRead.ExecuteScalar().ToString();
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
                return XrateRead.ExecuteScalar().ToString();
            }
            catch
            {
                return null;
            }
        }
    }

}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using WoopayWs;

public partial class rss : System.Web.UI.Page
{
    static string Payment_id;
    static String testLocation = "https://www-test.wooppay.com/api/wsdl?ws=1";
    static String prodLocation = "https://www.wooppay.com/api/wsdl?ws=1";
    XmlControllerService webService = new XmlControllerService(prodLocation);
    //XmlControllerService webService = new XmlControllerService(testLocation);
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string WoopayPaymentString = "select Woopay_id from WoopayPayments where id = @Op_Id";
    SqlCommand WoopayPaymentId = new SqlCommand(WoopayPaymentString, iKConnection);
    String operationId="";

    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Params.Get("opid") == null)
        {
            Response.Redirect("~/Customer/AllPaymentsHistory.aspx");
        }
        operationId = Request.Params.Get("opid");
        if (ValidateWoopayPayment())
        {
            Response.Redirect("~/Customer/WoopayPaymentSuccess.aspx?operationId=" + operationId);
        }
        else
        {
            Response.Redirect("~/Customer/AllPaymentsHistory.aspx");
        }

    }

    /// <summary>
    /// Логин мерчанта(нас) на Woopay
    /// </summary>
    private void LoginToWoopay()
    {
        webService.CookieContainer = new System.Net.CookieContainer();
        webService.Credentials = new System.Net.NetworkCredential("test", "gjvtyzqgfhjkm!");//только для тестового сервера            
        CoreLoginRequest login = new CoreLoginRequest();
        login.username = "ktrade";
        //login.password = "PXbk263W";//test
        login.password = "VcZZKKbH";//prod
        CoreLoginResponse resp = webService.core_login(login);
    }

    /// <summary>
    /// валидация платежа
    /// </summary>
    /// <returns>состояние платежа</returns>
    private bool ValidateWoopayPayment()
    {

        String Woopay_id = "";
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        WoopayPaymentId.Parameters.AddWithValue("Op_Id", operationId);
        SqlDataReader WoopayPaymentIdReader = WoopayPaymentId.ExecuteReader();
        WoopayPaymentId.Parameters.Clear();
        if (WoopayPaymentIdReader.Read())
        {
            Woopay_id = WoopayPaymentIdReader["Woopay_id"].ToString();
        }
        else
        {
            WoopayPaymentIdReader.Close();
            return false;            
        }
        WoopayPaymentIdReader.Close();
        CashGetOperationDataRequest req = new CashGetOperationDataRequest();
        int woopid = int.Parse(Woopay_id);
        req.operationId = new int[] { woopid };
        CashGetOperationDataResponse resp = webService.cash_getOperationData(req);
        if (resp.error_code == 5) //если истекла сессия
        {
            LoginToWoopay();//нужен вход на Woopay
            return ValidateWoopayPayment();//и валидация по новой
        }
        else if ((resp.error_code == 0) && (resp.response != null) && (resp.response.records!=null))
        {
            return resp.response.records[0].status == OperationStatus.OPERATION_STATUS_DONE; //проверка статуса платежа
        }
        else
        {
            return false;
        }
    }
}			
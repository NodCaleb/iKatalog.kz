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
using EcomCharge;
using Newtonsoft.Json;

public partial class rss : System.Web.UI.Page
{
    static string Payment_id;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string SetEcomTranString = "update EComChargePayments set transaction_uid=@tran_Id where token=@token";
    static string CommitEcomPaymentString = "update EComChargePayments set Committed = 1 where transaction_uid = @tran_Id";
    SqlCommand SetEcomTranCommand = new SqlCommand(SetEcomTranString, iKConnection);
    SqlCommand EcomCommitPayment = new SqlCommand(CommitEcomPaymentString, iKConnection);
    String transaction_uid = "";
    String token = "";

    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        transaction_uid = Request.Params.Get("uid");
        token = Request.Params.Get("token");
        if (Request.Params.Get("result") == null || Request.Params.Get("result") != "success")
        {
            Response.Redirect("~");
        }        
        if (ValidateEcomPayment())
        {

            EcomCommitPayment.Parameters.AddWithValue("tran_Id", transaction_uid);
            EcomCommitPayment.ExecuteNonQuery();
            EcomCommitPayment.Parameters.Clear();
            Response.Redirect("~/Customer/EcomPaymentAutomatedSuccess.aspx?transaction_uid=" + transaction_uid);
        }
        else
        {
            Response.Redirect("~");
        }

    }

    /// <summary>
    /// валидация платежа
    /// </summary>
    /// <returns>состояние платежа</returns>
    private bool ValidateEcomPayment()
    {
        System.Net.ServicePointManager.ServerCertificateValidationCallback = (sender1, certificate, chain, errors) => true;
        RestClient restClient = new RestClient("https://processing.ecomcharge.com/transactions/" + transaction_uid, HttpVerb.GET, "", "320", "c59a26ca8de335b3e39f4deb2884783b052ef4e9606279c36ffddbddf30c7ed2");
        string response = restClient.MakeRequest("");
        QueryResponse resp = JsonConvert.DeserializeObject<QueryResponse>(response);
        SetEcomTranCommand.Parameters.AddWithValue("tran_Id", resp.transaction.uid);
        SetEcomTranCommand.Parameters.AddWithValue("token", token);
        SetEcomTranCommand.ExecuteNonQuery();
        SetEcomTranCommand.Parameters.Clear();
        return resp.transaction.status == "successful";
    }
}			
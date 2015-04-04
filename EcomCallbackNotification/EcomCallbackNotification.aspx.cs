using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using EcomCharge;
using Newtonsoft.Json;

public partial class EcomCallbackNotification : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string SetEcomTranString = "update EComChargePayments set transaction_uid=@tran_Id where tracking_id=@tracking_id";
    static string CommitEcomPaymentString = "update EComChargePayments set Committed = 1 where transaction_uid = @tran_Id";
    SqlCommand SetEcomTranCommand = new SqlCommand(SetEcomTranString, iKConnection);
    SqlCommand EcomCommitPayment = new SqlCommand(CommitEcomPaymentString, iKConnection);
    String transaction_uid = "";
    String token = "";
    String tracking_id = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string authorizationHeader = Request.Headers["Authorization"];
        // Determine the beginning index of the Base64-encoded string in the Authorization header by finding the first space.
        // Add 1 to the index so we can properly grab the substring.
        if (!String.IsNullOrEmpty(authorizationHeader))
        {
            var beginPasswordIndexPosition = authorizationHeader.IndexOf(' ') + 1;
            var encodedAuth = authorizationHeader.Substring(beginPasswordIndexPosition);
            // Decode the authentication credentials.
            var decodedAuth = Encoding.UTF8.GetString(Convert.FromBase64String(encodedAuth));
            // Split the credentials into the username and password portions on the colon character.
            var splits = decodedAuth.Split(':');
            var username = splits[0];
            var password = splits[1];
            tracking_id = Request.Params.Get("tracking_id");
            Response.Write("<h3>"+tracking_id+"</h3>");
            Response.AddHeader("username", username);
            Response.AddHeader("password", password);
            
            //проверка на валидность
            if (username != "320" || password != "c59a26ca8de335b3e39f4deb2884783b052ef4e9606279c36ffddbddf30c7ed2")
            {
                return;
            }

            NotificationCallbackRequest resp = JsonConvert.DeserializeObject<NotificationCallbackRequest>(GetDocumentContents(Request));
            if (resp.transaction.status != "successful")
            {
                return;
            }
            transaction_uid = resp.transaction.uid;
            iKConnection.Open();
            SqlTransaction tran=iKConnection.BeginTransaction();
            try
            {               
                SetEcomTranCommand.Transaction = tran;
                SetEcomTranCommand.Parameters.AddWithValue("tran_Id", transaction_uid);
                SetEcomTranCommand.Parameters.AddWithValue("tracking_id", tracking_id);
                SetEcomTranCommand.ExecuteNonQuery();
                SetEcomTranCommand.Parameters.Clear();

                EcomCommitPayment.Transaction = tran;
                EcomCommitPayment.Parameters.AddWithValue("tran_Id", transaction_uid);
                EcomCommitPayment.ExecuteNonQuery();
                EcomCommitPayment.Parameters.Clear();
                tran.Commit();
            }
            catch (Exception ex)
            {
                tran.Rollback();
            }
            finally
            {
                iKConnection.Close();
            }            
        }
    }

    private string GetDocumentContents(System.Web.HttpRequest Request)
    {
        string documentContents;
        using (Stream receiveStream = Request.InputStream)
        {
            using (StreamReader readStream = new StreamReader(receiveStream, Encoding.UTF8))
            {
                documentContents = readStream.ReadToEnd();
            }
        }
        return documentContents;
    }
}
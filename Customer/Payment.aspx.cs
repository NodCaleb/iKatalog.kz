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

public partial class Customer_Payment : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string CheckAccountString = "select count (*) as FullName from Customers where Customer_id = @Customer_id";
    static string GetFullNameString = "select FullName from CustomerInfo where Customer_id = @Customer_id";
    //static string MakePaymentString = "insert into Payments (txn_id, txn_date, Customer_id, Ammount, trm_id) values (@txn_id, dbo.ConvertQiwiDate (@txn_date), @Customer_id, @Ammount, @trm_id)";
    static string MakePaymentString = "exec ArrangeQiwiPayment @txn_id = @txn_id, @Customer_id = @Customer_id, @txn_date = @txn_date, @Ammount = @Ammount, @trm_id = @trm_id";
    static string CheckPaymentString = "select * from Payments where txn_id = @txn_id";
    static SqlCommand CheckAccount = new SqlCommand(CheckAccountString, iKConnection);
    static SqlCommand GetFullName = new SqlCommand(GetFullNameString, iKConnection);
    static SqlCommand MakePayment = new SqlCommand(MakePaymentString, iKConnection);
    static SqlCommand CheckPayment = new SqlCommand(CheckPaymentString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();    
        
        Response.ContentType = "text/xml";
        Response.ContentEncoding = Encoding.UTF8;

        XmlTextWriter XMLWriter = new XmlTextWriter(Response.OutputStream, Encoding.UTF8);

        WriteOpening(XMLWriter);

        if (Request.QueryString["command"] == "check")
        {
            WriteCheckBody(XMLWriter);
        }

        if (Request.QueryString["command"] == "pay")
        {
            WritePayBody(XMLWriter);
        }

        WriteEnding(XMLWriter);

        XMLWriter.Flush();
        Response.End();
	
	Page.MetaDescription = "Специально для вашего удобства мы подключаем платежные системы для оплаты ваших заказов прямо на сайте, не выходя из дома. На этой странице вы можете ознакомиться с доступными способами оплаты и выбрать максимально удобный для вас.";
    }

    private void WriteOpening(XmlTextWriter XMLWriter)
    {
        String PItext = "version='1.0' encoding='UTF-8'";
        XMLWriter.WriteProcessingInstruction("xml", PItext);
        XMLWriter.WriteStartElement("response");
    }

    private void WriteCheckBody(XmlTextWriter XMLWriter)
    {
        XMLWriter.WriteElementString("osmp_txn_id", Request.QueryString["txn_id"].ToString());
        
        Int32 Customer = -1, Result = 0;

        try
        {
            Customer = Int32.Parse(Request.QueryString["account"].ToString());
        }
        catch
        {
            Result = 4;
        }        

        if (Result == 0)
        {
            CheckAccount.Parameters.Clear();
            CheckAccount.Parameters.AddWithValue("Customer_id", Customer.ToString());
			
            if (CheckAccount.ExecuteScalar().ToString() == "1")	Result = 0;
            else Result = 5;
        }
		
        XMLWriter.WriteElementString("result", Result.ToString());
		
		if (Result == 0)
        {
			GetFullName.Parameters.Clear();
            GetFullName.Parameters.AddWithValue("Customer_id", Customer.ToString());
			XMLWriter.WriteStartElement("fields");
			XMLWriter.WriteStartElement("field1");
			XMLWriter.WriteAttributeString("name", "ФИО");
			XMLWriter.WriteString(GetFullName.ExecuteScalar().ToString());
			XMLWriter.WriteEndElement();
			XMLWriter.WriteEndElement();
		}
		
        XMLWriter.WriteElementString("comment", "");
    }

    private void WritePayBody(XmlTextWriter XMLWriter)
    {
        Int32 Customer = -1, Result = 0;
        String Comment = "";

        try
        {
            Customer = Int32.Parse(Request.QueryString["account"].ToString());
        }
        catch
        {
            Result = 4;
        }

        if ((Request.QueryString["txn_id"] == null) |
            (Request.QueryString["txn_date"] == null) |
            (Request.QueryString["account"] == null) |
            (Request.QueryString["sum"] == null))
            Result = 8;

        if (Result == 0)
        {
            CheckAccount.Parameters.Clear();
            CheckAccount.Parameters.AddWithValue("Customer_id", Customer.ToString());

            if (CheckAccount.ExecuteScalar().ToString() == "1") Result = 0;
            else Result = 5;
        }

        if (Result == 0)
        {
            MakePayment.Parameters.Clear();
            MakePayment.Parameters.AddWithValue("Customer_id", Customer.ToString());
            MakePayment.Parameters.AddWithValue("txn_id", Request.QueryString["txn_id"].ToString());
            MakePayment.Parameters.AddWithValue("txn_date", Request.QueryString["txn_date"].ToString());
            MakePayment.Parameters.AddWithValue("Ammount", Request.QueryString["sum"].ToString());
            if (Request.QueryString["trm_id"] != null) MakePayment.Parameters.AddWithValue("trm_id", Request.QueryString["trm_id"].ToString());
            else MakePayment.Parameters.AddWithValue("trm_id", "-1");

            try
            {
                MakePayment.ExecuteNonQuery();
            }
            catch
            {
                Result = 300;
                Comment="Make payment fail";
            }        
        }

        if (Result == 0)
        {
            CheckPayment.Parameters.Clear();
            CheckPayment.Parameters.AddWithValue("txn_id", Request.QueryString["txn_id"].ToString());
            SqlDataReader CheckPaymentReader = CheckPayment.ExecuteReader();

            try
            {                
                CheckPaymentReader.Read();
                XMLWriter.WriteElementString("osmp_txn_id", CheckPaymentReader["txn_id"].ToString());
                XMLWriter.WriteElementString("prv_txn", CheckPaymentReader["id"].ToString());
                XMLWriter.WriteElementString("sum", CheckPaymentReader["Ammount"].ToString());
                XMLWriter.WriteElementString("result", Result.ToString());
                XMLWriter.WriteElementString("comment", "");
                CheckPaymentReader.Close();
            }
            catch
            {
                Result = 300;
                Comment="Check payment fail";
            }

        }

        if (Result != 0)
        {
            if (Request.QueryString["txn_id"] != null) XMLWriter.WriteElementString("osmp_txn_id", Request.QueryString["txn_id"].ToString());
            else XMLWriter.WriteElementString("osmp_txn_id", "");
            XMLWriter.WriteElementString("prv_txn", "-1");
            if (Request.QueryString["sum"] != null) XMLWriter.WriteElementString("sum", Request.QueryString["sum"].ToString());
            else XMLWriter.WriteElementString("sum", "");
            XMLWriter.WriteElementString("result", Result.ToString());
            XMLWriter.WriteElementString("comment", Comment);
        }
    }

    private void WriteEnding(XmlTextWriter XMLWriter)
    {
        XMLWriter.WriteEndElement();
        //XMLWriter.WriteEndElement();
    }
}
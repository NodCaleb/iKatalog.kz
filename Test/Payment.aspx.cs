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
    static string KtradeConnectionString = ConfigurationManager.ConnectionStrings["KtradeConnectionString"].ConnectionString;
    static SqlConnection KtradeConnection = new SqlConnection(KtradeConnectionString);
    static string CheckAccountString = "select count (*) as FullName from Customers where Customer_id = @Customer_id";
	static string GetFullNameString = "select FullName from CustomerInfo where Customer_id = @Customer_id";
    static string MakePaymentString = "insert into Payments (txn_id, txn_date, Customer_id, Ammount, trm_id) values (@txn_id, dbo.ConvertQiwiDate (@txn_date), @Customer_id, @Ammount, @trm_id)";
    static string CheckPaymentString = "select * from Payments where txn_id = @txn_id";
    static SqlCommand CheckAccount = new SqlCommand(CheckAccountString, KtradeConnection);
	static SqlCommand GetFullName = new SqlCommand(GetFullNameString, KtradeConnection);
    static SqlCommand MakePayment = new SqlCommand(MakePaymentString, KtradeConnection);
    static SqlCommand CheckPayment = new SqlCommand(CheckPaymentString, KtradeConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (KtradeConnection.State.ToString() == "Closed") KtradeConnection.Open();    
        
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
        
        Int16 Customer = -1, Result = 0;

        try
        {
            Customer = Int16.Parse(Request.QueryString["account"].ToString());
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
        Int16 Customer = -1, Result = 0;

        try
        {
            Customer = Int16.Parse(Request.QueryString["account"].ToString());
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
            XMLWriter.WriteElementString("comment", "");
        }
    }

    private void WriteEnding(XmlTextWriter XMLWriter)
    {
        XMLWriter.WriteEndElement();
        //XMLWriter.WriteEndElement();
    }
}
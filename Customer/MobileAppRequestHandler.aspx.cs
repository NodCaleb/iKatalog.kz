using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using System.Threading;
using System.Xml;
using iKGlobal;
using Newtonsoft.Json;

public partial class Request_Handler : System.Web.UI.Page
{
    /* Response codes:
    	
    	0 — OK
    	1 — Доступ запрещен
    	2 — Не определено действие
    	3 — Есть юзер с таким мылом
    	4 — Регистрация не удалась
    	5 — Ошибка чтения данных из базы
    	6 — Ошибка авторизации юзера
    	7 — Ошибка оформления заказа
    
    */
    
    static GlobalClass iClass = new GlobalClass();
    static HttpContext handlerContext;// = HttpContext.Current;
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        handlerContext = HttpContext.Current;
	
		Response.ContentType = "text/xml";
        Response.ContentEncoding = Encoding.UTF8;

        XmlTextWriter XMLWriter = new XmlTextWriter(Response.OutputStream, Encoding.UTF8);
	
		WriteOpening(XMLWriter);
	
	if (handlerContext.Request.Params["appId"] != "834F9EAF-B3C0-4FD1-B687-555394BC4E01")
	{
	    WriteNoAccess(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "register")
	{	
	    WriteRegister(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "getCatalogues")
	{	
	    XMLWriter.WriteAttributeString("Type", "catalogues");
	    WriteCtalogues(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "getOffers")
	{	
	    WriteOffers(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "login")
	{	
	    WriteLogin(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "arrangeOrder")
	{	
	    XMLWriter.WriteAttributeString("Type", "orderArrangementResult");
	    WriteOrderArrangement(XMLWriter);
	}
	else
	{
	    WriteNoAction(XMLWriter);
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
    private void WriteEnding(XmlTextWriter XMLWriter)
    {
        XMLWriter.WriteEndElement();
        //XMLWriter.WriteEndElement();
    }
    private void WriteNoAccess(XmlTextWriter XMLWriter)
    {
		XMLWriter.WriteElementString("result", "1");
    }
    private void WriteNoAction(XmlTextWriter XMLWriter)
    {
		XMLWriter.WriteElementString("result", "2");
    }
    private void WriteRegister(XmlTextWriter XMLWriter)
    {
        if (iClass.CheckEmailExistence(handlerContext.Request.Params["mail"].ToString()))
		{
			XMLWriter.WriteElementString("result", "3");
		}
		else
		{
			if (iClass.RegisterCustomerLite(handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString()))
			{
				iClass.SendRegisterNotifcations(handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString());
				XMLWriter.WriteElementString("result", "0");
			}
			else
			{
				XMLWriter.WriteElementString("result", "4");
			}
		}
    }
    private void WriteCtalogues(XmlTextWriter XMLWriter)
    {
		try
		{
			EnsureDatabaseConnection()
;
		
			string getCataloguesString = "SELECT * from ma_CataloguesView order by SortOrder, CatalogueName";
			SqlCommand getCataloguesCommand = new SqlCommand(getCataloguesString, iKConnection);		
		
			SqlDataReader cataloguesReader = getCataloguesCommand.ExecuteReader();
		
			XMLWriter.WriteStartElement("catalogues");
		
			while (cataloguesReader.Read())
			{
				XMLWriter.WriteStartElement("catalogue");
			
				XMLWriter.WriteAttributeString("Catalogue_id", cataloguesReader[0].ToString());
				XMLWriter.WriteAttributeString("CatalogueName", cataloguesReader[1].ToString());
				XMLWriter.WriteAttributeString("URL", cataloguesReader[2].ToString());
				XMLWriter.WriteAttributeString("CatalogueDescription", cataloguesReader[3].ToString());
				XMLWriter.WriteAttributeString("ImageURL", cataloguesReader[4].ToString());
				XMLWriter.WriteAttributeString("Terms", cataloguesReader[5].ToString());
				XMLWriter.WriteAttributeString("OrderingRules", cataloguesReader[6].ToString());
				XMLWriter.WriteAttributeString("Tags", cataloguesReader[7].ToString());
				XMLWriter.WriteAttributeString("SortOrder", cataloguesReader[8].ToString());
			
				XMLWriter.WriteEndElement();
			}
		
			XMLWriter.WriteEndElement();
		
			XMLWriter.WriteElementString("result", "0");
		
			cataloguesReader.Close();
		}
		catch
		{
			XMLWriter.WriteElementString("result", "5");
		}
		
    }
    private void WriteOffers(XmlTextWriter XMLWriter)
    {
		try
		{
			EnsureDatabaseConnection()
;
		
			string getCataloguesString = "SELECT * from ma_SpecialOffers order by RecordDate desc";
			SqlCommand getCataloguesCommand = new SqlCommand(getCataloguesString, iKConnection);		
		
			SqlDataReader cataloguesReader = getCataloguesCommand.ExecuteReader();
		
			XMLWriter.WriteStartElement("offers");
		
			while (cataloguesReader.Read())
			{
				XMLWriter.WriteStartElement("offer");
			
				XMLWriter.WriteAttributeString("Catalogue_id", cataloguesReader[0].ToString());
				XMLWriter.WriteAttributeString("CatalogueName", cataloguesReader[1].ToString());
				XMLWriter.WriteAttributeString("Article_id", cataloguesReader[2].ToString());
				XMLWriter.WriteAttributeString("ArticleNameDe", cataloguesReader[3].ToString());
				XMLWriter.WriteAttributeString("ArticleNameRu", cataloguesReader[4].ToString());
				XMLWriter.WriteAttributeString("Price", cataloguesReader[5].ToString());
				XMLWriter.WriteAttributeString("ImageUrl", cataloguesReader[6].ToString());
				XMLWriter.WriteAttributeString("CatalogueUrl", cataloguesReader[7].ToString());
				XMLWriter.WriteAttributeString("RecordDate", cataloguesReader[8].ToString());
			
				XMLWriter.WriteEndElement();
			}
		
			XMLWriter.WriteEndElement();
		
			XMLWriter.WriteElementString("result", "0");
		
			cataloguesReader.Close();
		}
		catch
		{
			XMLWriter.WriteElementString("result", "5");
		}
		
    }
    private void WriteOrderArrangement(XmlTextWriter XMLWriter)
    {
		//try
		//{
			dynamic orderItems = JsonConvert.DeserializeObject(handlerContext.Request.Params["orderContent"].ToString());
		
			foreach (Newtonsoft.Json.Linq.JObject item in orderItems)
			{
				AddItemToCart(item, handlerContext.Request.Params["customer"].ToString());
			}
			
			XMLWriter.WriteElementString("result", "0");
		/*}
		catch
		{
			XMLWriter.WriteElementString("result", "7");
		}*/
		
    }
    private void WriteLogin(XmlTextWriter XMLWriter)
    {
		string userName = "";
		if (handlerContext.Request.Params["userName"].ToString() != null) userName = handlerContext.Request.Params["userName"].ToString();
		string password = "";
		if (handlerContext.Request.Params["password"].ToString() != null) password = handlerContext.Request.Params["password"].ToString();
		
		try
		{
			if (Membership.ValidateUser(userName, password))
			{
				EnsureDatabaseConnection()
;
				
				string getUserDataString = "select * from ma_Users where UserName = @userName";
				SqlCommand getUserDataCommand = new SqlCommand(getUserDataString, iKConnection);
				
				getUserDataCommand.Parameters.Clear();
				getUserDataCommand.Parameters.AddWithValue("userName", userName);
		
				SqlDataReader userDataReader = getUserDataCommand.ExecuteReader();
				
				userDataReader.Read();
				
				XMLWriter.WriteStartElement("user");
			
				XMLWriter.WriteAttributeString("Customer_id", userDataReader[0].ToString());
				XMLWriter.WriteAttributeString("FullName", userDataReader[1].ToString());
				XMLWriter.WriteAttributeString("UserName", userDataReader[2].ToString());
				XMLWriter.WriteAttributeString("Email", userDataReader[3].ToString());
				XMLWriter.WriteAttributeString("Password", userDataReader[4].ToString());
				
			
				XMLWriter.WriteEndElement();
				
				XMLWriter.WriteElementString("result", "0");
			}
			else
			{
				XMLWriter.WriteElementString("result", "6");
			} 
		}
		catch
		{
			XMLWriter.WriteElementString("result", "5");
		}
		
    }
    private void EnsureDatabaseConnection()

    {
    	if (iKConnection.State.ToString() == "Closed") iKConnection.Open();

    }

    private void AddItemToCart(Newtonsoft.Json.Linq.JObject item, string Customer_id)
    {
    	string AddItemString = "insert into OrderItems (Order_id, Catalogue_id, Article_id, ArticleName, Price, Size, Colour, Comment, LineStatus, KtradeStatus_id, Customer_id, Session_id) values (-1, @Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @Comment, 10, 1, @Customer_id, @Session_id)";
    	SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    	
    	EnsureDatabaseConnection()
;
    	
    	AddItem.Parameters.Clear();
	    AddItem.Parameters.AddWithValue("Catalogue_id", item["catalogueId"].ToString());
	    AddItem.Parameters.AddWithValue("Article_id", item["number"].ToString());
	    AddItem.Parameters.AddWithValue("ArticleName", item["name"].ToString());
	    AddItem.Parameters.AddWithValue("Price", Decimal.Parse(item["price"].ToString()));
	    AddItem.Parameters.AddWithValue("Size", item["size"].ToString());
	    AddItem.Parameters.AddWithValue("Colour", item["color"].ToString());
		AddItem.Parameters.AddWithValue("Customer_id", Customer_id);
	    AddItem.Parameters.AddWithValue("Comment", "");
	    AddItem.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	    
	    AddItem.ExecuteNonQuery();
	    AddItem.Parameters.Clear();
    	
    	
    }
    
    private void ArrangeOrder(string session_id, string customer_id)
    {
    	string ArrangeOrderString = "ArrangeOrderBySession";
    	SqlCommand ArrangeOrder = new SqlCommand(ArrangeOrderString, iKConnection);
    	
    	EnsureDatabaseConnection();
    	
    	if (ArrangeOrder.Parameters.Count != 0) ArrangeOrder.Parameters.Clear();
    	
		ArrangeOrder.CommandType = CommandType.StoredProcedure;
	
		SqlParameter Customer = new SqlParameter("@Customer_id", SqlDbType.Int);
		Customer.Value = customer_id;
		Customer.Direction = ParameterDirection.Input;
		ArrangeOrder.Parameters.Add(Customer);
	
		SqlParameter SessionID = new SqlParameter("@Session_id", SqlDbType.NVarChar);
		SessionID.Value = session_id;
		SessionID.Direction = ParameterDirection.Input;
		ArrangeOrder.Parameters.Add(SessionID);
	
		SqlParameter Order = new SqlParameter("@Order_id", SqlDbType.Int);
		Order.Direction = ParameterDirection.Output;
		ArrangeOrder.Parameters.Add(Order);
    }
}
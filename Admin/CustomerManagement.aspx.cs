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
using iKGlobal;

public partial class Admin_CustomerManagement : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static string CustomerExportString ="select Name, Email from EmailExportView";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    SqlCommand CustomerExport = new SqlCommand(CustomerExportString, iKConnection);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
    }
    protected void ExportCustomersButton_Click(object sender, ImageClickEventArgs e)
    {
        int RowCount = 0;
        int RowNumber = 1;

        SqlDataReader RowCounter = CustomerExport.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Name;Email";

        SqlDataReader ExportReader = CustomerExport.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Customers export " + DateTime.Now.ToShortDateString() + ".csv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding("UTF-8"));

        Response.Redirect("~/" + FileName);
    }
    protected void UserCommand(Object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "Delete")
        {
            iClass.CreateLog("Deleting user: " + iClass.GetCustomerLoginByID(e.CommandArgument.ToString()) + ", with Customer_id: " + e.CommandArgument.ToString(), "Admin");
            Membership.DeleteUser(iClass.GetCustomerLoginByID(e.CommandArgument.ToString()), true);
            Response.Redirect(Request.RawUrl);
        }
    }
    protected void DoNotPress(object sender, EventArgs e)
    {
    	iClass.CreateLog("Pressed", "Service.txt");
    	
    	string getNewUsersString = "select M.Email, C.FirstName, '' from aspnet_Membership as M join aspnet_Users as U on U.UserId = M.UserId join Customers as C on C.User_id = M.UserId where M.CreateDate >= dateadd(MONTH, -1, GETDATE())";
    	//string getNewUsersString = "select * from Customers";
    	SqlCommand getNewUsers = new SqlCommand(getNewUsersString, iKConnection);
    	
    	SqlDataReader newCustReader = getNewUsers.ExecuteReader();
    	
    	while (newCustReader.Read())
    	{
    		iClass.CreateLog(newCustReader[0].ToString(), "Service.txt");
    		iClass.SendRegisterNotifcations(newCustReader[0].ToString(), newCustReader[1].ToString(), "");
    	}
    	
    	newCustReader.Close();
    }
}
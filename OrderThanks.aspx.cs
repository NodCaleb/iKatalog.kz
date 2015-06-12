using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using iKGlobal;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UpsellOffers : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	
		if (Request.QueryString["customer"] != null)
		{
			if (Membership.GetUser() != null && Membership.GetUser().UserName == Request.QueryString["customer"].ToString())
			{
				string username = Request.QueryString["customer"].ToString();
				string userpass = GetUserPass(username);
		
				PageContentLabel.Text = iClass.GetPageContent(30).Replace("%USER_MAIL%", username).Replace("%USER_PASS%", userpass);
			}
		}
        else PageContentLabel.Text = iClass.GetPageContent(35);
    }
    protected void MoreOffersButton_Click(object sender, EventArgs e)
    {
    	Page.Response.Redirect("~/UpsellOffers.aspx");
    }
    string GetUserPass(string username)
    {
        string GetUserpassString = "select M.Password from aspnet_Users as U join aspnet_Membership as M on M.UserId = U.UserId where U.UserName = @username";
        SqlCommand GetUserpass = new SqlCommand(GetUserpassString, iKConnection);
        
        GetUserpass.Parameters.Clear();
        GetUserpass.Parameters.AddWithValue("username", username);
        
        if (GetUserpass.ExecuteScalar() != null) return GetUserpass.ExecuteScalar().ToString();
		else return "";
    }
}
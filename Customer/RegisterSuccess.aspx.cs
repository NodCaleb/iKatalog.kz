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

public partial class Customer_Register : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	
	if (Request.QueryString["username"] != null) ShowCredentials (Request.QueryString["username"].ToString());
    }
    void ShowCredentials(string username)
    {
        string GetUserpassString = "select M.Password from aspnet_Users as U join aspnet_Membership as M on M.UserId = U.UserId where U.UserName = @username";
        SqlCommand GetUserpass = new SqlCommand(GetUserpassString, iKConnection);
        
        GetUserpass.Parameters.Clear();
        GetUserpass.Parameters.AddWithValue("username", username);
        
        if (GetUserpass.ExecuteScalar() != null)
        {
            CredentialsPanel.Visible = true;
            UserNameLabel.Text = username;
            PasswordLabel.Text = GetUserpass.ExecuteScalar().ToString();            
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Information : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
    }
}
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
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;

public partial class WishListView : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string CustomerInfoString = "select FullName from CustomerInfo where Customer_id = @Customer_id";
    SqlCommand CustomerInfo = new SqlCommand(CustomerInfoString, iKConnection);
    static int CustomerNumber;
    
        protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
        if ((Request.QueryString["customer"] != null) && (Request.QueryString["customer"].ToString().Length > 0))
        {
            try
            {
                CustomerNumber = Int32.Parse(Request.QueryString["customer"].ToString());
            }
            catch
            {
                CustomerNumber = -1;
            }
        }
        else
        {
            CustomerNumber = -1;
        }
        
        if (CustomerNumber >= 0)
        {
            ListPanel.Visible = false;
            WishesPanel.Visible = true;
            WishesSource.SelectParameters["Customer_id"].DefaultValue = Request.QueryString["customer"].ToString();
            
            if (WishesGridView.Rows.Count == 0)
            {
                NoListPanel.Visible = true;
                WishesPanel.Visible = false;
            }
            
            CustomerInfo.Parameters.AddWithValue("Customer_id", Request.QueryString["customer"].ToString());
            SqlDataReader CustomerInfoReader = CustomerInfo.ExecuteReader();
            CustomerInfoReader.Read();
            try
            {
                CustomerNameLabel0.Text = CustomerInfoReader["FullName"].ToString();
                CustomerNameLabel1.Text = CustomerInfoReader["FullName"].ToString();
                this.Page.Title = CustomerInfoReader["FullName"].ToString() + " список желаний";
            }
            catch
            {
                CustomerNameLabel0.Text = "Покупатель, которого мы не нашли";
                CustomerNameLabel1.Text = "Покупатель, которого мы не нашли";
            }
            CustomerInfoReader.Close();
        }
    }
}

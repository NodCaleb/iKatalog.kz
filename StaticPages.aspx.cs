using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class News : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string RequestTitleString = "select Name from StaticPages where id = @Page";
    SqlCommand RequestTitle = new SqlCommand(RequestTitleString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        //Page.Header.Title = "Ktrade - новости портала";
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        
        int PageId = -1;
        
        if (Request.QueryString["Page"] != null)
        {
            try
            {
                PageId = ValidatePageId(Int16.Parse(Request.QueryString["Page"].ToString()));

                RequestTitle.Parameters.AddWithValue("Page", PageId);
                SqlDataReader TitleReader = RequestTitle.ExecuteReader();
                TitleReader.Read();
                Page.Header.Title = TitleReader["Name"].ToString();
                Page.MetaDescription = TitleReader["Name"].ToString();
                TitleReader.Close();               
            }
            catch
            {
                PageId = -1;
                Page.Header.Title = "Нету страницы";
            }

            PageSource.SelectParameters["Page"].DefaultValue = PageId.ToString();
            //Page.Title = "Новость";
        }
        else
        {
            PageSource.SelectParameters["Page"].DefaultValue = "-1";
            Page.Header.Title = "Нету страницы";
        }            
    }
    
    protected int ValidatePageId(int PageId)
    {
        switch (PageId)
        {
            case 3: return 14;
            case 1: return 12;
            default: return PageId;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static string StockExportString ="exec ExportStockItems @date = @date, @quantity = @quantity";
    static string StockExportSizesString ="exec ExportStockItemsSizes @date = @date, @quantity = @quantity";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    SqlCommand StockExport = new SqlCommand(StockExportString, iKConnection);
    SqlCommand StockExportSizes = new SqlCommand(StockExportSizesString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        CSM = Page.ClientScript;
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
    }
    protected void StockGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Export")
        {
            int RowCount = 0;
            int RowNumber = 1;
            string date = e.CommandArgument.ToString();
            
            if (StockExport.Parameters.Count != 0) StockExport.Parameters.Clear();
            StockExport.Parameters.AddWithValue("date", date);
            StockExport.Parameters.AddWithValue("quantity", 1);
    
            SqlDataReader RowCounter = StockExport.ExecuteReader();
    
            while (RowCounter.Read())
            {
                ++RowCount;
            }
    
            ++RowCount;
            RowCounter.Close();
    
            string[] Content = new String[RowCount];
            Content[0] = "Category;SubCategory;ArticleNumber;ArticleName;ArticleDescription;Colour;ArticleURL;ImageURL;OldPrice;NewPrice;Quantity";
    
            SqlDataReader ExportReader = StockExport.ExecuteReader();
    
            while (ExportReader.Read())
            {
                Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString() + ";" + ExportReader[2].ToString() + ";" + ExportReader[3].ToString() + ";" + ExportReader[4].ToString() + ";" + ExportReader[5].ToString() + ";" + ExportReader[6].ToString() + ";" + ExportReader[7].ToString() + ";" + ExportReader[8].ToString() + ";" + ExportReader[9].ToString() + ";" + ExportReader[10].ToString();
                ++RowNumber;
            }
    
            ExportReader.Close();
    
            string FileName = "/ExportedOrders/CorsoStock_export_" + date + ".csv";
    
            File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding("UTF-8"));
    
            Response.Redirect("~/" + FileName);
        }
        if (e.CommandName == "ExportSizes")
        {
            int RowCount = 0;
            int RowNumber = 1;
            string date = e.CommandArgument.ToString();
            
            if (StockExportSizes.Parameters.Count != 0) StockExportSizes.Parameters.Clear();
            StockExportSizes.Parameters.AddWithValue("date", date);
            StockExportSizes.Parameters.AddWithValue("quantity", 1);
    
            SqlDataReader RowCounter = StockExportSizes.ExecuteReader();
    
            while (RowCounter.Read())
            {
                ++RowCount;
            }
    
            ++RowCount;
            RowCounter.Close();
    
            string[] Content = new String[RowCount];
            Content[0] = "ArticleNumber;Size;Quantity";
    
            SqlDataReader ExportReader = StockExportSizes.ExecuteReader();
    
            while (ExportReader.Read())
            {
                Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString() + ";" + ExportReader[2].ToString();
                ++RowNumber;
            }
    
            ExportReader.Close();
    
            string FileName = "/ExportedOrders/CorsoStock_export_sizes_" + date + ".csv";
    
            File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding("UTF-8"));
    
            Response.Redirect("~/" + FileName);
        }
    }
}
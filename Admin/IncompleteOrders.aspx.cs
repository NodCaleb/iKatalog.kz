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

public partial class Admin_IncompleteOrders : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
	static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
	

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
        //ActiveOrdersSource.SelectParameters["Order_id"].DefaultValue = '19962';
        //Order_Search_Input.Text = "19962";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());
        base.Render(writer);
    }
    protected void ExportCSVButton_Click(object sender, ImageClickEventArgs e)
    {
        EnsureDatabaseConnection()
;
        
        string ExportString = "select * from ImcompleteOrdersView order by CreationDate desc";
        SqlCommand ExportCommand = new SqlCommand(ExportString, iKConnection);
        
        int RowCount = 0;
        int RowNumber = 1;

        //char tabchar = (char)9;
        string tab = ";";// tabchar.ToString();

        SqlDataReader RowCounter = ExportCommand.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Клиент" + tab + "Каталог" + tab + "Артикул" + tab + "Наименование" + tab + "Цена" + tab + "Дата создания";

        SqlDataReader ExportReader = ExportCommand.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[11].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[12].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Incomplete_orders_" + DateTime.Now.ToShortDateString() + ".csv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
        
    }
    private void EnsureDatabaseConnection()
	{
if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	}

}
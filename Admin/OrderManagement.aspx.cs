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
    //static string QueryString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from OrderExportView where Order_id = @Order_id";
    static string KtradeImportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie], [URL], [DiscountValue] from KtradeExportView where Order_id = @Order_id";
    static string KtradeImportStringTotal = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie], [URL], [DiscountValue] from KtradeExportView";
    static string KtradeImportStringNew = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie], [URL], [DiscountValue] from KtradeExportView where OrderStatus = 1 and KtradeStatus_id = 1";
    static string OrderHeaderString = "select CustomerName, CustomerEmail, OrderStatus from OrderHeaders where Order_id = @Order_id";
    static string OrderTableString = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price, LineStatus, KtradeStatus from OrderDetailsView where Order_id = @Order_id";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    //SqlCommand KatSel = new SqlCommand(QueryString, iKConnection);
    SqlCommand KtradeImport = new SqlCommand(KtradeImportString, iKConnection);
    SqlCommand KtradeImportTotal = new SqlCommand(KtradeImportStringTotal, iKConnection);
    SqlCommand KtradeImportNew = new SqlCommand(KtradeImportStringNew, iKConnection);
    SqlCommand OrderHeader = new SqlCommand(OrderHeaderString, iKConnection);
    SqlCommand OrderTable = new SqlCommand(OrderTableString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
        //ActiveOrdersSource.SelectParameters["Order_id"].DefaultValue = '19962';
        //Order_Search_Input.Text = "19962";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(ActiveOrdersGridView.UniqueID.ToString());
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());
        base.Render(writer);
    }
    protected void ActiveOrdersGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "GetTAB")
        {
            int OrderNumber = int.Parse(e.CommandArgument.ToString());
            int RowCount = 0;
            int RowNumber = 1;

            if (KtradeImport.Parameters.Count != 0) KtradeImport.Parameters.Clear();
            KtradeImport.Parameters.AddWithValue("Order_id", OrderNumber);

            char tabchar = (char)9;
            string tab = tabchar.ToString();

            SqlDataReader RowCounter = KtradeImport.ExecuteReader();

            while (RowCounter.Read())
            {
                ++RowCount;
            }

            ++RowCount;
            RowCounter.Close();

            string[] Content = new String[RowCount];
            Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie" + tab + "URL" + tab + "Discount";

            SqlDataReader ExportReader = KtradeImport.ExecuteReader();

            while (ExportReader.Read())
            {
                Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString() + tab + ExportReader[9].ToString() + tab + ExportReader[10].ToString();
                ++RowNumber;
            }

            ExportReader.Close();

            string FileName = "/ExportedOrders/Order" + OrderNumber.ToString() + ".tsv";

            File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

            Response.Redirect("~/" + FileName);
        }

        if (e.CommandName == "NotifyCustomer")
        {
            if (OrderTable.Parameters.Count != 0) OrderTable.Parameters.Clear();
            OrderTable.Parameters.AddWithValue("Order_id", e.CommandArgument.ToString());
            if (OrderHeader.Parameters.Count != 0) OrderHeader.Parameters.Clear();
            OrderHeader.Parameters.AddWithValue("Order_id", e.CommandArgument.ToString());

            SqlDataReader HeaderReader = OrderHeader.ExecuteReader();

            HeaderReader.Read();

            SmtpClient KtradeSMTP = new SmtpClient();

            MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog");
            MailAddress Customer = new MailAddress(HeaderReader["CustomerEmail"].ToString(), HeaderReader["CustomerName"].ToString());
            MailAddress Office = new MailAddress("eg@ikatalog.kz", "Офис");
            MailMessage NotifyCustomer = new MailMessage();
            NotifyCustomer.From = Admin;
            NotifyCustomer.To.Add(Customer);
            NotifyCustomer.ReplyTo = Office;
            NotifyCustomer.IsBodyHtml = true;
            NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
            NotifyCustomer.Subject = "Статус заказа № " + e.CommandArgument.ToString() + " – " + HeaderReader["OrderStatus"];

            HeaderReader.Close();

            NotifyCustomer.Body = "<table border=\"1\" style=\"border-style:solid\" cellspacing=\"0\"> ";
            NotifyCustomer.Body += "<tr> <td> Каталог </td> <td> Артикул </td> <td> Наименование </td> <td> Цена </td> <td> Размер </td> <td> Цвет </td> <td> Статус артикула </td> </tr>";

            SqlDataReader TableReader = OrderTable.ExecuteReader();

            while (TableReader.Read())
            {
                NotifyCustomer.Body += "<tr> <td> " + TableReader["CatalogueName"] + " </td> <td> " + TableReader["Article_id"] + " </td> <td> <a href=\"" + TableReader["Comment"] + "\">" + TableReader["ArticleName"] + "</a> </td> <td> " + TableReader["Price"] + " </td> <td> " + TableReader["Size"] + " </td> <td> " + TableReader["Colour"] + " </td> <td> " + TableReader["KtradeStatus"] + " </td> </tr>";
            }

            //NotifyCustomer.Body += "</table><p><b>Пожалуйста, не отвечайте на это письмо, робот читать не умеет!</b></p><p>Чтобы связаться с нами, пишите на <a href=\"mailto:sale@ktrade.kz\">sale@ktrade.kz</a></p>.";

            TableReader.Close();

            KtradeSMTP.Send(NotifyCustomer);
        }
    }
    protected void ActiveOrdersGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderDetailsUpdatePanel.Update();
    }
    protected void KtradeExportTotalButton_Click(object sender, ImageClickEventArgs e)
    {
        int RowCount = 0;
        int RowNumber = 1;

        char tabchar = (char)9;
        string tab = tabchar.ToString();

        SqlDataReader RowCounter = KtradeImportTotal.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie" + tab + "URL" + tab + "Discount";

        SqlDataReader ExportReader = KtradeImportTotal.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString() + tab + ExportReader[9].ToString() + tab + ExportReader[10].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders total " + DateTime.Now.ToShortDateString() + ".tsv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
    }
    protected void KtradeExportNewButton_Click(object sender, ImageClickEventArgs e)
    {
        int RowCount = 0;
        int RowNumber = 1;

        char tabchar = (char)9;
        string tab = tabchar.ToString();

        SqlDataReader RowCounter = KtradeImportNew.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie" + tab + "URL" + tab + "Discount";

        SqlDataReader ExportReader = KtradeImportNew.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString() + tab + ExportReader[9].ToString() + tab + ExportReader[10].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders new " + DateTime.Now.ToShortDateString() + ".tsv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
    }
    protected void OrderDetailsGridView_DataBound(object sender, EventArgs e)
    {
        if (OrderDetailsGridView.Rows.Count == 0)
        {
            EmptyOrderLabel.Visible = true;
        }
        else
        {
            EmptyOrderLabel.Visible = false;
        }
    }
    protected void SuchenMachenButton_Click(object sender, EventArgs e)
    {
    	OrderDetailsUpdatePanel.Update();
    }
}
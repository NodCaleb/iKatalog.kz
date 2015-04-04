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
    //static string KtradeImportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView where Order_id = @Order_id";
    //static string KatorgImportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KatorgExportView where Order_id = @Order_id";
    //static string KtradeImportStringTotal = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView";
    //static string KatorgImportStringTotal = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KatorgExportView";
    //static string KtradeImportStringNew = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView where OrderStatus = 1";
    //static string KatorgImportStringNew = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KatorgExportView where OrderStatus = 1";
    //static string OrderHeaderString = "select CustomerName, CustomerEmail, OrderStatus from OrderHeaders where Order_id = @Order_id";
    //static string OrderTableString = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price, LineStatus, KtradeStatus from OrderDetailsView where Order_id = @Order_id";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    ////SqlCommand KatSel = new SqlCommand(QueryString, iKConnection);
    //SqlCommand KtradeImport = new SqlCommand(KtradeImportString, iKConnection);
    //SqlCommand KatorgImport = new SqlCommand(KatorgImportString, iKConnection);
    //SqlCommand KtradeImportTotal = new SqlCommand(KtradeImportStringTotal, iKConnection);
    //SqlCommand KatorgImportTotal = new SqlCommand(KatorgImportStringTotal, iKConnection);
    //SqlCommand KtradeImportNew = new SqlCommand(KtradeImportStringNew, iKConnection);
    //SqlCommand KatorgImportNew = new SqlCommand(KatorgImportStringNew, iKConnection);
    //SqlCommand OrderHeader = new SqlCommand(OrderHeaderString, iKConnection);
    //SqlCommand OrderTable = new SqlCommand(OrderTableString, iKConnection);
    static string DuplicateItemString = "exec DuplicateItem @Line_id";
    SqlCommand DuplicateItem = new SqlCommand(DuplicateItemString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
        Page.MetaDescription = "Посмотреть ваши прошлые заказы, которые были доставлены или отменены вы можете на этой странице.";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(ActiveOrdersGridView.UniqueID.ToString());
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());
        base.Render(writer);
    }
    /*
    protected void ActiveOrdersGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "GetCSV")
        {
            int OrderNumber = int.Parse(e.CommandArgument.ToString());
            int RowCount = 0;
            int RowNumber = 1;

            if (KatorgImport.Parameters.Count != 0) KatorgImport.Parameters.Clear();
            KatorgImport.Parameters.AddWithValue("Order_id", OrderNumber);

            SqlDataReader RowCounter = KatorgImport.ExecuteReader();

            while (RowCounter.Read())
            {
                ++RowCount;
            }

            ++RowCount;
            RowCounter.Close();

            string[] Content = new String[RowCount];
            Content[0] = "Klient;PVU-Card Nr;Katalog;Art Nr;Cena;Nazwanie;Razmer;Zwet;Primechanie";

            SqlDataReader ExportReader = KatorgImport.ExecuteReader();

            while (ExportReader.Read())
            {
                Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString() + ";" + ExportReader[2].ToString() + ";" + ExportReader[3].ToString() + ";" + ExportReader[4].ToString() + ";" + ExportReader[5].ToString() + ";" + ExportReader[6].ToString() + ";" + ExportReader[7].ToString() + ";" + ExportReader[8].ToString();
                ++RowNumber;
            }

            ExportReader.Close();

            string FileName = "/ExportedOrders/Order" + OrderNumber.ToString() + ".csv";

            File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

            Response.Redirect("~/" + FileName);
        }

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
            Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie";

            SqlDataReader ExportReader = KtradeImport.ExecuteReader();

            while (ExportReader.Read())
            {
                Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString();
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

            MailAddress Admin = new MailAddress("admin@ktrade.kz", "Ktrade");
            MailAddress Customer = new MailAddress(HeaderReader["CustomerEmail"].ToString(), HeaderReader["CustomerName"].ToString());
            MailAddress Office = new MailAddress("office@ktrade.kz", "Офис");
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
    */
    protected void ActiveOrdersGridView_SelectedIndexChanged(object sender, EventArgs e)
    {
        OrderDetailsUpdatePanel.Update();
    }
    /*
    protected void KatorgExportTotalButton_Click(object sender, ImageClickEventArgs e)
    {
        int RowCount = 0;
        int RowNumber = 1;

        SqlDataReader RowCounter = KatorgImportTotal.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Klient;PVU-Card Nr;Katalog;Art Nr;Cena;Nazwanie;Razmer;Zwet;Primechanie";

        SqlDataReader ExportReader = KatorgImportTotal.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString() + ";" + ExportReader[2].ToString() + ";" + ExportReader[3].ToString() + ";" + ExportReader[4].ToString() + ";" + ExportReader[5].ToString() + ";" + ExportReader[6].ToString() + ";" + ExportReader[7].ToString() + ";" + ExportReader[8].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders total " + DateTime.Now.ToShortDateString() + ".csv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
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
        Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie";

        SqlDataReader ExportReader = KtradeImportTotal.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders total " + DateTime.Now.ToShortDateString() + ".tsv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
    }

    protected void KatorgExportNewButton_Click(object sender, ImageClickEventArgs e)
    {
        int RowCount = 0;
        int RowNumber = 1;

        SqlDataReader RowCounter = KatorgImportNew.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Klient;PVU-Card Nr;Katalog;Art Nr;Cena;Nazwanie;Razmer;Zwet;Primechanie";

        SqlDataReader ExportReader = KatorgImportNew.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + ";" + ExportReader[1].ToString() + ";" + ExportReader[2].ToString() + ";" + ExportReader[3].ToString() + ";" + ExportReader[4].ToString() + ";" + ExportReader[5].ToString() + ";" + ExportReader[6].ToString() + ";" + ExportReader[7].ToString() + ";" + ExportReader[8].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders new " + DateTime.Now.ToShortDateString() + ".csv";

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
        Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie";

        SqlDataReader ExportReader = KtradeImportNew.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Orders new " + DateTime.Now.ToShortDateString() + ".tsv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(1251));

        Response.Redirect("~/" + FileName);
    }
    */
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
    protected void OrderDetailsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ReorderLine")
        {
            if (DuplicateItem.Parameters.Count != 0) DuplicateItem.Parameters.Clear();
            //DuplicateItem.CommandType = CommandType.StoredProcedure;
            //SqlParameter Line_id = new SqlParameter("@Line_id", SqlDbType.Int);
            //Line_id.Value = e.CommandArgument.ToString();
            //Line_id.Direction = ParameterDirection.Input;
            //DuplicateItem.Parameters.Add(Line_id);

            DuplicateItem.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            DuplicateItem.ExecuteNonQuery();
            Response.Redirect("NewOrder.aspx");
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data.Common;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.Drawing;

public partial class Admin_ImportData : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string KtradeConnectionString = ConfigurationManager.ConnectionStrings["KtradeConnectionString"].ConnectionString;
    static SqlConnection KtradeConnection = new SqlConnection(KtradeConnectionString);
    static SqlConnection OrderConnection = new SqlConnection(KtradeConnectionString);
    static string InsertQuery = "exec ImportKtradeStatusLine @OrderItem_id, @KtradeStatus";
    static string DeleteQuery = "delete from KtradeStatusImport where id = @ImportedLine_id";
    static string CancelQuery = "delete from KtradeStatusImport";
    static string ConfirmQuery = "exec ConfirmKtradeDataImport";
    static string OrderHeaderQuery = "select CustomerName, CustomerEmail, OrderStatus from OrderHeaders where Order_id = @Order_id";
    static string OrderTableQuery = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price, LineStatus, KtradeStatus from OrderDetailsView where Order_id = @Order_id";
    static string OrderListQuery = "select distinct OI.Order_id from KtradeStatusImport as KSI join OrderItems as OI on OI.id = KSI.OrderItem_id";
    static string UpdateOrderStatusQuery = "exec UpdateKtradeOrderStatus @Order_id = @Order_id";
    SqlCommand InsertCommand = new SqlCommand(InsertQuery, KtradeConnection);
    SqlCommand DeleteCommand = new SqlCommand(DeleteQuery, KtradeConnection);
    SqlCommand CancelCommand = new SqlCommand(CancelQuery, KtradeConnection);
    SqlCommand ConfirmCommand = new SqlCommand(ConfirmQuery, KtradeConnection);
    SqlCommand OrderHeader = new SqlCommand(OrderHeaderQuery, OrderConnection);
    SqlCommand OrderTable = new SqlCommand(OrderTableQuery, OrderConnection);
    SqlCommand OrderList = new SqlCommand(OrderListQuery, KtradeConnection);
    SqlCommand UpdateOrderStatusCommand = new SqlCommand(UpdateOrderStatusQuery, OrderConnection);

    public bool ProcessFile(string FileName)
    {
        string ImportString = @"Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" + FileName + @";Extended Properties=""Excel 8.0;HDR=YES;IMEX=1""";
        DbProviderFactory ImportFactory = DbProviderFactories.GetFactory("System.Data.OleDb");
        DbConnection ImportConnection = ImportFactory.CreateConnection();
        ImportConnection.ConnectionString = ImportString;
        string ImportQueryString = "select memo, ktradestatus from [Orders$]";
        DbCommand ImportCommand = ImportConnection.CreateCommand();

        //try
        //{
            ImportConnection.Open();
            ImportCommand.CommandText = ImportQueryString;
            DbDataReader ImportReader = ImportCommand.ExecuteReader();

            if (KtradeConnection.State.ToString() == "Closed") KtradeConnection.Open();

            while (ImportReader.Read())
            {
                //string Line_id = ImportReader[0].ToString().Substring(ImportReader[0].ToString().IndexOf("[") + 1, ImportReader[0].ToString().IndexOf("]") - ImportReader[0].ToString().IndexOf("[") - 1);
                string Line_id;
                if (ImportReader[0].ToString().IndexOf("_") == -1) Line_id = ImportReader[0].ToString();
                else Line_id = ImportReader[0].ToString().Substring(0, ImportReader[0].ToString().IndexOf("_"));
                InsertCommand.Parameters.AddWithValue("OrderItem_id", Line_id);
                InsertCommand.Parameters.AddWithValue("KtradeStatus", ImportReader[1].ToString());

                InsertCommand.ExecuteNonQuery();
                InsertCommand.Parameters.Clear();
            }

            ImportReader.Close();
            ImportConnection.Close();

            return true;
        //}
        //catch
        {
            return false;
        }

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (KtradeConnection.State.ToString() == "Closed") KtradeConnection.Open();
        CSM = Page.ClientScript;

        //if (ImportedStatusesView.Rows.Count > 0)
        //{
        //    ConfirmImportButton.Enabled = true;
        //    CancelImportButton.Enabled = true;
        //    NotifyCheckBox.Enabled = true;
        //    ConfirmImportButton.ForeColor = Color.Green;
        //    CancelImportButton.ForeColor = Color.Red;
        //}

        if (IsPostBack)
        {
            bool FileOK = true;
            string SavePath = Server.MapPath("~/ImportedOrders/");

            if (ImportFile.HasFile)
            {
                try
                {
                    if (ImportFile.PostedFile.ContentType.ToString() == "application/vnd.ms-excel") FileOK = true;
                }
                catch
                {
                    FileOK = false;
                }

                if (FileOK)
                {
                    HttpPostedFile ImportedFile = ImportFile.PostedFile;
                    string FilePath = SavePath + System.Guid.NewGuid().ToString() + ".xls";
                    ImportedFile.SaveAs(FilePath);

                    if (ProcessFile(FilePath))
                    {
                        Indicator.ForeColor = System.Drawing.Color.Green;
                        Indicator.Text = "Импорт выполнен успешно!";
                        ImportedStatusesView.DataBind();
                        ImportedDataUpdatePanel.Update();
                        ConfirmImportButton.Enabled = true;
                        CancelImportButton.Enabled = true;
                        NotifyCheckBox.Enabled = true;
                        ButtonsUpdatePanel.Update();
                    }
                    else
                    {
                        Indicator.ForeColor = System.Drawing.Color.Red;
                        Indicator.Text = "Ошибка импорта!";
                        ConfirmImportButton.Enabled = false;
                        CancelImportButton.Enabled = false;
                        NotifyCheckBox.Enabled = false;
                        ButtonsUpdatePanel.Update();
                    }
                }

                else
                {
                    Indicator.ForeColor = System.Drawing.Color.Red;
                    Indicator.Text = "Неверный файл!";
                    ConfirmImportButton.Enabled = false;
                    CancelImportButton.Enabled = false;
                    NotifyCheckBox.Enabled = false;
                    ButtonsUpdatePanel.Update();
                }
            }

            else
            {
                Indicator.ForeColor = System.Drawing.Color.Red;
                Indicator.Text = "Нет файла!";
            }
        }
    }
    protected void ImportedStatusesView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteCommand.Parameters.AddWithValue("ImportedLine_id", e.CommandArgument.ToString());
            DeleteCommand.ExecuteNonQuery();
            DeleteCommand.Parameters.Clear();
            ImportedStatusesView.DataBind();
            ImportedDataUpdatePanel.Update();
        }
    }
    public void SendNotification(string Order_id)
    {
        OrderTable.Parameters.AddWithValue("Order_id", Order_id.ToString());
        OrderHeader.Parameters.AddWithValue("Order_id", Order_id.ToString());
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
        NotifyCustomer.Subject = "Статус заказа № " + Order_id.ToString() + " – " + HeaderReader["OrderStatus"];

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

        OrderTable.Parameters.Clear();
        OrderHeader.Parameters.Clear();

        KtradeSMTP.Send(NotifyCustomer);
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(ImportedStatusesView.UniqueID.ToString());
        CSM.RegisterForEventValidation(ConfirmImportButton.UniqueID.ToString());
        CSM.RegisterForEventValidation(CancelImportButton.UniqueID.ToString());
        CSM.RegisterForEventValidation(NotifyCheckBox.UniqueID.ToString());
        base.Render(writer);
    }
    protected void ConfirmImportButton_Click(object sender, EventArgs e)
    {
        if (OrderConnection.State.ToString() == "Closed") OrderConnection.Open();

        ConfirmCommand.ExecuteNonQuery();

        SqlDataReader OrderListReader = OrderList.ExecuteReader();
        while (OrderListReader.Read())
        {
            UpdateOrderStatusCommand.Parameters.AddWithValue("Order_id", OrderListReader[0].ToString());
            UpdateOrderStatusCommand.ExecuteNonQuery();
            UpdateOrderStatusCommand.Parameters.Clear();

            if (NotifyCheckBox.Checked)
            {
                SendNotification(OrderListReader[0].ToString());
            }

            //Thread.Sleep(2000); //Спать!
        }

        OrderListReader.Close();
        OrderConnection.Close();

        CancelCommand.ExecuteNonQuery();
        ImportedStatusesView.DataBind();
        ImportedDataUpdatePanel.Update();
        ConfirmImportButton.Enabled = false;
        CancelImportButton.Enabled = false;
        NotifyCheckBox.Enabled = false;
        ButtonsUpdatePanel.Update();
    }
    protected void CancelImportButton_Click(object sender, EventArgs e)
    {
        CancelCommand.ExecuteNonQuery();
        ImportedStatusesView.DataBind();
        ImportedDataUpdatePanel.Update();
        ConfirmImportButton.Enabled = false;
        CancelImportButton.Enabled = false;
        NotifyCheckBox.Enabled = false;
        ButtonsUpdatePanel.Update();
    }
    protected void ImportedStatusesView_DataBound(object sender, EventArgs e)
    {
        if (ImportedStatusesView.Rows.Count > 0)
        {
            ConfirmImportButton.Enabled = true;
            CancelImportButton.Enabled = true;
            NotifyCheckBox.Enabled = true;
            ConfirmImportButton.ForeColor = Color.Green;
            CancelImportButton.ForeColor = Color.Red;
        }
        else
        {
            ConfirmImportButton.Enabled = false;
            CancelImportButton.Enabled = false;
            NotifyCheckBox.Enabled = false;
            ConfirmImportButton.ForeColor = Color.Gray;
            CancelImportButton.ForeColor = Color.Gray;
        }
    }
}
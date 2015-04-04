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

public partial class Customer_NewOrder : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string DeleteitemString = "delete from OrderItems where id = @Line_id";
    static string ArrangeOrderString = "ArrangeOrder";
    static string DuplicateItemString = "DuplicateItem";
    static string AddItemString = "insert into OrderItems (Order_id, Catalogue_id, Article_id, ArticleName, Price, Size, Colour, Comment, LineStatus, KtradeStatus_id, Customer_id) values (-1, @Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @Comment, 10, 1, @Customer_id)";
    static string OrderHeaderString = "select CustomerName, CustomerMail, ContractNumber from OrderList where Order_id = @Order_id";
    static string OrderTableString = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price from OrderDetailsView where Order_id = @Order_id";
    static string OrderExportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView where Order_id = @Order_id";
    static string CatalogueInfoString = "select ArticleRegularExpression, ArticleComment, replace (convert(nvarchar(8), MinPrice), '.', ',') as MinPrice, WeightFee, 'Условия работы по каталогу ' + CatalogueName + ':<br/>Минимальная цена артикула — ' + replace (convert(nvarchar(8), MinPrice), '.', ',') + ' €<br/>Стоимость доставки — ' + replace (convert(nvarchar(8), WeightFee), '.', ',') + ' € / кг.' + case NoReturn when 1 then '<br/>Возврат, обмен и отказ не предусмотрен.' else '' end as TermsDescription from Catalogues where Catalogue_id = @Catalogue_id";
    static string OrderAmmountString = "select REPLACE(CONVERT (nvarchar(10), ROUND (SUM (OI.Price * C.PriceIndex), 2)), '.', ',') + ' €' as Ammount from OrderItems as OI join Catalogues as C on C.Catalogue_id = OI.Catalogue_id where OI.Customer_id = @Customer_id and Order_id = -1";
    SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    SqlCommand DeleteItem = new SqlCommand(DeleteitemString, iKConnection);
    SqlCommand ArrangeOrder = new SqlCommand(ArrangeOrderString, iKConnection);
    SqlCommand DuplicateItem = new SqlCommand(DuplicateItemString, iKConnection);
    SqlCommand OrderHeader = new SqlCommand(OrderHeaderString, iKConnection);
    SqlCommand OrderTable = new SqlCommand(OrderTableString, iKConnection);
    SqlCommand OrderExport = new SqlCommand(OrderExportString, iKConnection);
    SqlCommand CatalogueInfo = new SqlCommand(CatalogueInfoString, iKConnection);
    SqlCommand OrderAmmount = new SqlCommand(OrderAmmountString, iKConnection);
    //public static decimal MinPrice = 7;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
	
	Page.MetaDescription = "Оформить заказ на сайте ikatalog.kz вы можете на странице оформления нового заказа, вам нужно лишь знать каталог, из которого вы делаете заказа, артикул товара, цену, цвет и размер вещи.";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());        
        base.Render(writer);
    }
    protected void OrderDetailsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteItem.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            DeleteItem.ExecuteNonQuery();
            OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
        }
        if (e.CommandName == "DuplicateLine")
        {
            if (DuplicateItem.Parameters.Count != 0) DuplicateItem.Parameters.Clear();
            DuplicateItem.CommandType = CommandType.StoredProcedure;
            SqlParameter Line_id = new SqlParameter("@Line_id", SqlDbType.Int);
            Line_id.Value = e.CommandArgument.ToString();
            Line_id.Direction = ParameterDirection.Input;
            DuplicateItem.Parameters.Add(Line_id);

            //DuplicateItem.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DuplicateItem.ExecuteNonQuery();
            OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
        }
    }
    protected void OrderDetailsGridView_DataBound(object sender, EventArgs e)
    {
        if (OrderDetailsGridView.Rows.Count == 0)
        {
            ConfirmOrderButton.Visible = false;
	    EmptyOrderLabel.Text = "Корзина пуста";
        }
        else
        {
            ConfirmOrderButton.Visible = true;
	    
	    OrderAmmount.Parameters.Clear();
	    OrderAmmount.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
	    
	    SqlDataReader AmountReader = OrderAmmount.ExecuteReader();
	    
	    AmountReader.Read();
	    
	    EmptyOrderLabel.Text = "Общая сумма заказа с учетом наценок каталогов, но без доставки: " + AmountReader["Ammount"].ToString();
	    
	    AmountReader.Close();
        }
    }
    protected void ConfirmOrderButton_Click(object sender, EventArgs e)
    {
        if (ArrangeOrder.Parameters.Count != 0) ArrangeOrder.Parameters.Clear();
        ArrangeOrder.CommandType = CommandType.StoredProcedure;
        SqlParameter Customer = new SqlParameter("@Customer_id", SqlDbType.Int);
        Customer.Value = Session["Customer"].ToString();
        Customer.Direction = ParameterDirection.Input;
        ArrangeOrder.Parameters.Add(Customer);
        SqlParameter Order = new SqlParameter("@Order_id", SqlDbType.Int);
        Order.Direction = ParameterDirection.Output;
        ArrangeOrder.Parameters.Add(Order);

        ArrangeOrder.ExecuteNonQuery();

        SendNotifications(Order.Value.ToString());

        Response.Redirect("~/Customer/OrderThanks.aspx?ammount=" + GetOrderAmmount(Order.Value.ToString()));
    }
    public void SendNotifications(string Order_id)
    {
        OrderTable.Parameters.AddWithValue("Order_id", Order_id);
        OrderHeader.Parameters.AddWithValue("Order_id", Order_id);

        SqlDataReader HeaderReader = OrderHeader.ExecuteReader();

        HeaderReader.Read();
		
		string ContractNumber = HeaderReader["ContractNumber"].ToString();

        SmtpClient KtradeSMTP = new SmtpClient();

        MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
        MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
        MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
        MailAddress Customer = new MailAddress(HeaderReader["CustomerMail"].ToString(), HeaderReader["CustomerName"].ToString());
        MailMessage NotifySeller = new MailMessage();
        MailMessage NotifyCustomer = new MailMessage();
        //Сообщение для продавца
        NotifySeller.From = Admin;
        NotifySeller.To.Add(Sale);
        NotifySeller.To.Add(Office);
        //NotifySeller.To.Add("admin@ktrade.kz"); //Для тестирования
        NotifySeller.IsBodyHtml = true;
        NotifySeller.BodyEncoding = System.Text.Encoding.UTF8;
        NotifySeller.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifySeller.Subject = "Заказ № " + Order_id + ", покупатель: " + HeaderReader["CustomerName"];
        //Сообщение для покупателя
        NotifyCustomer.From = Admin;
        NotifyCustomer.To.Add(Customer);
	NotifyCustomer.To.Add(Office);
        NotifyCustomer.ReplyTo = Office;
        //NotifyCustomer.To.Add("admin@ktrade.kz"); //Для тестирования
        NotifyCustomer.IsBodyHtml = true;
        NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.Subject = "Ваш заказ №" + Order_id.ToString();

        HeaderReader.Close();

        //Создаем пустые тела сообщений для унификации последующего кода
        NotifySeller.Body = "";
        NotifyCustomer.Body = "";

        NotifyCustomer.Body += "<h3>Здравствуйте, от вас принят в работу следующий заказ:</h3>";

        //Таблица с данными заказа в тело сообщений
        NotifySeller.Body += "<table border=\"1\" style=\"border-style:solid\" cellspacing=\"0\"> ";
        NotifySeller.Body += "<tr> <th> Каталог </th> <th> Артикул </th> <th> Наименование </th> <th> Цена </th> <th> Размер </th> <th> Цвет </th> </tr>";
        NotifyCustomer.Body += "<table border=\"1\" style=\"border-style:solid\" cellspacing=\"0\"> ";
        NotifyCustomer.Body += "<tr> <th> Каталог </th> <th> Артикул </th> <th> Наименование </th> <th> Цена </th> <th> Размер </th> <th> Цвет </th> </tr>";

        SqlDataReader TableReader = OrderTable.ExecuteReader();

        while (TableReader.Read())
        {
            NotifySeller.Body += "<tr> <td> " + TableReader["CatalogueName"] + " </td> <td> " + TableReader["Article_id"] + " </td> <td> <a href=\"" + TableReader["Comment"] + "\">" + TableReader["ArticleName"] + "</a> </td> <td> " + TableReader["Price"] + " </td> <td> " + TableReader["Size"] + " </td> <td> " + TableReader["Colour"] + " </td> </tr>";
            NotifyCustomer.Body += "<tr> <td> " + TableReader["CatalogueName"] + " </td> <td> " + TableReader["Article_id"] + " </td> <td> <a href=\"" + TableReader["Comment"] + "\">" + TableReader["ArticleName"] + "</a> </td> <td> " + TableReader["Price"] + " </td> <td> " + TableReader["Size"] + " </td> <td> " + TableReader["Colour"] + " </td> </tr>";
        }

        NotifySeller.Body += "</table><p>К письму приложен файл для импорта в базу данных.<p>";
        //NotifyCustomer.Body += "</table><p>Вы можете оплатить ваш заказ через терминалы Qiwi, по номеру договора: " + ContractNumber + "</p><p>Или непосредственно <a href='http://ktrade.kz/Customer/PaymentOnline.aspx'>на сайте Ktrade.kz на странице оплаты</a></p>";
	NotifyCustomer.Body += "</table><p>Вы можете оплатить ваш заказ непосредственно <a href='http://ikatalog.kz/Customer/PaymentOnline.aspx'>на сайте ikatalog.kz на странице оплаты</a></p>";

        TableReader.Close();
		
	/* Тут прикрепление к письму файла с заказом — пока отключили за ненадобностью
        int RowCount = 0;
        int RowNumber = 1;

        char tabchar = (char)9;
        string tab = tabchar.ToString();

        OrderExport.Parameters.AddWithValue("Order_id", Order_id);

        SqlDataReader RowCounter = OrderExport.ExecuteReader();

        while (RowCounter.Read())
        {
            ++RowCount;
        }

        ++RowCount;
        RowCounter.Close();

        string[] Content = new String[RowCount];
        Content[0] = "Klient" + tab + "PVU-Card Nr" + tab + "Katalog" + tab + "Art Nr" + tab + "Cena" + tab + "Nazwanie" + tab + "Razmer" + tab + "Zwet" + tab + "Primechanie";

        SqlDataReader ExportReader = OrderExport.ExecuteReader();

        while (ExportReader.Read())
        {
            Content[RowNumber] = ExportReader[0].ToString() + tab + ExportReader[1].ToString() + tab + ExportReader[2].ToString() + tab + ExportReader[3].ToString() + tab + ExportReader[4].ToString() + tab + ExportReader[5].ToString() + tab + ExportReader[6].ToString() + tab + ExportReader[7].ToString() + tab + ExportReader[8].ToString();
            ++RowNumber;
        }

        ExportReader.Close();

        string FileName = "/ExportedOrders/Order" + Order_id.ToString() + ".tsv";

        File.WriteAllLines(Server.MapPath("~") + FileName, Content, Encoding.GetEncoding(65001)); //1251 - винда русская, 65001 - юникод

        Attachment NewOrder = new Attachment(Server.MapPath("~") + FileName);

        NotifySeller.Attachments.Add(NewOrder);
		*/
        KtradeSMTP.Send(NotifySeller);
        KtradeSMTP.Send(NotifyCustomer);
    }
    public string GetOrderAmmount (string Order_id)
    {
	OrderAmmount.Parameters.Clear();
	OrderAmmount.Parameters.AddWithValue("Order_id", Order_id.ToString());
	SqlDataReader OrderAmmountReader = OrderAmmount.ExecuteReader();
	OrderAmmountReader.Read();
	string Ammount = OrderAmmountReader["OrderAmmount"].ToString();
	OrderAmmountReader.Close();
	return Ammount;
    }
}
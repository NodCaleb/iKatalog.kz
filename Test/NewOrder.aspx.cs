﻿using System;
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
    static string KtradeConnectionString = ConfigurationManager.ConnectionStrings["KtradeConnectionString"].ConnectionString;
    static SqlConnection KtradeConnection = new SqlConnection(KtradeConnectionString);
    static string DeleteitemString = "delete from OrderItems where id = @Line_id";
    static string ArrangeOrderString = "ArrangeOrder";
    static string DuplicateItemString = "DuplicateItem";
    static string AddItemString = "insert into OrderItems (Order_id, Catalogue_id, Article_id, ArticleName, Price, Size, Colour, Comment, LineStatus, KtradeStatus_id, Customer_id) values (-1, @Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @Comment, 10, 1, @Customer_id)";
    static string OrderHeaderString = "select CustomerName, CustomerMail, ContractNumber from OrderList where Order_id = @Order_id";
    static string OrderTableString = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price from OrderDetailsView where Order_id = @Order_id";
    static string OrderExportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView where Order_id = @Order_id";
    SqlCommand AddItem = new SqlCommand(AddItemString, KtradeConnection);
    SqlCommand DeleteItem = new SqlCommand(DeleteitemString, KtradeConnection);
    SqlCommand ArrangeOrder = new SqlCommand(ArrangeOrderString, KtradeConnection);
    SqlCommand DuplicateItem = new SqlCommand(DuplicateItemString, KtradeConnection);
    SqlCommand OrderHeader = new SqlCommand(OrderHeaderString, KtradeConnection);
    SqlCommand OrderTable = new SqlCommand(OrderTableString, KtradeConnection);
    SqlCommand OrderExport = new SqlCommand(OrderExportString, KtradeConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (KtradeConnection.State.ToString() == "Closed") KtradeConnection.Open();
        CSM = Page.ClientScript;
        if (Request.QueryString["catalogue"] != null)
        {
            CatalogueList.SelectedValue = Request.QueryString["catalogue"].ToString(); // Int16.Parse(Request.QueryString["catalogue"].ToString());
        }
        if (Request.QueryString["article"] != null)
        {
            Article_idInput.Text = Request.QueryString["article"].ToString();
        }
        if (Request.QueryString["name"] != null)
        {
            ArticleNameInput.Text = Request.QueryString["name"].ToString();
        }
        if (Request.QueryString["price"] != null)
        {
            PriceInput.Text = Request.QueryString["price"].ToString();
        }
        if (Request.QueryString["size"] != null)
        {
            SizeInput.Text = Request.QueryString["size"].ToString();
        }
        if (Request.QueryString["color"] != null)
        {
            ColorInput.Text = Request.QueryString["color"].ToString();
        }
        if (Request.QueryString["URL"] != null)
        {
            CommentInput.Text = "http://" + Request.QueryString["URL"].ToString();
        }
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(AddItemButton.UniqueID.ToString());
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());        
        base.Render(writer);
    }
    protected void AddItemButton_Click(object sender, EventArgs e)
    {
        if (Decimal.Parse(PriceInput.Text) < 5)
        {
            MinimumPriceValidator.IsValid = false;
        }
        else
        {
            MinimumPriceValidator.IsValid = true;
        }
        
        if (Page.IsValid)
        {
            AddItem.Parameters.AddWithValue("Catalogue_id", CatalogueList.SelectedValue.ToString());
            AddItem.Parameters.AddWithValue("Article_id", Article_idInput.Text);
            AddItem.Parameters.AddWithValue("ArticleName", ArticleNameInput.Text);
            AddItem.Parameters.AddWithValue("Price", Decimal.Parse(PriceInput.Text));
            AddItem.Parameters.AddWithValue("Size", SizeInput.Text);
            AddItem.Parameters.AddWithValue("Colour", ColorInput.Text);
            AddItem.Parameters.AddWithValue("Comment", CommentInput.Text);
            AddItem.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
            AddItem.ExecuteNonQuery();
            Article_idInput.Text = "";
            ArticleNameInput.Text = "";
            PriceInput.Text = "";
            SizeInput.Text = "";
            ColorInput.Text = "";
            CommentInput.Text = "";
            OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
        }
    }
    protected void CatalogueList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (CatalogueList.SelectedValue == "0") //3PAGEN
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{5}6";
            ArticleExpressionValidator.ErrorMessage = "Артикул <b>должен</b> содержать 6 цифр, к артикулу из 5-ти цифр с сайта каталога добавьте в конце цифру 6.";
        }
        else if ((CatalogueList.SelectedValue == "64") | (CatalogueList.SelectedValue == "69")) //CYRILLUS or C&A
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9/.]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и точку.";
        }
        else if (CatalogueList.SelectedValue == "60") //ZALANDO
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Za-z/-]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры, строчные и прописные латинские буквы и дефис.";
        }
        else if (CatalogueList.SelectedValue == "27") //JACK WOLFSKIN
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры, дефисы и пробелы из артикула с сайта каталога нужно удалить.";
        }
        else if (CatalogueList.SelectedValue == "76") //BREUNINGER
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры, нижнее подчеркивание и все, что после него из артикула с сайта каталога нужно удалить.";
        }
        else if ((CatalogueList.SelectedValue == "58")|(CatalogueList.SelectedValue == "120")) //ZARA + MASSIMO DUTY
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9][0-9][0-9//]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры и прямую наклонную черту, при этом '0/' в начале артикула с сайта каталога и '/0+любая цифра' в конце нужно удалить.";
        }
        else if ((CatalogueList.SelectedValue == "34")|(CatalogueList.SelectedValue == "113")) //NECKERMANN + HAPPY_SIZE
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{1,7}";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры и не более семи.";
            SizeExpressionValidator.ValidationExpression = "[0-9]{0,3}";
            SizeExpressionValidator.ErrorMessage = "Пожалуйста укажите код парного размера (три цифры перед скобками)";
            ColorExpressionValidator.ValidationExpression = "[0-9]{0,3}";
            ColorExpressionValidator.ErrorMessage = "Пожалуйста укажите код цвета - две цифры в скобках, выводятся подсказкой при наведении курсора на квадрат с цветом.";
        }
        else if (CatalogueList.SelectedValue == "29") //KLINGEL
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z//]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры, прописные буквы и прямую наклонную черту.";
        }
        else if (CatalogueList.SelectedValue == "86") //MEXX
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и прописные латинские буквы.";
        }
        else if (CatalogueList.SelectedValue == "82") //TOMMY_HILFIGER
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и прописные латинские буквы.";
        }
        else if (CatalogueList.SelectedValue == "79") //ESPRIT
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и прописные латинские буквы.";
        }
        else if (CatalogueList.SelectedValue == "93") //LACOSTE
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и прописные латинские буквы.";
        }
        else if (CatalogueList.SelectedValue == "53") //VENCA
        {
            ArticleExpressionValidator.ValidationExpression = "V?[0-9A-Z]+[IYV]?";
            ArticleExpressionValidator.ErrorMessage = "Артикул должен состоять из цифр (в начале может быть буква V, а в конце I, Y или V).";
        }
		else if (CatalogueList.SelectedValue == "35") //OTTO
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и прописные латинские буквы.";
        }
		else if (CatalogueList.SelectedValue == "91") //S.Oliver
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9.]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры и точки.";
        }
		else if ((CatalogueList.SelectedValue == "123") | (CatalogueList.SelectedValue == "122") | (CatalogueList.SelectedValue == "124")) //Street one, Desigual, Adler
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z//]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры, прописные латинские буквы и наклонную черту.";
        }
        else
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]+[A-Z]?";
            ArticleExpressionValidator.ErrorMessage = "Артикул должен состоять из цифр (иногда - одна буква в конце).";
        }
        ArticleValidationUpdatePanel.Update();
        SizeValidationUpdatePanel.Update();
        ColorValidationUpdatePanel.Update();
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
            EmptyOrderLabel.Visible = true;
            ConfirmOrderButton.Visible = false;
            UpsellPanel.Visible = false;
        }
        else
        {
            EmptyOrderLabel.Visible = false;
            ConfirmOrderButton.Visible = true;
            UpsellPanel.Visible = true;
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

        Response.Redirect("~/UpsellOffers.aspx");
    }
    public void SendNotifications(string Order_id)
    {
        OrderTable.Parameters.AddWithValue("Order_id", Order_id);
        OrderHeader.Parameters.AddWithValue("Order_id", Order_id);

        SqlDataReader HeaderReader = OrderHeader.ExecuteReader();

        HeaderReader.Read();
		
		string ContractNumber = HeaderReader["ContractNumber"].ToString();

        SmtpClient KtradeSMTP = new SmtpClient();

        MailAddress Admin = new MailAddress("admin@ktrade.kz", "Ktrade"); //Отправитель сообщения
        MailAddress Sale = new MailAddress("sale@ktrade.kz", "Отдел продаж");
        MailAddress Office = new MailAddress("office@ktrade.kz", "Офис");
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
        NotifyCustomer.Body += "</table><p><b>Теперь вы можете оплачивать ваши заказы через терминалы Qiwi, по номеру договора: " + ContractNumber + "</b></p>";

        TableReader.Close();

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

        KtradeSMTP.Send(NotifySeller);
        KtradeSMTP.Send(NotifyCustomer);
    }
}
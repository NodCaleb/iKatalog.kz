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

public partial class Customer_MyWishList : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string DeleteitemString = "delete from Wishes where id = @Line_id";
    static string FullfillWishString = "update Wishes set Fullfilled = 1 where id = @Line_id";
    static string AddItemString = "insert into Wishes (Catalogue_id, Article_id, ArticleName, Price, Size, Colour, URL, Customer_id) values (@Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @URL, @Customer_id)";
    SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    SqlCommand DeleteItem = new SqlCommand(DeleteitemString, iKConnection);
    SqlCommand FullfillWish = new SqlCommand(FullfillWishString, iKConnection);
    public static int MinPrice = 7;
    public static string ShareLink;// = "http://ikatalog.kz/WishListView.aspx?customer=";
    public static string CustomerName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
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
            URLInput.Text = "http://" + Request.QueryString["URL"].ToString();
        }
        if (
        		(CatalogueList.SelectedValue == "22") |
				(CatalogueList.SelectedValue == "61") |
				(CatalogueList.SelectedValue == "69") |
				(CatalogueList.SelectedValue == "95") |
				(CatalogueList.SelectedValue == "106") |
				(CatalogueList.SelectedValue == "113") |
				(CatalogueList.SelectedValue == "141") |
				(CatalogueList.SelectedValue == "142") |
				(CatalogueList.SelectedValue == "140") |
				(CatalogueList.SelectedValue == "146") |
				(CatalogueList.SelectedValue == "151") |
				(CatalogueList.SelectedValue == "155") |
				(CatalogueList.SelectedValue == "156") |
				(CatalogueList.SelectedValue == "159") |
				(CatalogueList.SelectedValue == "163") |
				(CatalogueList.SelectedValue == "164") |
				(CatalogueList.SelectedValue == "165")
			)
		{
			MinPrice = 4;
			MinimumPriceValidator.ErrorMessage="Цена артикула по данному каталогу должна быть не менее 4 евро.";
		}
		else
		{
			MinPrice = 7;
			MinimumPriceValidator.ErrorMessage="Цена артикула по данному каталогу должна быть не менее 7 евро.";
		}
		
	ShareLink = "http://ikatalog.kz/WishListView.aspx?customer=";
	if (Session["Customer"] != null)
	{
	    ShareLink += Session["Customer"].ToString();
	}
	yasharediv.Attributes["data-yashareLink"] = ShareLink;
	ShareURL.Text = ShareLink;
	
	if (Session["UserFullName"] != null)
	{
	    CustomerName = Session["UserFullName"].ToString();
	}
    }
    protected void Page_LoadComplete(object sender, EventArgs e)
    {
	UpdateCatalogueValidation();
	ShareURL.Text = ShareLink;
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(AddItemButton.UniqueID.ToString());
        CSM.RegisterForEventValidation(WishesGridView.UniqueID.ToString());
	CSM.RegisterForEventValidation(SendList.UniqueID.ToString());
        base.Render(writer);
    }
    protected void AddItemButton_Click(object sender, EventArgs e)
    {
        if (Decimal.Parse(PriceInput.Text) < MinPrice)
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
            AddItem.Parameters.AddWithValue("URL", URLInput.Text);
            AddItem.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
            AddItem.ExecuteNonQuery();
            Article_idInput.Text = "";
            ArticleNameInput.Text = "";
            PriceInput.Text = "";
            SizeInput.Text = "";
            ColorInput.Text = "";
            URLInput.Text = "";
            WishesGridView.DataBind();
            WishesUpdatePanel.Update();
        }
    }
    protected void CatalogueList_SelectedIndexChanged(object sender, EventArgs e)
    {
        UpdateCatalogueValidation();
    }
    protected void UpdateCatalogueValidation()
    {
	if (
	    (CatalogueList.SelectedValue == "22") |
	    (CatalogueList.SelectedValue == "61") |
	    (CatalogueList.SelectedValue == "69") |
	    (CatalogueList.SelectedValue == "95") |
	    (CatalogueList.SelectedValue == "106") |
	    (CatalogueList.SelectedValue == "113") |
	    (CatalogueList.SelectedValue == "141") |
	    (CatalogueList.SelectedValue == "142") |
	    (CatalogueList.SelectedValue == "140") |
	    (CatalogueList.SelectedValue == "146") |
	    (CatalogueList.SelectedValue == "151") |
	    (CatalogueList.SelectedValue == "155") |
	    (CatalogueList.SelectedValue == "156") |
	    (CatalogueList.SelectedValue == "159") |
	    (CatalogueList.SelectedValue == "163") |
	    (CatalogueList.SelectedValue == "164") |
	    (CatalogueList.SelectedValue == "165")
	    )
		{
			MinPrice = 4;
			MinimumPriceValidator.ErrorMessage="Цена артикула по данному каталогу должна быть не менее 4 евро.";
		}
		else
		{
			MinPrice = 7;
			MinimumPriceValidator.ErrorMessage="Цена артикула по данному каталогу должна быть не менее 7 евро.";
		}
        
        if (CatalogueList.SelectedValue == "0") //3PAGEN
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{6}";
            ArticleExpressionValidator.ErrorMessage = "Артикул состоит из 6 цифр.";
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
        else if (CatalogueList.SelectedValue == "65") //YOOX
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры, буквы в конце — не указываем.";
        }
        else if (CatalogueList.SelectedValue == "134") //BABY MARKT
        {
            ArticleExpressionValidator.ValidationExpression = "A[0-9A-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры и буквы в начале — буква A.";
        }
        else if (CatalogueList.SelectedValue == "58") //ZARA
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9][0-9][0-9][0-9][//][0-9][0-9][0-9][//][0-9][0-9][0-9]";
            ArticleExpressionValidator.ErrorMessage = "Пожалуйста, укажите полный артикул товара, например, 0000/000/000.  Для того, чтобы найти номер артикула, необходимый для заказа на странице http://www.zara.com, надо после выбора размера отправить артикул в закупочную корзину. В номере артикула вам нужны только 10 цифр, 0/ и /02 вы пропускаете и копируете только 10 цифр которые находятся в середине. Внимание! При заказе символ / в номере артикула указывается. Иначе будет ошибка! Например: номер артикула в закупочной корзине- 0/2109/719/800/02. При заказе на портале вам нужно указать- 2109/719/800.";
            ColorExpressionValidator.ValidationExpression = "[0-9a-zA-Z]{1,20}";
            ColorExpressionValidator.ErrorMessage = "Цвет указывается на английском языке. При указании цвета на немецком будет ошибка! Чтобы увидеть название цвета на английском языке, необходимо, выбрав нужный артикул, нажать на English в правом нижнем углу окна, и затем навести мышку на квадрат с цветом в описании артикула. Либо скопировать название цвета из закупочной корзины на каталоге ZARA. Если в названии цвета присутствует пробел — удалите его.";
        }
		else if (CatalogueList.SelectedValue == "133") //BERSHKA
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]+";
            ArticleExpressionValidator.ErrorMessage = "При заказе c каталога Bershka символ / в номере артикула не указывается. Например, 0/5584/187/800/03 - номер артикула в закупочной корзине. При заказе на портале вам нужно указать - 5584187800. Будьте предельно внимательны.";
            ColorExpressionValidator.ValidationExpression = "[0-9a-zA-Z]{1,20}";
            ColorExpressionValidator.ErrorMessage = "Цвет указывается на английском языке. При указании цвета на немецком будет ошибка! Чтобы увидеть название цвета на английском языке, необходимо, выбрав нужный артикул, нажать на English в правом нижнем углу окна, и затем навести мышку на квадрат с цветом в описании артикула. Либо скопировать название цвета из закупочной корзины на каталоге ZARA. Если в названии цвета присутствует пробел — удалите его.";
        }
		else if (CatalogueList.SelectedValue == "120") //MASSIMO DUTY
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{10}";
            ArticleExpressionValidator.ErrorMessage = "Для того, чтобы найти номер артикула, необходимый для заказа, надо после выбора размера и цвета отправить артикул в закупочную корзину нажав на in den Einkaufskorb hinzufügen. В номере артикула вам нужны только 10 цифр, 0 и 36 вы пропускаете и копируете только 10 цифр, которые находятся в середине. Например, номер артикула в корзине - 0517060974236, номер артикула для заказа – 5170609742.";
            //ColorExpressionValidator.ValidationExpression = "[0-9]{1,20}";
            //ColorExpressionValidator.ErrorMessage = "Поле цвет обязательно для заполнения. Название цвета необходимо указывать без ошибок, строго так, как оно обозначено в описании артикула.";
        }
		/*	
        else if ((CatalogueList.SelectedValue == "34")|(CatalogueList.SelectedValue == "113")) //NECKERMANN + HAPPY_SIZE
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{1,7}";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать только цифры и не более семи.";
            SizeExpressionValidator.ValidationExpression = "[0-9]{0,3}";
            SizeExpressionValidator.ErrorMessage = "Пожалуйста укажите код парного размера (три цифры перед скобками)";
            ColorExpressionValidator.ValidationExpression = "[0-9]{0,3}";
            ColorExpressionValidator.ErrorMessage = "Пожалуйста укажите код цвета - две цифры в скобках, выводятся подсказкой при наведении курсора на квадрат с цветом.";
		}
		*/
        else if ((CatalogueList.SelectedValue == "29")|(CatalogueList.SelectedValue == "113")) //KLINGEL + HAPPY_SIZE
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9A-Z//]+";
            ArticleExpressionValidator.ErrorMessage = "Артикул может содержать цифры, прописные буквы и прямую наклонную черту.";
        }
        else if ((CatalogueList.SelectedValue == "86")|(CatalogueList.SelectedValue == "151")) //MEXX + FOSSIL
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
            ArticleExpressionValidator.ValidationExpression = "V?[0-9A-Z]+[IYVX]?";
            ArticleExpressionValidator.ErrorMessage = "Артикул должен состоять из цифр (в начале может быть буква V, а в конце I, Y, V или X). Точки из артикула удалить!";
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
        else if (CatalogueList.SelectedValue == "144") //Joop
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]-[0-9][0-9]";
            ArticleExpressionValidator.ErrorMessage = "Номер артикула находится в линке наверху страние в адресной строке в самом конце. Артикул имеет формат 000000000-0000-00. Знак «-» обязательный . Убедительная просьба указывать номер артикула со всеми знаками, например 580000016-8015-55. Номер артикула зависит от цвета. Поэтому сначала выберите цвет и только затем копируйте номер артикула.";
        }
        else if (CatalogueList.SelectedValue == "142") //Amazon
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9a-zA-Z]+";
            ArticleExpressionValidator.ErrorMessage = "Номер артикула может содержать буковки и циферки, а дефис — не может, да.";
        }
        else if (CatalogueList.SelectedValue == "156") //DRESS_FOR_LESS
        {
            ArticleExpressionValidator.ValidationExpression = "[a-zA-Z]{1,3}[0-9]{4}";
            ArticleExpressionValidator.ErrorMessage = "Артикул содержит две буквы в начале и четыре цифры в конце. Знак тире нужно удалить.";
        }
        else if (CatalogueList.SelectedValue == "167") //LLOYD
        {
            ArticleExpressionValidator.ValidationExpression = "[0-9]{2}-[0-9]{3}-[0-9]{2}";
            ArticleExpressionValidator.ErrorMessage = "Артикул должен иметь примерно такой формат: 12-345-67.";
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
    protected void WishesGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteItem.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            DeleteItem.ExecuteNonQuery();
            WishesGridView.DataBind();
            WishesUpdatePanel.Update();
        }
	if (e.CommandName == "FulfillWish")
        {
            FullfillWish.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            FullfillWish.ExecuteNonQuery();
            WishesGridView.DataBind();
            WishesUpdatePanel.Update();
        }
    }
    protected void WishesGridView_DataBound(object sender, EventArgs e)
    {
        if (WishesGridView.Rows.Count == 0)
        {
            Willkommen.Visible = true;
	    SharePanel.Visible = false;
        }
        else
        {
            Willkommen.Visible = false;
	    SharePanel.Visible = true;
        }
    }
    protected void SendListButton_Click(object sender, EventArgs e)
    {
	SmtpClient KtradeSMTP = new SmtpClient();

        MailAddress Receiver = new MailAddress(ReceiverEmailInput.Text.ToString(), ReceiverNameInput.Text.ToString()); //Получатель сообщения
        MailAddress Office = new MailAddress("eg@ikatalog.kz", "iKatalog");
	MailMessage ShareWishList = new MailMessage();
	ShareWishList.From = Office;
	ShareWishList.To.Add(Receiver);
	
	ShareWishList.IsBodyHtml = true;
        ShareWishList.BodyEncoding = System.Text.Encoding.UTF8;
        ShareWishList.SubjectEncoding = System.Text.Encoding.UTF8;
        ShareWishList.Subject = "Что желает получить в подарок " + CustomerName + "?";
	
	ShareWishList.Body = "<h3>Наш покупатель " + CustomerName + " поделился с вами своим списком желанний:</h3><p>Чтобы ознакомиться с ним, пройдите по ссылке:</p><p><a href=\"" + ShareLink + "\">" + ShareLink + "</a></p>";
	
	KtradeSMTP.Send(ShareWishList);
	
	DoneLabel.Text = "Готово!";
    }
}
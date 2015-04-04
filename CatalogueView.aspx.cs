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

public partial class CatalogueView : System.Web.UI.Page
{
    public ClientScriptManager CSM;

    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string AddItemString = "insert into OrderItems (Order_id, Catalogue_id, Article_id, ArticleName, Price, Size, Colour, Comment, LineStatus, KtradeStatus_id, Customer_id, Session_id) values (-1, @Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @Comment, 10, 1, @Customer_id, @Session_id)";
    static string ExploreBasketString = "select COUNT (OI.id) as ItemsCount, REPLACE(CONVERT (nvarchar(10), ROUND (SUM (OI.Price * C.PriceIndex), 2)), '.', ',') + ' €' as Ammount from OrderItems as OI join Catalogues as C on C.Catalogue_id = OI.Catalogue_id where OI.Session_id = @Session_id and Order_id = -1 group by OI.Session_id";
    static string TermsDescriptionString = "select * from CatalogueTermsDescription where Catalogue_id = @Catalogue_id";
    static string SearchCatalogueByNameString = "select Catalogue_id from Catalogues where CatalogueName = @CatalogueName";
    static SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    static SqlCommand ExploreBasket = new SqlCommand(ExploreBasketString, iKConnection);
    static SqlCommand TermsDescription = new SqlCommand(TermsDescriptionString, iKConnection);
    static SqlCommand SearchCatalogueByName = new SqlCommand(SearchCatalogueByNameString, iKConnection);
    static int Catalogue_id;
    static decimal MinPrice;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
	CSM = Page.ClientScript;
	
	if (Request.QueryString["Catalogue"] != null)
	{
	    try
	    {
		Catalogue_id = Int16.Parse(Request.QueryString["Catalogue"]);
	    }
	    catch
	    {
		SearchCatalogueByName.Parameters.Clear();
		SearchCatalogueByName.Parameters.AddWithValue("CatalogueName", Request.QueryString["Catalogue"].ToString());
		SqlDataReader CatalogueReader = SearchCatalogueByName.ExecuteReader();
		CatalogueReader.Read();
		
		if (CatalogueReader.HasRows)
		{
		    try
		    {
			Catalogue_id = Int16.Parse(CatalogueReader["Catalogue_id"].ToString());
		    }
		    catch
		    {
			Catalogue_id = -1;
		    }
		}
		else Catalogue_id = -1;
		
		CatalogueReader.Close();
	    }
	}
	else
	{
	    Catalogue_id = -1;
	}
	
	if (Catalogue_id == -1) Response.Redirect("~/Catalogues.aspx");
	
	if (TermsDescription.Parameters.Count != 0) TermsDescription.Parameters.Clear();
	TermsDescription.Parameters.AddWithValue("Catalogue_id", Catalogue_id.ToString());
	
	SqlDataReader TermsReader = TermsDescription.ExecuteReader();
	TermsReader.Read();
	
	if (TermsReader.HasRows)
	{
	    CatalogueFrame.Attributes["src"] = TermsReader["URL"].ToString();
	    VideoFrame.Attributes["src"] = TermsReader["VideoLink"].ToString();
	    TermsLabel.Text = TermsReader["TermsDescription"].ToString();
	    MinimumPriceValidator.ErrorMessage = "Цена артикула по данному каталогу должна быть не менее "+ TermsReader["MinPrice"].ToString().Substring(0,4) +" €";
	    ArticleExpressionValidator.ValidationExpression = TermsReader["ArticleRegularExpression"].ToString();
	    ArticleExpressionValidator.ErrorMessage = TermsReader["ArticleComment"].ToString();
	    MinPrice = Decimal.Parse(TermsReader["MinPrice"].ToString());
	    HelpIcon.AlternateText = TermsReader["OrderingRules"].ToString();
	    HelpIcon.Attributes["Title"] = TermsReader["OrderingRules"].ToString();
	    HelpLink.NavigateUrl = TermsReader["HelpURL"].ToString();
	}
	else
	{
	    Response.Redirect("~/Catalogues.aspx");
	}
	
	if (Request.QueryString["article"] != null) Article_idInput.Text = Request.QueryString["article"].ToString();
	if (Request.QueryString["name"] != null) ArticleNameInput.Text = Request.QueryString["name"].ToString();
	if (Request.QueryString["price"] != null) PriceInput.Text = Request.QueryString["price"].ToString();
	if (Request.QueryString["URL"] != null)
	{
	    string passedURL = Request.QueryString["URL"].ToString();
	    if (passedURL.Substring(0, 4) != "http") passedURL = "http://" + passedURL;
	    CatalogueFrame.Attributes["src"] = passedURL;
	}
	
	TermsReader.Close();
	
	Page.MetaDescription = "Мы предоставляем услуги доставки товаров по каталогам - OTTO, H&M, Lacoste, ZARA, MEXX, Amazon и других - из Германии. Вашему вниманию предлагаются более 130 европейских каталогов одежды онлайн с огромным ассортиментом товаров на любой вкус для людей разного возраста.";
	UpdateBasket();
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(AddItemButton.UniqueID.ToString());
        base.Render(writer);
    }
    protected void AddItemButton_Click(object sender, EventArgs e)
    {
	if (Decimal.Parse(PriceInput.Text) < MinPrice)
        {
            MinimumPriceValidator.IsValid = false;
	    //MinimumPriceValidator.Visible = true;
        }
        else
        {
            MinimumPriceValidator.IsValid = true;
        }
        
        if (Page.IsValid)
        {
	    if (AddItem.Parameters.Count != 0) AddItem.Parameters.Clear();
	    AddItem.Parameters.AddWithValue("Catalogue_id", Catalogue_id.ToString());
	    AddItem.Parameters.AddWithValue("Article_id", Article_idInput.Text);
	    AddItem.Parameters.AddWithValue("ArticleName", ArticleNameInput.Text);
	    AddItem.Parameters.AddWithValue("Price", Decimal.Parse(PriceInput.Text));
	    AddItem.Parameters.AddWithValue("Size", SizeInput.Text);
	    AddItem.Parameters.AddWithValue("Colour", ColorInput.Text);
	    if (Session["Customer"]!=null)
	    {
		AddItem.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
	    }
	    else
	    {
		AddItem.Parameters.AddWithValue("Customer_id", -1);
	    }
	    AddItem.Parameters.AddWithValue("Comment", "");
	    AddItem.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	    
	    AddItem.ExecuteNonQuery();
	    AddItem.Parameters.Clear();
	    
	    Article_idInput.Text = "";
	    ArticleNameInput.Text = "";
	    PriceInput.Text = "";
	    SizeInput.Text = "";
	    ColorInput.Text = "";
	    UpdateBasket();
	    FormUpdatePanel.Update();

	    if (Request.QueryString["article"] != null) Response.Redirect("~/CatalogueView.aspx?Catalogue=" + Catalogue_id.ToString());
	}
    }
    protected void ArrangeOrderButton_Click(object sender, EventArgs e)
    {
	Response.Redirect("~/Checkout.aspx");
    }
    protected void UpdateBasket()
    {
	if (ExploreBasket.Parameters.Count != 0) ExploreBasket.Parameters.Clear();
	ExploreBasket.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	
	SqlDataReader BasketReader = ExploreBasket.ExecuteReader();
	
	BasketReader.Read();
	
	if (BasketReader.HasRows)
	{
	    ItemsCountLabel.Text = BasketReader["ItemsCount"].ToString();
	    AmmountLabel.Text = BasketReader["Ammount"].ToString();
	    ArrangeOrderButton.Visible = true;
	}
	else
	{
	    ItemsCountLabel.Text = "0";
	    AmmountLabel.Text = "0,00 €";
	    ArrangeOrderButton.Visible = false;
	}
	
	BasketReader.Close();
	
	BasketUpdatePanel.Update();
    }
    protected void CreateLog (string Message)
    {
	string LogFile = Server.MapPath("~/Logs/") + "FrameView";
	string LogString = DateTime.Now.ToShortDateString().ToString()+" "+DateTime.Now.ToLongTimeString().ToString()+" ==> " + Message;
	
	StreamWriter SW = new StreamWriter(LogFile,true);
	SW.WriteLine(LogString);
	SW.Flush();
	SW.Close();
    }
    protected void ShowVideoGuide(Object sender, EventArgs e)
    {
	VideoGuidePanel.Visible = true;
	FormUpdatePanel.Update();
    }
    protected void CloseVideoGuide(object sender, ImageClickEventArgs e)
    {
	VideoGuidePanel.Visible = false;
	FormUpdatePanel.Update();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using iKGlobal;

public partial class Catalogues : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string GetPopularCountString = "select count (*) as PopularCount from CataloguesView where Catalogue_id in (SELECT top 4 OI.Catalogue_id from (select top 50 id, Catalogue_id from OrderItems where Customer_id = @Customer_id order by id desc ) as OI group by OI.Catalogue_id order by count (id) desc)";
    SqlCommand GetPopularCount = new SqlCommand(GetPopularCountString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        
        string Tag;
        if (Request.QueryString["Tag"] != null) Tag = ValidateTag(Request.QueryString["Tag"].ToString());
        else Tag = "active";
        
        //Page.Header.Title = "iKatalog - каталоги товаров" + GetCategoryNameByTag(Tag);
        //Page.MetaDescription = "Тут вы можете посмотреть перечень каталогов для выбранной вами категории товаров" + GetCategoryNameByTag(Tag) + ", почитать их описание, ознакомиться с условиями работы (наценка, возможность возврата).";
        CataloguesSource.SelectParameters["Tag"].DefaultValue = Tag;
        TagLabel.Text = GetCategoryNameByTag(Tag);
        HighlightButton(Tag);
        SwitchSEO(Tag);
        XrateLabel.Text = iClass.GetXrate().ToString();
    }
    protected void ChangeCategoryButton_Click(object sender, EventArgs e)
    {
        LinkButton categorySelector = (LinkButton)sender;
        if (categorySelector.ID.ToString() == "alleButton") Response.Redirect("~/Catalogues.aspx?Tag=active");
        else Response.Redirect("~/Catalogues.aspx?Tag=" + categorySelector.ID.ToString().Replace("Button", ""));
    }
    protected void HighlightButton(string Tag)
    {
        switch (Tag)
        {
            case "men": menButton.Style["font-weight"] = "bold"; menButton.Enabled = false; break;
            case "frau": frauButton.Style["font-weight"] = "bold"; frauButton.Enabled = false; break;
            case "children": childrenButton.Style["font-weight"] = "bold"; childrenButton.Enabled = false; break;
            case "shoes": shoesButton.Style["font-weight"] = "bold"; shoesButton.Enabled = false; break;
            case "home": homeButton.Style["font-weight"] = "bold"; homeButton.Enabled = false; break;
            case "sport": sportButton.Style["font-weight"] = "bold"; sportButton.Enabled = false; break;
            case "makeup": makeupButton.Style["font-weight"] = "bold"; makeupButton.Enabled = false; break;
            case "jems": jemsButton.Style["font-weight"] = "bold"; jemsButton.Enabled = false; break;
            default: alleButton.Style["font-weight"] = "bold"; break;
        }       
    }
    protected string GetCategoryNameByTag(string Tag)
    {
        switch (Tag)
        {
            case "men": return " (мужчинам) ";
            case "frau": return " (женщинам) ";
            case "children": return " (детям) ";
            case "shoes": return " (обувь) ";
            case "home": return " (дом) ";
            case "sport": return " (спорт) ";            
            case "makeup": return " (косметика) ";
            case "jems": return " (ювелирные изделия) ";
            default: return "";
        }
    }
    protected string ValidateTag (string Tag)
    {
        switch (Tag)
        {
            case "men": return "men"; break;
            case "frau": return "frau"; break;
            case "children": return "children"; break;
            case "shoes": return "shoes"; break;
            case "home": return "home"; break;
            case "sport": return "sport"; break;
            case "makeup": return "makeup"; break;
            case "jems": return "jems"; break;
            case "chubby": return "frau"; break;
            case "toys": return "children"; break;
            case "bed": return "home"; break;
            default: return "active"; break;
        }
    }
    protected void SwitchSEO(string Tag)
    {
        switch (Tag)
        {
            case "men":
            {
                CategoryTextSelector.ActiveViewIndex = 1;
                Page.Header.Title = "iKatalog - электронные каталоги мужской одежды онлайн";
                Page.MetaDescription = "Каталоги мужской одежды, принимаем заказы на доставку мужкой одежды по каталогам Armani, H M, Bogner и других";
                Page.MetaKeywords = "мужская одежда, одежда по каталогам, каталоги одежды, одежда больших размеров, каталоги одежды онлайн, каталог мужской одежды";
            } break;
            case "frau":
            {
                CategoryTextSelector.ActiveViewIndex = 2;
                Page.Header.Title = "iKatalog - электронные каталоги женской одежды онлайн ";
                Page.MetaDescription = "Заказать стильную женскую одежду отличного качества по самой выгодной цене по каталогам в Германии с доставкой по Казахстану";
                Page.MetaKeywords = "женская одежда, одежда для полных, стильная женская одежда, каталоги одежды в казахстане, каталоги женской одежды";
            } break;
            case "children":
            {
                CategoryTextSelector.ActiveViewIndex = 3;
                Page.Header.Title = "iKatalog - электронные каталоги детской одежды и других товаров для детей онлайн ";
                Page.MetaDescription = "Купить через интернет детскую одежду по каталогам в Германии с доставкой в города Актау, Атырау, Астану, Алматы";
                Page.MetaKeywords = "детская одежда, обувь, игрушки каталоги одежды онлайн";
            } break;
            case "shoes":
            {
                CategoryTextSelector.ActiveViewIndex = 4;
                Page.Header.Title = "iKatalog - электронные каталоги обуви онлайн ";
                Page.MetaDescription = "Заказать мужскую и женскую обувь, обувь для детей мировых брендов по каталогам на сайте iKatalog без регистрации";
                Page.MetaKeywords = "купить обувь, обувь для детей";
            } break;
            case "home":
            {
                CategoryTextSelector.ActiveViewIndex = 5;
                Page.Header.Title = "iKatalog - каталоги товаров для дома и уюта";
                Page.MetaDescription = "Купить через интернет текстиль и другие товары для дома по каталогам в Германии с доставкой в города Актау, Атырау, Астану, Алматы";
                Page.MetaKeywords = "текстиль для дома, постельное белье алматы, постельное белье купить";
            } break;
            case "sport":
            {
                CategoryTextSelector.ActiveViewIndex = 6;
                Page.Header.Title = "iKatalog - каталоги спортивных товаров и одежды";
                Page.MetaDescription = "Заказать спортивную одежду и спортивные товары мировых брендов по каталогам Amazon, Otto, Sportscheck, Lacoste, Tennis-Point";
                Page.MetaKeywords = "магазин спортивной одежды";
            } break;
            case "makeup":
            {
                CategoryTextSelector.ActiveViewIndex = 7;
                Page.Header.Title = "iKatalog - купить косметику по каталогам через интернет";
                Page.MetaDescription = "Заказать и купить косметику ведущих мировых брендов по каталогам в Германии по выгодной цене с доставкой на дом  во все регионы Казахстана";
                Page.MetaKeywords = "косметика";
            } break;
            case "jems":
            {
                CategoryTextSelector.ActiveViewIndex = 8;
                Page.Header.Title = "iKatalog - электронные каталоги ювелирных изделий";
                Page.MetaDescription = "Каталоги ювелирных изделий мировых брендов, купить золотые  и другие ювелирные украшения от Swarovsky, Diemer, Gingar по каталогам через интернет";
                Page.MetaKeywords = "ювелирные изделия, золотые украшения, ювелирные украшения, ювелирные изделия каталог, каталог ювелирных изделий";
            } break;
            default:
            {
                CategoryTextSelector.ActiveViewIndex = 0;
                Page.Header.Title = "iKatalog - электронные каталоги товаров ведущих брендов мира";
                Page.MetaDescription = "Перечень каталогов Zara, H&M, Otto,  Bonprix и других, их описание, условия заказа одежды и других товаров из Германии с доставкой в Казахстан";
                Page.MetaKeywords = "zara, h&m, детская одежда, каталог отто, zara каталог, каталоги одежды";
            } break;
        }       
    }
    protected void DisplayPopularCatagolues(string Tag)
    {
        try
        {
            GetPopularCount.Parameters.Clear();
            GetPopularCount.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
            
            SqlDataReader GetPopularCountReader = GetPopularCount.ExecuteReader();
            GetPopularCountReader.Read();
            //if (Int16.Parse(GetPopularCountReader["PopularCount"].ToString()) >= 4) PopularCataloguesPanel.Visible = true;
            GetPopularCountReader.Close();
        }
        catch
        {
            //PopularCataloguesPanel.Visible = false;
        }        
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Catalogues : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string GetPopularCountString = "select count (*) as PopularCount from CataloguesView where Catalogue_id in (SELECT top 4 OI.Catalogue_id from (select top 50 id, Catalogue_id from OrderItems where Customer_id = @Customer_id order by id desc ) as OI group by OI.Catalogue_id order by count (id) desc)";
    SqlCommand GetPopularCount = new SqlCommand(GetPopularCountString, iKConnection);

    protected string GetCategoryNameByTag(string Tag)
    {
        switch (Tag)
        {
            case "men": return " (мужская одежда) ";
            case "women": return " (женская одежда) ";
            case "children": return " (детская одежда) ";
            case "shoes": return " (обувь) ";
            case "chubby": return " (одежда для полных дам) ";
            case "toys": return " (товары для детей) ";
            case "sport": return " (спортивные товары и одежда) ";
            case "home": return " (товары для дома и уюта) ";
            case "leather": return " (кожанные изделия) ";
            case "makeup": return " (косметика) ";
            case "bed": return " (постельное белье) ";
            case "jems": return " (ювелирные изделия) ";
            default: return "";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.Title = "iKatalog - каталоги товаров";
        Page.MetaDescription = "Тут вы можете посмотреть перечень каталогов для выбранной вами категории товаров";
        if (Request.QueryString["Tag"] != null)
        {
            CataloguesSource.SelectParameters["Tag"].DefaultValue = Request.QueryString["Tag"].ToString();

            TagLabel.Text = GetCategoryNameByTag(Request.QueryString["Tag"].ToString());
            Page.Header.Title = "iKatalog - каталоги товаров" + GetCategoryNameByTag(Request.QueryString["Tag"].ToString());
            Page.MetaDescription += GetCategoryNameByTag(Request.QueryString["Tag"].ToString());
        }
        else
        {
            CataloguesSource.SelectParameters["Tag"].DefaultValue = "active";
        }
        Page.MetaDescription += ", почитать их описание, ознакомиться с условиями работы (наценка, возможность возврата).";
        
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
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
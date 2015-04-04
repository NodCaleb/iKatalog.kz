using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class UpsellOffers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
	if (Request.QueryString["order"] == "true")
        {
	    Response.Redirect("~/OrderThanks.aspx");
        }
	Page.Header.Title = "iKatalog - горячие предложения от каталогов";
	Page.MetaDescription = "Распродажи и скидки до 60% на брендовую одежду, сумки, аксессуары, косметику, постельное белье при заказе по каталогу в Германии с доставкой в Казахстан";
    }
    protected void MoreOffersButton_Click(object sender, EventArgs e)
    {
    	Page.Response.Redirect(Page.Request.Url.ToString(), true);
    }
}
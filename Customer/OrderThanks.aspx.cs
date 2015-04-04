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
        NoOrderPanel.Visible=false;
        OrderPanel.Visible=true;
	
	if (Request.QueryString["ammount"] != null)
        {
            Response.Redirect("~/Customer/PaymentOnline.aspx?ammount=" + Request.QueryString["ammount"].ToString());
        }
    }
    protected void MoreOffersButton_Click(object sender, EventArgs e)
    {
    	//UpsellOffersSource.DataBind();
    	//UpsellOffersUpdatePanel.Update();
    	Page.Response.Redirect(Page.Request.Url.ToString(), true);
    }
}
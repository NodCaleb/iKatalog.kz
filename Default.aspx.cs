using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;

public partial class _Default : System.Web.UI.Page
{
    public MembershipUser AuthorizedUser;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["stay"] != "true")
        {
            //Response.Redirect("~/Default.html");
	    Page.Header.Title = "iKatalog - заказ товаров по каталогам по интернету";
	    Page.MetaDescription = "Доставка из Германии в Казахстан одежды, обуви, аксессуаров по заказу из каталогов OTTO, Bonprix, H M, Apart, Lacoste, ZARA, MEXX, Amazon и других ";
        }
    }
}
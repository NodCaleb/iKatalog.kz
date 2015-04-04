using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Discount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.Title = "iKatalog - заказ товаров по каталогам";
        Page.MetaDescription = "Скидки, акции, распродажи, специальные предложения от каталогов товаров, как выгодно купить товары по каталогу в Германии с доставкой в Казахстан.";
    }
}
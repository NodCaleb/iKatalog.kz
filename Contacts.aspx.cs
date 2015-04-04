using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Contacts : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.Title = "Контактная информация компании Internet Katalog";
	Page.MetaDescription = "Адреса и телефоны офисов компании Internet Katalog в Алматы, Караганде и Таллине для заказа товаров из Германии";
    }
}
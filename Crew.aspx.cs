using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Crew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Header.Title = "iKatalog - команда компании Internet Katalog";
	Page.MetaDescription = "Сотрудники компании Интернет Каталог помогут выбрать нужный товар из каталогов, оформить заказ через интернет и доставят в Казахстан";
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (KtradeConnection.State.ToString() == "Closed") KtradeConnection.Open();
        CSM = Page.ClientScript;
	Page.MetaDescription = "Иногда так интересно узнать, что же заказывают другие клиенты iKatalog. Ведь ассортимент товаров очень широкий и если кто-то что-то закзал — наверное нашел что-то интересное.";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        base.Render(writer);
    }
    protected void UpdateTimer_Tick(object sender, EventArgs e)
	{
		//TimeLabel.Text = DateTime.Now.ToString();
		PryGridView.DataBind();
	}
}
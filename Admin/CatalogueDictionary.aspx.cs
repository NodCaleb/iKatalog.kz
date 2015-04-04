using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_CatalogueDictionary : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void CatalogueDetailsSource_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        CatalogueDetailsUpdatePanel.Update();
    }
    protected void CatalogueDetailsSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        CatalogueDropDownList.DataBind();
        CatalogueDetailsView.DataBind();
        CatalogueDetailsUpdatePanel.Update();
    }
}
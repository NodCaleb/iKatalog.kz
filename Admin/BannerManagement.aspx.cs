using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Admin_DicountManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string InsertQuery = "insert into CarouselBanners (CatalogueUrl, ImageUrl) values (@CatalogueUrl, @ImageUrl)";
    static string DeleteQuery = "delete from CarouselBanners where id = @id";
    SqlCommand InsertCommand = new SqlCommand(InsertQuery, iKConnection);
    SqlCommand DeleteCommand = new SqlCommand(DeleteQuery, iKConnection);

    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(BannersGridView.UniqueID.ToString());
        CSM.RegisterForEventValidation(AddButton.UniqueID.ToString());
        base.Render(writer);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
    }


    protected void Banners_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteCommand.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DeleteCommand.ExecuteNonQuery();
            DeleteCommand.Parameters.Clear();
            BannersGridView.DataBind();
            BannersUpdatePanel.Update();
        }
    }
    protected void AddButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            InsertCommand.Parameters.AddWithValue("CatalogueUrl", CatalogueUrlInput.Text);
            InsertCommand.Parameters.AddWithValue("ImageUrl", ImageUrlImport.Text);
            InsertCommand.ExecuteNonQuery();
            BannersGridView.DataBind();
            BannersUpdatePanel.Update();
        }
    }
}
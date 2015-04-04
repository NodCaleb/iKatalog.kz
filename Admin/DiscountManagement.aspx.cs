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
    static string InsertQuery = "insert into Discounts (Catalogue_id, URL, Comment) values (@Catalogue_id, @URL, @Comment)";
    static string DeleteQuery = "delete from Discounts where id = @id";
    SqlCommand InsertCommand = new SqlCommand(InsertQuery, iKConnection);
    SqlCommand DeleteCommand = new SqlCommand(DeleteQuery, iKConnection);

    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(DiscountsGridView.UniqueID.ToString());
        CSM.RegisterForEventValidation(AddButton.UniqueID.ToString());
        base.Render(writer);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
    }


    protected void DiscountsView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteCommand.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DeleteCommand.ExecuteNonQuery();
            DeleteCommand.Parameters.Clear();
            DiscountsGridView.DataBind();
            DiscountUpdatePanel.Update();
        }
    }
    protected void AddButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            InsertCommand.Parameters.AddWithValue("Catalogue_id", CatalogueList.SelectedValue);
            InsertCommand.Parameters.AddWithValue("URL", URLInput.Text);
            InsertCommand.Parameters.AddWithValue("Comment", CommentInput.Text);
            InsertCommand.ExecuteNonQuery();
            DiscountsGridView.DataBind();
            DiscountUpdatePanel.Update();
        }
    }
}
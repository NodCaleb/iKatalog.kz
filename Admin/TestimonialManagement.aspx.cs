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
    static string ApproveQuery = "update Testimonials set Approved = 1 where id = @id";
    static string DeclineQuery = "update Testimonials set Approved = 0 where id = @id";
    static string DeleteQuery = "delete from Testimonials where id = @id";
    SqlCommand ApproveCommand = new SqlCommand(ApproveQuery, iKConnection);
    SqlCommand DeclineCommand = new SqlCommand(DeclineQuery, iKConnection);
    SqlCommand DeleteCommand = new SqlCommand(DeleteQuery, iKConnection);

    protected override void Render(HtmlTextWriter writer)
    {
        //CSM.RegisterForEventValidation(DiscountsGridView.UniqueID.ToString());
        //CSM.RegisterForEventValidation(AddButton.UniqueID.ToString());
        base.Render(writer);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
    }


    protected void TestimonialsView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ApproveLine")
        {
            ApproveCommand.Parameters.Clear();
            ApproveCommand.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            ApproveCommand.ExecuteNonQuery();
            TestimonialsGridView.DataBind();
            TestimonialsUpdatePanel.Update();
        }
        if (e.CommandName == "DeclineLine")
        {
            DeclineCommand.Parameters.Clear();
            DeclineCommand.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DeclineCommand.ExecuteNonQuery();
            TestimonialsGridView.DataBind();
            TestimonialsUpdatePanel.Update();
        }
        if (e.CommandName == "DeleteLine")
        {
            DeleteCommand.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DeleteCommand.ExecuteNonQuery();
            DeleteCommand.Parameters.Clear();
            TestimonialsGridView.DataBind();
            TestimonialsUpdatePanel.Update();
        }
    }
}
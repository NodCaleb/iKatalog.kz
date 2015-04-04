using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;

public partial class Customer_NewOrder : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string DeleteitemString = "delete from DailySpecials where id = @Line_id";
    static string AddItemString = "insert into DailySpecials (RecordDate, Article_id, ArticleNameDe, ArticleNameRu, PriceOld, PriceNew, Sizes, Colors, ImageURL) values (@RecordDate, @Article_id, @ArticleNameDe, @ArticleNameRu, @PriceOld, @PriceNew, @Sizes, @Colors, @ImageURL)";
    SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    SqlCommand DeleteItem = new SqlCommand(DeleteitemString, iKConnection);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
	//DateInput.Text = DateTime.Today.ToString();
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(AddItemButton.UniqueID.ToString());
        CSM.RegisterForEventValidation(DailySpecialsHistoryGridView.UniqueID.ToString());        
        base.Render(writer);
    }
    protected void AddItemButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            AddItem.Parameters.Clear();
	    if (DateInput.Text == "") AddItem.Parameters.AddWithValue("RecordDate", DateTime.Today.ToString());
	    else AddItem.Parameters.AddWithValue("RecordDate", DateInput.Text);
            AddItem.Parameters.AddWithValue("Article_id", Article_idInput.Text);
            AddItem.Parameters.AddWithValue("ArticleNameDe", ArticleNameDeInput.Text);
            AddItem.Parameters.AddWithValue("ArticleNameRu", ArticleNameRuInput.Text);
            if (PriceOldInput.Text == "") AddItem.Parameters.AddWithValue("PriceOld", "0");
            else AddItem.Parameters.AddWithValue("PriceOld", Decimal.Parse(PriceOldInput.Text));
            AddItem.Parameters.AddWithValue("PriceNew", Decimal.Parse(PriceNewInput.Text));
	    AddItem.Parameters.AddWithValue("Sizes", SizesInput.Text);
	    AddItem.Parameters.AddWithValue("Colors", ColorsInput.Text);
            AddItem.Parameters.AddWithValue("ImageURL", ImageURLInput.Text);
            AddItem.ExecuteNonQuery();
	    //DateInput.Text = DateTime.Today.ToString();
            Article_idInput.Text = "";
            ArticleNameDeInput.Text = "";
            ArticleNameRuInput.Text = "";
            PriceOldInput.Text = "";
            PriceNewInput.Text = "";
            ImageURLInput.Text = "";
            DailySpecialsHistoryGridView.DataBind();
            DailySpecialsUpdatePanel.Update();
        }
    }
    protected void DailySpecialsHistoryGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteItem.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            DeleteItem.ExecuteNonQuery();
            DailySpecialsHistoryGridView.DataBind();
            DailySpecialsUpdatePanel.Update();
        }
    }
}
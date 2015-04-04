using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Crew : System.Web.UI.Page
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string AddTestimonialString = "insert into Testimonials (Name, City, Email, Body) values (@name, @city, @email, @body)";
    static SqlCommand AddTestimonial = new SqlCommand(AddTestimonialString, iKConnection);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        Page.Header.Title = "Отзывы клиентов iKatalog - заказ товаров по каталогам";
	Page.MetaDescription = "Отзывы клиентов компании iKatalog о работе, форма обратной связи, оцените доставку одежды заказанную по каталогам zara, h m и других";
    }
    protected void AddTestimonialButton_Click(object sender, EventArgs e)
    {
	if (Page.IsValid)
        {
            AddTestimonial.Parameters.Clear();
            AddTestimonial.Parameters.AddWithValue("name", NameInput.Text);
            AddTestimonial.Parameters.AddWithValue("city", CityInput.Text);
            AddTestimonial.Parameters.AddWithValue("email", EmailInput.Text);
            AddTestimonial.Parameters.AddWithValue("body", TestimonialInput.Text);
            AddTestimonial.ExecuteNonQuery();
            
            FormPanel.Visible = false;
            GratitudePanel.Visible = true;
            TestimonialUpdatePanel.Update();
        }       
    }
}
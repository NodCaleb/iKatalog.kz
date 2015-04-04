using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Drawing;

public partial class Forum : System.Web.UI.Page
{
    public MembershipUser AuthorizedUser;

    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string UserQueryString = "select top 1 FullName, FirstName, IsAdmin, OrderCount, Customer_id from CustomerInfo where User_id = @User_id";
    static string XrateReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, GETDATE())";
    static string XrateWriteString = "insert into Xrates (Xrate) values (@Xrate)";
    static string XrateMorningReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, DATEADD(DD,-1,GETDATE()))";
    static string XratMorningeWriteString = "insert into Xrates ([Date], Xrate) values (DATEADD(DD,-1,GETDATE()), @Xrate)";
    SqlCommand XrateRead;// = new SqlCommand(XrateReadString, iKConnection);
    SqlCommand XrateWrite;// = new SqlCommand(XrateWriteString, iKConnection);
    //SqlCommand XrateMorningRead = new SqlCommand(XrateReadString, iKConnection);
    //SqlCommand XrateMorningWrite = new SqlCommand(XrateWriteString, iKConnection);
    SqlCommand UserInfo = new SqlCommand(UserQueryString, iKConnection);
    XmlTextReader Xreader = new XmlTextReader("http://www.nationalbank.kz/rss/rates_all.xml");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();

        AuthorizedUser = Membership.GetUser(); //Вот это надо писать при логине в параметры сесии, при отсутствии оных, читать из базы, также приверять их при открытии страницы оформления заказа
        if (AuthorizedUser != null)
        {
            UserInfo.Parameters.AddWithValue("User_id", AuthorizedUser.ProviderUserKey.ToString());
            SqlDataReader UserCredentials = UserInfo.ExecuteReader();
            UserCredentials.Read();

            if (UserCredentials.HasRows)
            {
                if (UserCredentials["IsAdmin"].ToString() == "True") ControlPanel.Visible = true;
                Session["Customer"] = UserCredentials["Customer_id"].ToString();

                UserFullNameDisplay.Text = "Здравствуйте, " + UserCredentials["FirstName"].ToString();
            }
            else
            {
                UserFullNameDisplay.Text = "Здравствуйте, " + AuthorizedUser.UserName.ToString();

                Session["Customer"] = "-1";
            }

            UserCredentials.Close();
            LoginMultiView.ActiveViewIndex = 1;
        }
        else
        {
            Session["Customer"] = "-1";
            LoginMultiView.ActiveViewIndex = 0;
        }
    }
    protected void LogoutImageButton_Click(object sender, ImageClickEventArgs e)
    {
        FormsAuthentication.SignOut();
        Roles.DeleteCookie();
        Session.Clear();
        Response.Redirect(Request.RawUrl);
    }
    protected void LoginImageButton_Click(object sender, ImageClickEventArgs e)
    {
        if (Membership.ValidateUser(UserNameTextBox.Text, PasswordTextBox.Text))
        {
            FormsAuthentication.RedirectFromLoginPage(UserNameTextBox.Text, RememberMe.Checked);
            Response.Redirect(Request.RawUrl);
        }
        else
        {
            UserNameTextBox.BackColor = Color.OrangeRed;
            PasswordTextBox.BackColor = Color.OrangeRed;
        }
    }
}
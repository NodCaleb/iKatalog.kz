using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using iKGlobal;

public partial class News : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string RequestTitleString = "select Header, Teaser, MetaTitle, MetaDescription from News where id = @Article";
    static string RequestTagString = "select Tag, Isnull(MetaTitle, '') as MetaTitle, IsNull(MetaDesciption, '') as MetaDesciption from Tags where id = @Tag_id";
    static string GetKeywordsString = "select Tag from	NewsTags as NT join Tags as T on T.id = NT.Tag_id where News_id = @News_id";
    SqlCommand RequestTitle = new SqlCommand(RequestTitleString, iKConnection);
    SqlCommand RequestTag = new SqlCommand(RequestTagString, iKConnection);
    SqlCommand GetKeywords = new SqlCommand(GetKeywordsString, iKConnection);

    protected int Positive(int SkipStep)
    {
        if (SkipStep < 0) return 0;
        return SkipStep;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //Page.Header.Title = "iKatalog - новости портала";
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        
        int Article = -1;
        int Tag = -1;

        if (Request.QueryString["Article"] != null)
        {
            try
            {
                Article = Int16.Parse(Request.QueryString["Article"].ToString());

                RequestTitle.Parameters.AddWithValue("Article", Article);
                SqlDataReader TitleReader = RequestTitle.ExecuteReader();
                TitleReader.Read();
                Page.Header.Title = TitleReader["Header"].ToString();
                Page.MetaDescription = TitleReader["MetaDescription"].ToString();
                TitleReader.Close();
                
                string KeyWords = "";
                
                GetKeywords.Parameters.AddWithValue("News_id", Article);
                SqlDataReader KeyWordsReader = GetKeywords.ExecuteReader();
                while (KeyWordsReader.Read())
                {
                    KeyWords += KeyWordsReader["Tag"].ToString();
                    KeyWords += " ";
                }
                KeyWordsReader.Close();
                Page.MetaKeywords = KeyWords;
                
                FullViewPanel.Visible = true;
                TeaserViewPanel.Visible = false;
                //TagLabel.Visible = false;
                
            }
            catch
            {
                Article = -1;
                Page.Header.Title = "iKatalog - новости портала";
            }

            NewsSource.SelectParameters["Article"].DefaultValue = Article.ToString();
            //Page.Title = "Новость";
        }
        else
        {
            NewsSource.SelectParameters["Article"].DefaultValue = "-1";
            Page.Header.Title = "iKatalog - новости портала о последних новинках в каталогах";
            Page.MetaDescription = "Информация о поступивших новых каталогах KiK24, текущих акциях в каталогах H M,  Bonprix, ZARA, Gucci из Германии";
        }
        if ((Request.QueryString["Tag"] != null) & (Request.QueryString["Article"] == null))
        {
            try
            {
                Tag = Int16.Parse(Request.QueryString["Tag"].ToString());
                
                RequestTag.Parameters.AddWithValue("Tag_id", Tag);
                SqlDataReader TagReader = RequestTag.ExecuteReader();
                TagReader.Read();
                Page.Header.Title += " (" + TagReader["Tag"].ToString() + ")";
                TagLabel.Text += " (" + TagReader["Tag"].ToString() + ")";
                iClass.CreateLog(TagReader["MetaTitle"].ToString(), "Main");
                if (TagReader["MetaTitle"].ToString() != "") Page.Header.Title = TagReader["MetaTitle"].ToString();
                if (TagReader["MetaDesciption"].ToString() != "") Page.MetaDescription = TagReader["MetaDesciption"].ToString();
                
                TagReader.Close();
            }
            catch
            {
                Tag = -1;
            }
            
            NewsSource.SelectParameters["Tag_id"].DefaultValue = Tag.ToString();
            NewsTeaserSource.SelectParameters["Tag_id"].DefaultValue = Tag.ToString();
            NewsPaginationSource.SelectParameters["tag"].DefaultValue = Tag.ToString();
        }
        else
        {
            NewsSource.SelectParameters["Tag_id"].DefaultValue = "-1";
        }
        if (Request.QueryString["Skip"] != null)
        {
            int Skip;
            try
            {
                Skip = Int16.Parse(Request.QueryString["Skip"].ToString());
            }
            catch
            {
                Skip = 0;
            }

            NewsSource.SelectParameters["Skip"].DefaultValue = Skip.ToString();
            NewsTeaserSource.SelectParameters["Skip"].DefaultValue = Skip.ToString();
            NewsPaginationSource.SelectParameters["skip"].DefaultValue = Skip.ToString();

            PreviouseLink.NavigateUrl = "~/News.aspx?Skip=" + Positive(Skip - 20).ToString() + "&Tag=" + Tag.ToString();
            NextLink.NavigateUrl = "~/News.aspx?Skip=" + (Skip + 20).ToString() + "&Tag=" + Tag.ToString();
        }
        else
        {
            NewsSource.SelectParameters["Skip"].DefaultValue = "0";
            PreviouseLink.NavigateUrl = "~/News.aspx" + "?Tag=" + Tag.ToString();
            NextLink.NavigateUrl = "~/News.aspx?Skip=20" + "&Tag=" + Tag.ToString();
        }
        if (Article != -1)
        {
            PreviouseLink.NavigateUrl = "~/News.aspx?Article=" + (Article + 1).ToString();
            PreviouseLink.Text = "следующая >";
            NextLink.NavigateUrl = "~/News.aspx?Article=" + (Article - 1).ToString();
            NextLink.Text = "< предыдущая";
        }             
    }
}
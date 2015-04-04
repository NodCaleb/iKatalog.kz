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

public partial class SideModulesDefault : System.Web.UI.MasterPage
{
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string XrateReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, GETDATE())";
    static string XrateWriteString = "insert into Xrates (Xrate) values (@Xrate)";
    static string XrateMorningReadString = "select top 1 Xrate from Xrates where [Date] = convert(date, DATEADD(DD,-1,GETDATE()))";
    static string XratMorningeWriteString = "insert into Xrates ([Date], Xrate) values (DATEADD(DD,-1,GETDATE()), @Xrate)";
    SqlCommand XrateRead;// = new SqlCommand(XrateReadString, iKConnection);
    SqlCommand XrateWrite;// = new SqlCommand(XrateWriteString, iKConnection);
    //SqlCommand XrateMorningRead = new SqlCommand(XrateReadString, iKConnection);
    //SqlCommand XrateMorningWrite = new SqlCommand(XrateWriteString, iKConnection);
    XmlTextReader Xreader = new XmlTextReader("http://www.nationalbank.kz/rss/rates_all.xml");

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        
        if (DateTime.Now.TimeOfDay < DateTime.Parse("00:08:00").TimeOfDay)
        {
            //XrateRead = new SqlCommand(XrateMorningReadString, iKConnection);
            //XrateWrite = new SqlCommand(XratMorningeWriteString, iKConnection);
            XrateRead = new SqlCommand(XrateReadString, iKConnection);
            XrateWrite = new SqlCommand(XrateWriteString, iKConnection);
        }
        else
        {
            XrateRead = new SqlCommand(XrateReadString, iKConnection);
            XrateWrite = new SqlCommand(XrateWriteString, iKConnection);
        }

        if (XrateRead.ExecuteScalar() != null)
        {
            //XrateLabel.Text = XrateRead.ExecuteScalar().ToString();
        }
        else
        {
            try
            {
                do
                {
                    Xreader.Read();
                }
                while (Xreader.Value != "EUR");

                for (int i = 0; i < 6; i++)
                {
                    Xreader.Read();
                }

                XrateWrite.Parameters.AddWithValue("Xrate", Math.Round(Double.Parse(Xreader.Value.Replace(".", ",")) * 1.015, 2));
                XrateWrite.ExecuteNonQuery();
                //XrateLabel.Text = XrateRead.ExecuteScalar().ToString();
            }
            catch
            {
                //XrateLabel.Text = "---";
            }
        }
    }
}

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
using iKGlobal;

public partial class Cron : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string cronFileName = "Cron.txt";
    
    protected void Page_Load(object sender, EventArgs e)
    {
	EnsureDatabaseConnection();
	iClass.CreateLog("Cron started", cronFileName);
	iClass.CreateLog("Coupon warnings sent: " + SendWarning(3).ToString(), cronFileName);
	iClass.CreateLog("Exchange rate set to: " + iClass.GetXrate().ToString(), cronFileName);
	iClass.CreateLog("Cron finished", cronFileName);
    }
    protected int SendWarning(int daysLeft)
    {
	//iClass.CreateLog("Warnings has to be sent here", "Main");
	int count = 0;
	string GetCouponsListString = "select * from CouponData where Order_id is null and DaysLeft = @daysLeft";
	SqlCommand GetCouponsList = new SqlCommand(GetCouponsListString, iKConnection);
	
	GetCouponsList.Parameters.Clear();
	GetCouponsList.Parameters.AddWithValue("daysLeft", daysLeft.ToString());
	
	SqlDataReader CouponsListReader = GetCouponsList.ExecuteReader();
	
	while(CouponsListReader.Read())
	{
	    //iClass.CreateLog(CouponsListReader["Number"].ToString(), "Cron");
	    iClass.SendCouponReminder(CouponsListReader["Number"].ToString());
	    count++;
	}
	
	CouponsListReader.Close();
	
	return count;
    }
    private void EnsureDatabaseConnection()
    {
	if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
    }
}

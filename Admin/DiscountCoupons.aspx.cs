using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using iKGlobal;

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;// + "MultipleActiveResultSets=True";
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    
    static string CraftCouponString = "CraftDiscountCoupon";
    SqlCommand CraftCoupon = new SqlCommand(CraftCouponString, iKConnection);
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
    }
    
    protected void CraftCouponButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            float DiscountEntered;
            try
            {
                DiscountEntered = Single.Parse(DiscountValueInput.Text);
            }
            catch
            {
                DiscountEntered = 0;
            }            
            
            CraftCoupon.Parameters.Clear();            
            CraftCoupon.CommandType = CommandType.StoredProcedure;
            
            SqlParameter Customer_id = new SqlParameter("@Customer_id", SqlDbType.Int);
            Customer_id.Value = CustomerList.SelectedValue.ToString();
            Customer_id.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(Customer_id);
            
            SqlParameter DiscountValue = new SqlParameter("@Value", SqlDbType.SmallMoney);
            DiscountValue.Value = (100 - DiscountEntered) / 100;
            DiscountValue.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(DiscountValue);
            
            SqlParameter Duration = new SqlParameter("@DurationDays", SqlDbType.Int);
            Duration.Value = DurationInput.Text;
            Duration.Direction = ParameterDirection.Input;
            CraftCoupon.Parameters.Add(Duration);
            
            SqlParameter Number = new SqlParameter("@Number", SqlDbType.VarChar);
            Number.Direction = ParameterDirection.Output;
            Number.Size = 10;
            CraftCoupon.Parameters.Add(Number);
            
            CraftCoupon.ExecuteNonQuery();
            CouponsGridView.DataBind();
            CouponsListUpdatePanel.Update();
        }        
    }
    protected void GenerateActivationCoupons(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            float DiscountEntered;
            try
            {
                DiscountEntered = (100 - Single.Parse(ActivationDiscountValueInput.Text)) / 100;
            }
            catch
            {
                DiscountEntered = 0;
            }
            
            int DurationsEntered;
            try
            {
                DurationsEntered = Int16.Parse(ActivationDurationInput.Text);
            }
            catch
            {
                DurationsEntered = 0;
            }
            
            string GetUnactivatedCustomersString = "select * from UnactivatedCustomers";
            //string GetUnactivatedCustomersString = "select 0 as Customer_id";
            SqlCommand GetUnactivatedCustomers = new SqlCommand(GetUnactivatedCustomersString, iKConnection);
            
            SqlDataReader UnactivatedCustomersReader = GetUnactivatedCustomers.ExecuteReader();
            
            while(UnactivatedCustomersReader.Read())
            {
                //iClass.CreateLog(UnactivatedCustomersReader["Customer_id"].ToString() + " " + UnactivatedCustomersReader["FullName"].ToString(), "Main");
                //iClass.SendCouponReminder(CouponsListReader["Number"].ToString());
                iClass.SendActivationCouponNotifcations(iClass.CraftCoupon(Int32.Parse(UnactivatedCustomersReader["Customer_id"].ToString()), DiscountEntered, DurationsEntered));
            }
            
            UnactivatedCustomersReader.Close();
            CouponsGridView.DataBind();
            CouponsListUpdatePanel.Update();
        }        
    }
    protected void SendWarning(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            //iClass.CreateLog("Warnings has to be sent here", "Main");
            string GetCouponsListString = "select * from CouponData where Order_id is null and DaysLeft = @daysLeft";
            SqlCommand GetCouponsList = new SqlCommand(GetCouponsListString, iKConnection);
            
            GetCouponsList.Parameters.Clear();
            GetCouponsList.Parameters.AddWithValue("daysLeft", LeftDurationInput.Text);
            
            SqlDataReader CouponsListReader = GetCouponsList.ExecuteReader();
            
            while(CouponsListReader.Read())
            {
                //iClass.CreateLog(LeftDurationInput.Text + " days: " + CouponsListReader["Number"].ToString(), "Main");
                iClass.SendCouponReminder(CouponsListReader["Number"].ToString());
            }
            
            CouponsListReader.Close();
        }
    }
    protected void CouponsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "NotifyCustomer")
        {
            iClass.SendCouponIssueNotifcations(e.CommandArgument.ToString());
        }
    }
}
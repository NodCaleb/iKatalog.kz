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

public partial class Admin_OrderManagement : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
        Page.MetaDescription = "Посмотреть статусы ваших активных заказов вы можете на странице Заказы в работе. Здесь отображаются оформленные, но еще не доставленные заказы.";
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(ActiveOrdersGridView.UniqueID.ToString());
        base.Render(writer);
    }
    protected void OrderListDataBound(object sender, EventArgs e)
    {
        if (ActiveOrdersGridView.Rows.Count == 0)
        {
            NoOrderLabel.Visible = true;
            OrdersInfoLink.Visible = false;
        }
        else
        {
            NoOrderLabel.Visible = false;
            OrdersInfoLink.Visible = true;
        }
    }
    protected void PaymentsListDataBound(object sender, EventArgs e)
    {
        if (PaymentsGridView.Rows.Count == 0)
        {
            NoPaymentLabel.Visible = true;
            PaymentInfoLink.Visible = false;
        }
        else
        {
            NoPaymentLabel.Visible = false;
            PaymentInfoLink.Visible = true;
        }
    }
    protected void CouponsListDataBound(object sender, EventArgs e)
    {
        if (CouponsGridView.Rows.Count == 0)
        {
            NoCouponsLabel.Visible = true;
            CouponsInfoLink.Visible = false;
        }
        else
        {
            NoCouponsLabel.Visible = false;
            CouponsInfoLink.Visible = true;
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class rss : System.Web.UI.Page
{
    static string Payment_id;
    
    protected void Page_Load(object sender, EventArgs e)
    {		
		if (Request.QueryString["ContractNumber"] != null)
        {
            this.LMI_PAYMENT_DESC.Value = "Account deposit for contract #" + Request.QueryString["ContractNumber"].ToString();
        }
        if (Request.QueryString["LMI_PAYMENT_AMOUNT"] != null)
        {
            this.LMI_PAYMENT_AMOUNT.Value = Request.QueryString["LMI_PAYMENT_AMOUNT"].ToString();
        }
        if (Request.QueryString["CLIENT_MAIL"] != null)
        {
            this.CLIENT_MAIL.Value = Request.QueryString["CLIENT_MAIL"].ToString();
        }
        if (Request.QueryString["Payment_id"] != null)
        {
            Payment_id = Request.QueryString["Payment_id"].ToString();
        }
		
		string PaymentNo = ("000000").Substring(0,6 - Payment_id.Length) + Payment_id;
		this.LMI_PAYMENT_NO.Value = PaymentNo;
    }
}
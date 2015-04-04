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
    protected void Page_Load(object sender, EventArgs e)
    {
		//TestLabel.Text = Session["Customer"].ToString();
		//PaymentNo.Text = "123123";
		String PaymentGUID = Guid.NewGuid().ToString();
		string PaymentNo = PaymentGUID.Substring(0,8);
		this.LMI_PAYMENT_NO.Value = PaymentNo;
		this.LMI_PAYMENT_DESC.Value = "Account deposit for contract #" + Session["ContractNumber"].ToString();
		this.CLIENT_MAIL.Value = Session["UserMail"].ToString();
    }
}
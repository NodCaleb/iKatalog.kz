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
    protected void Page_Load(object sender, EventArgs e)
    {
        EmptyOrderLabel.Visible = false;
                
        if (PaymentsGridView.Rows.Count == 0)
        {
            EmptyOrderLabel.Visible = true;
        }
        else
        {
            EmptyOrderLabel.Visible = false;
        }          
    }
}
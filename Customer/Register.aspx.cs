using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using System.Threading;
using iKGlobal;

public partial class Customer_Register : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    protected void Page_Load(object sender, EventArgs e)
    {
	Response.Redirect("~/Default.aspx?action=register");
    }    
}
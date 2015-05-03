using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using iKGlobal;

public partial class About : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    protected void RegisterCustomer(object sender, EventArgs e)
    {	
	if (iClass.CheckEmailExistence(EmailTextBox.Text))
        {
            EmailUniquenessValidator.IsValid = false;
        }
        else
        {
            EmailUniquenessValidator.IsValid = true;
        }
	
	if (Page.IsValid)
        {   
	    //Здесь и далее в качестве имени пользователя используется email
	    if (iClass.RegisterCustomerLite(EmailTextBox.Text, UserFullNameTextBox.Text, PhoneTextBox.Text))
	    {
		iClass.SendRegisterNotifcations(EmailTextBox.Text, UserFullNameTextBox.Text, PhoneTextBox.Text);
		
		string couponNumber = iClass.CraftCoupon(iClass.GetCustomerIDByLogin(EmailTextBox.Text), 0.95f, 7);
		iClass.SendCouponIssueNotifcations(couponNumber);
		
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(EmailTextBox.Text, true, 30);
		string encTicket = FormsAuthentication.Encrypt(ticket);
		Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
		Response.Redirect("~/Customer/RegisterSuccess.aspx?username=" + EmailTextBox.Text);
	    }
	    else
	    {
		Response.Redirect("~/Customer/RegisterFail.aspx");
	    }
        }
    }
    protected void RegisterCustomer2(object sender, EventArgs e)
    {	
	if (iClass.CheckEmailExistence(EmailTextBox2.Text))
        {
            EmailUniquenessValidator2.IsValid = false;
        }
        else
        {
            EmailUniquenessValidator2.IsValid = true;
        }
	
	if (Page.IsValid)
        {   
	    //Здесь и далее в качестве имени пользователя используется email
	    if (iClass.RegisterCustomerLite(EmailTextBox2.Text, UserFullNameTextBox2.Text, PhoneTextBox2.Text))
	    {
		iClass.SendRegisterNotifcations(EmailTextBox2.Text, UserFullNameTextBox2.Text, PhoneTextBox2.Text);
		
		string couponNumber = iClass.CraftCoupon(iClass.GetCustomerIDByLogin(EmailTextBox2.Text), 0.95f, 7);
		iClass.SendCouponIssueNotifcations(couponNumber);
		
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(EmailTextBox2.Text, true, 30);
		string encTicket = FormsAuthentication.Encrypt(ticket);
		Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
		Response.Redirect("~/Customer/RegisterSuccess.aspx?username=" + EmailTextBox2.Text);
	    }
	    else
	    {
		Response.Redirect("~/Customer/RegisterFail.aspx");
	    }
        }
    }
}
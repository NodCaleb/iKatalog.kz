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
using System.Xml;
using iKGlobal;

public partial class Request_Handler : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    static HttpContext handlerContext;// = HttpContext.Current;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        handlerContext = HttpContext.Current;
	
	Response.ContentType = "text/xml";
        Response.ContentEncoding = Encoding.UTF8;

        XmlTextWriter XMLWriter = new XmlTextWriter(Response.OutputStream, Encoding.UTF8);
	
	WriteOpening(XMLWriter);
	
	if (handlerContext.Request.Params["appId"] != "834F9EAF-B3C0-4FD1-B687-555394BC4E01")
	{
	    WriteNoAccess(XMLWriter);
	}
	else if (handlerContext.Request.Params["action"] == "register")
	{	
	    WriteRegister(XMLWriter);
	}
	else
	{
	    WriteNoAction(XMLWriter);
	}
	
	WriteEnding(XMLWriter);

        XMLWriter.Flush();
        Response.End();
    }
    
    private void WriteOpening(XmlTextWriter XMLWriter)
    {
        String PItext = "version='1.0' encoding='UTF-8'";
        XMLWriter.WriteProcessingInstruction("xml", PItext);
        XMLWriter.WriteStartElement("response");
    }
    private void WriteEnding(XmlTextWriter XMLWriter)
    {
        XMLWriter.WriteEndElement();
        //XMLWriter.WriteEndElement();
    }
    private void WriteNoAccess(XmlTextWriter XMLWriter)
    {
	XMLWriter.WriteElementString("result", "1");
    }
    private void WriteNoAction(XmlTextWriter XMLWriter)
    {
	XMLWriter.WriteElementString("result", "2");
    }
    private void WriteRegister(XmlTextWriter XMLWriter)
    {
        if (iClass.CheckEmailExistence(handlerContext.Request.Params["mail"].ToString()))
	{
	    XMLWriter.WriteElementString("result", "3");
	}
	else
	{
	    if (iClass.RegisterCustomerLite(handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString()))
	    {
		iClass.SendRegisterNotifcations(handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString(), handlerContext.Request.Params["mail"].ToString());
		XMLWriter.WriteElementString("result", "0");
	    }
	    else
	    {
		XMLWriter.WriteElementString("result", "4");
	    }
	}
    }
    
}
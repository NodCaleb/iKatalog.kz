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
    
    StringBuilder str = new StringBuilder();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        
        XrateLabel.Text = iClass.GetXrate().ToString();
        
        if (!IsPostBack)
        {      
            chart_bind();
        }
    }
    private DataTable GetData()
    {
        DataTable dt = new DataTable();
        string cmd = "select Date, MAX(Xrate) as Xrate from Xrates where Date > dateadd(DD,-90,GetDate()) group by Date";
        SqlDataAdapter adp = new SqlDataAdapter(cmd, iKConnection);
        adp.Fill(dt);
        return dt;       
    }
    private void chart_bind()
    {      
        DataTable dt = new DataTable();
        try
        {
            dt = GetData();                     
          
            str.Append(@"<script type=*text/javascript*> google.load( *visualization*, *1*, {packages:[*corechart*]});
            google.setOnLoadCallback(drawChart);
            function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Дата');
            data.addColumn('number', 'Курс');
 
            data.addRows(" + dt.Rows.Count + ");");
 
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                str.Append("data.setValue( " + i + "," + 0 + "," + "'" + dt.Rows[i]["Date"].ToString() + "');");
                str.Append("data.setValue(" + i + "," + 1 + "," + dt.Rows[i]["Xrate"].ToString() + ") ;"); 
            }
            
            str.Append("   var chart = new google.visualization.LineChart(document.getElementById('chart_div'));");
            str.Append(" chart.draw(data, {width: 660, height: 300, titlePosition: 'none',  curveType: 'function', ");
            //str.Append("hAxis: {format: 'MMM d, y'}, ");
            str.Append("legend: {position: 'none'}");
            str.Append("}); }");
            str.Append("</script>");
            lt.Text = str.ToString().Replace('*', '"');        
        }
        catch
        { }   
    }

}
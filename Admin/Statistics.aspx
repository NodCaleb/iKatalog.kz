<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Statistics.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - статистика</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="MonthlyStatisticsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
		convert (varchar(4), datepart (year, CreateDate)) + '-' + convert (varchar(2), datepart (MM, CreateDate)) as Period,
		count (*) as Registrations  
	    from aspnet_membership
	    group by
		datepart (year, CreateDate),
		datepart (MM, CreateDate)
	    order by
		datepart (year, CreateDate) desc,
		datepart (MM, CreateDate) desc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DailyStatisticsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
	    select
	      D.Date,
	      isnull (R.Registrations, 0) as Registrations,
	      isnull (A.Requests, 0) as Requests,
	      isnull (O.Orders, 0) as Orders
	    from
	      (select Date from xrates) as D
	      left join (select convert (date, CreateDate) as Date, count (*) as Registrations from aspnet_membership group by convert(date, CreateDate)) as R on R.Date = D.Date
	      left join (select convert (date, Date) as Date, count (*) as Requests from AskMeRequests group by convert(date, Date)) as A on A.Date = D.Date
	      left join (select convert (date, CreationDate) as Date, count (*) as Orders from Orders where OrderStatus <> -1 group by convert(date, CreationDate)) as O on O.Date = D.Date
	    where
	      D.Date >= '2014-10-01'
	    order by
	      D.Date Desc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="KtradeStatusesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT KtradeStatus_id, KtradeStatusDescription FROM [KtradeStatuses]"></asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Дневная статистика:</h2>
    <asp:GridView ID="DailyStatisticsGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataSourceID="DailyStatisticsSource" 
	EnableModelValidation="True"
	AllowSorting="True"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	PageSize="15">
	<Columns>
	    <asp:TemplateField HeaderText="Дата" SortExpression="Date">
		<ItemTemplate>
		    <asp:Label ID="PeriodLabel" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Регистрации" SortExpression="Registrations">
		<ItemTemplate>
		    <asp:Label ID="RegistrationsLabel" runat="server" Text='<%# Bind("Registrations") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Запросы" SortExpression="Registrations">
		<ItemTemplate>
		    <asp:Label ID="RequestsLabel" runat="server" Text='<%# Bind("Requests") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Заказы" SortExpression="Registrations">
		<ItemTemplate>
		    <asp:Label ID="OrdersLabel" runat="server" Text='<%# Bind("Orders") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	</Columns>
	<SelectedRowStyle BackColor="#FFFF66" />
    </asp:GridView>
    <h2>Помесячная статистика:</h2>
    <asp:GridView ID="MonthlyStatisticsGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataSourceID="MonthlyStatisticsSource" 
	EnableModelValidation="True"
	AllowSorting="True"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	PageSize="15">
	<Columns>
	    <asp:TemplateField HeaderText="Период" SortExpression="Period">
		<ItemTemplate>
		    <asp:Label ID="PeriodLabel" runat="server" Text='<%# Bind("Period") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Регистрации" SortExpression="Registrations">
		<ItemTemplate>
		    <asp:Label ID="RegistrationsLabel" runat="server" Text='<%# Bind("Registrations") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	</Columns>
	<SelectedRowStyle BackColor="#FFFF66" />
    </asp:GridView>
</asp:Content>


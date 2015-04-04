<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CorsoStock.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - остатки Corso</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CorsoStockSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
		    Date,
		    Count (*) as Items
	    from
		    StockItems
	    group by
		    Date
	    Order by
		    Date desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Остатки Corso:</h2>
    <asp:GridView ID="CorosStockGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataSourceID="CorsoStockSource"
	EnableModelValidation="True"
	AllowSorting="True"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	onrowcommand="StockGridView_RowCommand"
	PageSize="15">
	<Columns>
	    <asp:TemplateField HeaderText="Дата" SortExpression="Date">
		<ItemTemplate>
		    <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("Date", "{0:yyyy-MM-dd}") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Количество SKU" SortExpression="Items">
		<ItemTemplate>
		    <asp:Label ID="ItemsLabel" runat="server" Text='<%# Bind("Items") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Скачать" SortExpression="Date">
		<ItemTemplate>
		    <asp:LinkButton ID="ExportButton" runat="server" CausesValidation="False" CommandName="Export" CommandArgument='<%# Bind("Date", "{0:yyyy-MM-dd}") %>' Text='Товары'></asp:LinkButton>
		    <asp:LinkButton ID="ExportSizesButton" runat="server" CausesValidation="False" CommandName="ExportSizes" CommandArgument='<%# Bind("Date", "{0:yyyy-MM-dd}") %>' Text='Размеры'></asp:LinkButton>
		</ItemTemplate>
	    </asp:TemplateField>
	</Columns>
	<SelectedRowStyle BackColor="#FFFF66" />
    </asp:GridView>
</asp:Content>


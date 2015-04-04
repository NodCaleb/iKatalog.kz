<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="StaticPages.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="Stylesheet" href="css/News.css" />
    <link rel="Stylesheet" href="css/Infos.css" />
    <title>Страницы</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="PageSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
				id,
				[Name],
				[Body]
			from
				StaticPages
			where
				id = @Page">
        <SelectParameters>
            <asp:Parameter Name="Page" DefaultValue="-1" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="PageRepeater" runat="server" DataSourceID="PageSource">
        <ItemTemplate>
            <div class="newsblock">
                <asp:Label ID="NewsBodyLabel" runat="server" Text='<%# Eval("Body") %>'></asp:Label>
		<asp:HiddenField ID="NewsId" Value ='<%# Eval("id") %>'  runat="server" />
            </div>            
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
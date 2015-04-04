<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="OrderingRules.aspx.cs" Inherits="Groessen" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Ktrade - калькулятор стоимости заказа</title>
    <link rel="Stylesheet" href="../css/Infos.css" />
    <link rel="Stylesheet" href="../css/SideBar.css" />
    <!-- link rel="Stylesheet" href="../css/News.css" / -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CataloguesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
	SelectCommand="select * from CataloguesView where OrderingRules <> '' order by CatalogueName">
	<SelectParameters>
	    <asp:Parameter Name="Tag" DefaultValue="Active" />
	</SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="GeneralRulesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select body from StaticPages where id = 1">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="FAQSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select body from StaticPages where id = 12">
    </asp:SqlDataSource>
    <div class="background">
    <h1>Как оформить заказ на сайте iKatalog.kz</h1>
	<p><a href="#generalrules">общие правила</a> | <a href="#orderingrules">как заполнить форму заказа</a> | <a href="#faq">вопросы и ответы по оформлению заказа</a></p>
	<h2>Видео-инструкция</h2>
	<iframe width="640" height="360" src="//www.youtube.com/embed/LsRO7b5oNHs" frameborder="0" allowfullscreen></iframe>
	<h2 id="generalrules">Общие правила оформления</h2>
	<asp:Repeater ID="GeneralRulesRepeater" runat="server" DataSourceID="GeneralRulesSource">
	    <ItemTemplate>
		<div class="newsblock">
		    <asp:Label ID="NewsBodyLabel" runat="server" Text='<%# Eval("Body") %>'></asp:Label>
		</div>            
	    </ItemTemplate>
	</asp:Repeater>
	<h2 id="orderingrules">Как заполнить форму заказа</h2>
	<table class="rulestable" border="0" cellpadding="0" cellspacing="0">
	    <tbody>
		<tr style="height: 20px;">
		    <td colspan=2 style="text-align: center; font-weight: bold">Название</td>
		    <td style="text-align: center; font-weight: bold">Правила оформления</td>
		</tr>
		<asp:UpdatePanel ID="ListUpdatePanel" runat="server" UpdateMode="Conditional">
		    <ContentTemplate>
			<asp:Repeater ID="CataloguesRepeater" runat="server" DataSourceID="CataloguesSource">
			    <ItemTemplate>
				<tr id='<%# Eval("CatalogueName") %>'>
				    <td width='106px'><asp:Image ID="CatalogueLogo" runat="server" ImageUrl='<%# Eval("ImageLink") %>' AlternateText="Logo" /></td>
				    <td width='114px'><asp:Label ID="CatalogueNameLabel" runat="server" style="font-size: smaller; line-height: normal;" Text='<%# Eval("CatalogueName") %>'/></td>
				    <td><asp:Label ID="RulesLabel" runat="server" style="font-size: smaller; line-height: normal;" Text='<%# Eval("OrderingRules") %>'/></td>
				</tr>
			    </ItemTemplate>
			</asp:Repeater>
		    </ContentTemplate>
		</asp:UpdatePanel>
	    </tbody>
	</table>
	<h2 id="faq">Вопросы и ответы по оформлению заказа</h2>
	<asp:Repeater ID="FAQRepeater" runat="server" DataSourceID="FAQSource">
	    <ItemTemplate>
		<div class="newsblock">
		    <asp:Label ID="NewsBodyLabel" runat="server" Text='<%# Eval("Body") %>'></asp:Label>
		</div>            
	    </ItemTemplate>
	</asp:Repeater>
    </div>
</asp:Content>


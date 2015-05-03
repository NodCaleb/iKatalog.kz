<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="Information.aspx.cs" Inherits="Information" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - информация</title>
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
	<h1>Полезная информация</h1>
	<ul>
	    <li><asp:HyperLink ID="FAQLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=12">Вопросы и ответы по оформлению заказов</asp:HyperLink></li>
	    <li><asp:HyperLink ID="WoerteBuchLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=9">Словарик немецкого</asp:HyperLink></li>
	    <li><asp:HyperLink ID="GroessenLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=10">Размеры одежды</asp:HyperLink></li>
	    <li><asp:HyperLink ID="KleidungPfledgeSymboleLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=5">Символы ухода за одеждой</asp:HyperLink></li>
	    <li><asp:HyperLink ID="FigureTypesLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=6">Подбор одежды по типу фигуры</asp:HyperLink></li>
	    <li><asp:HyperLink ID="GoodsWeightLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=7">Примерный вес товаров</asp:HyperLink></li>
	    <li><asp:HyperLink ID="EuroChinaLink" runat="server" NavigateUrl="~/StaticPages.aspx?Page=18">Китай или Европа, где лучше заказывать и почему?</asp:HyperLink></li>
	    <li><asp:HyperLink ID="InetVsShopLink" runat="server" NavigateUrl="~/News.aspx?Article=89">Покупки в интернете или в обычном Торговом Центре?</asp:HyperLink></li>
	    <li><asp:HyperLink ID="FiveReasonsLink" runat="server" NavigateUrl="~/News.aspx?Article=90">5 причин почему выгоднее покупать в Германии, а не в Казахстане</asp:HyperLink></li>
	</ul>
    </div>
</asp:Content>


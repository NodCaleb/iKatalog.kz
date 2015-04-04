<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="Discount.aspx.cs" Inherits="Discount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - скидки, распродажи, спецпредложения</title>
    <link rel="Stylesheet" href="css/Discount.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="DiscountSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                        '~/Images/Logos/' +  C.ImageLink as [ImageLink],
                            C.CatalogueDescription,
	                        D.URL,
	                        D.Comment,
							D.CreationDate
                        from
	                        Discounts as D with (nolock)
	                        join Catalogues as C with (nolock) on C.Catalogue_id = D.Catalogue_id
                        where
	                        isnull (D.Expired, 0) = 0
                        order by D.CreationDate desc">
    </asp:SqlDataSource>
    <div class="background">
	<h2>Текущие скидки</h2>
	<asp:Repeater ID="DiscountRepeater" runat="server" DataSourceID="DiscountSource">
	    <ItemTemplate>
		<div class="discount_item">
		    <div class="discount_logo">
			<h5><asp:Label ID="DiscountDateLabel" runat="server" Text='<%# Eval("CreationDate", "{0:d}") %>'></asp:Label></h5>
			<asp:HyperLink ID="DsicountLink" runat="server" NavigateUrl='<%# Eval("URL") %>' target="_blank">
			    <asp:Image ID="DiscuontCatalogueLogo" ImageUrl='<%# Eval("ImageLink") %>' title='<%# Eval("CatalogueDescription") %>' AlternateText="Логотип каталога" runat="server" />
			</asp:HyperLink>
		    </div>
		    <p><asp:Label ID="NewsBodyLabel" runat="server" Text='<%# Eval("Comment") %>'></asp:Label></p>
		</div>
	    </ItemTemplate>
	</asp:Repeater>
	<div style="clear: both;"></div>
    </div>
</asp:Content>


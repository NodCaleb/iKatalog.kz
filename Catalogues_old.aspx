<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesDefault.master" AutoEventWireup="true" CodeFile="Catalogues.aspx.cs" Inherits="Catalogues" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%--<title>iKatalog - каталоги товаров</title>--%>
    <link rel="Stylesheet" href="css/Catalogues.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <%-- asp:Panel ID="PopularCataloguesPanel" runat="server" Visible="False">
        <asp:SqlDataSource ID="PopularCataloguesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
            SelectCommand=" select * from CataloguesView where Catalogue_id in
                            (	
                            SELECT top 4
                                    OI.Catalogue_id
                            from
                                    (
                                    select top 50
                                            id,
                                            Catalogue_id
                                    from
                                            OrderItems
                                    where
                                            Customer_id = @Customer_id
                                    order by
                                            id desc
                                    ) as OI
                            group by
                                    OI.Catalogue_id
                            order by
                                    count (id) desc
                            )">
            <SelectParameters>
                <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        <h2>Популярные каталоги:</h2>
        <asp:Repeater ID="PopularCataloguesRepeater" runat="server" DataSourceID="PopularCataloguesSource">
            <ItemTemplate>
                <div class="catalogue">
                    <asp:HyperLink ID="CatalogueLink" runat="server" NavigateUrl='<%# Eval("Link") %>' Target="_blank">
                        <asp:Image ID="CatalogueLogo" runat="server" ImageUrl='<%# Eval("ImageLink") %>' AlternateText="Logo" Title='<%# Eval("CatalogueDescription") %>' />
                    </asp:HyperLink>
                    <div>
                        <div><%# Eval("PriceIndex") %></div>
                        <asp:Image ID="NoreturnSign" runat="server" ImageUrl='<%# Eval("NoReturnImage") %>' Title='<%# Eval("NoReturnTitle") %>' />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel --%>
    <h2>Электронные каталоги<asp:Label ID="TagLabel" runat="server" Text=""></asp:Label>:</h2>
    <asp:SqlDataSource ID="CataloguesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select * from CataloguesView where Tags like '%' + @Tag + '%' order by CatalogueName">
        <SelectParameters>
            <asp:Parameter Name="Tag" DefaultValue="Active" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="CataloguesRepeater" runat="server" DataSourceID="CataloguesSource">
        <ItemTemplate>
            <div class="catalogue">
                <asp:HyperLink ID="CatalogueLink" runat="server" NavigateUrl='<%# Eval("Link") %>' Target="_blank">
                    <asp:Image ID="CatalogueLogo" runat="server" ImageUrl='<%# Eval("ImageLink") %>' AlternateText="Logo" Title='<%# Eval("CatalogueDescription") %>' />
                </asp:HyperLink>
                <div>
                    <div><%# Eval("PriceIndex") %></div>
                    <asp:Image ID="NoreturnSign" runat="server" ImageUrl='<%# Eval("NoReturnImage") %>' Title='<%# Eval("NoReturnTitle") %>' />
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>


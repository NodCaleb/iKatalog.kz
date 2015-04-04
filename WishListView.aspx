<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesOrders.master" AutoEventWireup="true" CodeFile="WishListView.aspx.cs" Inherits="WishListView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - список желаний</title>
    <link rel="Stylesheet" href="../css/Orders.css" />
    <link rel="Stylesheet" href="../css/Offers.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="SELECT [Catalogue_id], [CatalogueName] FROM [Catalogues] where [Active] = 1 ORDER BY [CatalogueName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="WishesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                W.id,
                W.Catalogue_id,
	        C.CatalogueName,
	        W.Article_id,
	        W.ArticleName,
	        W.Size,
	        W.Colour,
	        W.Price,
	        W.Comment,
		W.URL,
		W.Fullfilled,
		'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=' + Convert(nvarchar(10), W.Catalogue_id) + '&article=' + W.Article_id + '&name=' + W.ArticleName + '&price=' + Replace(Convert(nvarchar(10), Convert(money, W.Price)), '.', ',') + '&size=' + W.Size + '&color=' + W.Colour + '&URL=' + REPLACE(W.URL, 'http://', '') as OrderURL,
		'http://ikatalog.kz/Customer/MyWishList.aspx?catalogue=' + Convert(nvarchar(10), W.Catalogue_id) + '&article=' + W.Article_id + '&name=' + W.ArticleName + '&price=' + Replace(Convert(nvarchar(10), Convert(money, W.Price)), '.', ',') + '&size=' + W.Size + '&color=' + W.Colour + '&URL=' + REPLACE(W.URL, 'http://', '') as WishURL
            from
	        Wishes as W with (nolock)
	        join Catalogues as C with (nolock) on C.Catalogue_id = W.Catalogue_id
            where
	        W.Customer_id = @Customer_id
                and isnull (W.Fullfilled, 0) = 0">
        <SelectParameters>
            <asp:Parameter DefaultValue="-1" Name="Customer_id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="ListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select top 50
		    C.FirstName + ' ' + C.LastName + ' (' + Convert(nvarchar(10), Count(*)) + ')' as Customer,
		    'http://ikatalog.kz/WishListView.aspx?customer=' + Convert(nvarchar(10), C.Customer_id) as URL
	    from
		    Wishes as W with (nolock)
		    join Customers as C with (nolock) on C.Customer_id = W.Customer_id
	    group by
		    C.Customer_id,
		    C.FirstName,
		    C.LastName
	    order by
		    Count(*) desc">
    </asp:SqlDataSource>
    <asp:Panel ID="ListPanel" runat="server" visible="true">
	<h2>Самые большие списки желаний на сегодня:</h2>
	<asp:Repeater ID="WishersList" runat="server" DataSourceID="ListSource">
		<ItemTemplate>
			<h3>
			    <asp:HyperLink ID="ViewLink" runat="server" NavigateUrl='<%# Bind("URL") %>' Text='<%# Bind("Customer") %>'>Открыть</asp:HyperLink>
			</h3>
		</ItemTemplate>
	</asp:Repeater>
    </asp:Panel>
    <asp:Panel ID="NoListPanel" runat="server"  visible="false">
	<h2><asp:Label id="CustomerNameLabel1" Text="Покупатель" runat="server"/> пока не имеет списка желаний...</h2>
    </asp:Panel>
    <asp:Panel ID="WishesPanel" runat="server"  visible="false">
	<h2><asp:Label id="CustomerNameLabel0" Text="Покупатель" runat="server"/> хочет получить в подарок:</h2>
	<asp:GridView ID="WishesGridView" runat="server" GridLines="None"
	    AutoGenerateColumns="False"
	    DataKeyNames="id"
	    DataSourceID="WishesSource" 
	    EnableModelValidation="True">
	    <Columns>
		<asp:TemplateField HeaderText="Каталог" InsertVisible="False" SortExpression="CatalogueName">
		    <ItemTemplate>
			<asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Артикул" InsertVisible="False" SortExpression="Article_id">
		    <ItemTemplate>
			<asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Наименование" InsertVisible="False" SortExpression="ArticleName">
		    <ItemTemplate>
			<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Bind("URL") %>' Text='<%# Bind("ArticleName") %>' Target="_blank">HyperLink</asp:HyperLink>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Размер" InsertVisible="False" SortExpression="Size">
		    <ItemTemplate>
			<asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Цвет" InsertVisible="False" SortExpression="Colour">
		    <ItemTemplate>
			<asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("Colour") %>'></asp:Label>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Цена" SortExpression="Price">
		    <ItemTemplate>
			<asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
		    </ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Действия">
		    <ItemTemplate>
			<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Bind("OrderURL") %>' Target="_blank">Заказать</asp:HyperLink><br/>
			<asp:HyperLink ID="WishLink" runat="server" NavigateUrl='<%# Bind("WishURL") %>' Target="_blank">Хочу себе</asp:HyperLink>
		    </ItemTemplate>
		</asp:TemplateField>
	    </Columns>
	    <SelectedRowStyle BackColor="#FFFF66" />
	</asp:GridView>
    </asp:Panel>
</asp:Content>
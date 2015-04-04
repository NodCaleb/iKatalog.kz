<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesDefault.master" AutoEventWireup="true" CodeFile="DailySpecial.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="Stylesheet" href="css/News.css" />
    <title>Товар дня</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="DailySpecialsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select top 1
                DS.id,
	        DS.Article_id,
	        DS.ArticleNameDe,
                DS.ArticleNameRu,
                case DS.PriceOld when 0 then null else DS.PriceOld end as PriceOld,
                DS.PriceNew as PriceNew,
		DS.Sizes as Sizes,
		DS.Colors as Colors,
                DS.ImageURL as ImageURL,
		'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=199&article=' + DS.Article_id + '&name=' + DS.ArticleNameDe + '&price=' + replace(convert(varchar(10), PriceNew), '.', ',') + '&URL=ikatalog.kz/DailySpecial.aspx' as OrderURL
            from
	        DailySpecials as DS with (nolock)
	    where
		convert(date, RecordDate) <= dbo.getlocaldate()
            order by
                DS.RecordDate desc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DailyTeaserSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select top 7
                DS.ArticleNameRu,
		DS.ImageURL as ImageURL
            from
	        DailySpecials as DS with (nolock)
	    where
		convert(date, RecordDate) > dbo.getlocaldate()
            order by
                NewID()">
    </asp:SqlDataSource>
    <h2>Товар дня</h2>
    <asp:Repeater ID="DailySpecialsRepeater" runat="server" DataSourceID="DailySpecialsSource">
        <ItemTemplate>
	    <table class="DailySpecial"> 
		<tbody> 
			<tr> 
				<td rowspan="5"> <asp:Image ID="ItemImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText='<%# Eval("ArticleNameRu") %>' Title='<%# Eval("ArticleNameRu") %>' style="max-width:400px" /> </td>
				<td><h2><asp:Label ID="ArticleNameRuLabel" runat="server" Text='<%# Bind("ArticleNameRu") %>'></asp:Label></h2></td>
			</tr>
			<tr> 
				<td><strike><asp:Label ID="PriceOldLabel" runat="server" Text='<%# Bind("PriceOld", "{0:#,#.00 €}") %>'></asp:Label></strike> <asp:Label ID="PriceNewLabel" class="newprice" runat="server" Text='<%# Bind("PriceNew", "{0:#,#.00 €}") %>'></asp:Label> </td>
			</tr>
			<tr> 
				<td><b>Размеры в наличии:</b><br/><asp:Label ID="SizesLabel" runat="server" Text='<%# Bind("Sizes") %>'></asp:Label></td>
			</tr>
			<tr> 
				<td><b>Цвета в наличии:</b><br/><asp:Label ID="ColorsLabel" runat="server" Text='<%# Bind("Colors") %>'></asp:Label></td>
			</tr>
			<tr> 
				<td><p class="orderbutton" style="text-align: center;"><a href='<%# Eval("OrderURL") %>' target="_blank"><img alt="" src="Images/OrderButton.png" title="Заказать" /></a></p>
			</td>
			</tr>
		</tbody>
	    </table>
        </ItemTemplate>
    </asp:Repeater>
    <h3>В ближайшее время ожидаются еще:</h3>
    <div>
	<asp:Repeater ID="DailyTeaserRepeater" runat="server" DataSourceID="DailyTeaserSource">
	    <ItemTemplate>
		<asp:Image ID="TeaserImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText='<%# Eval("ArticleNameRu") %>' Title='<%# Eval("ArticleNameRu") %>' style="max-width:80px; margin-right: 16px;" />
	    </ItemTemplate>
	</asp:Repeater>
    </div>
</asp:Content>
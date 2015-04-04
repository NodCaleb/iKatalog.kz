<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="NewsModuleSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT top 7 [Header], '~/News.aspx?Article='+convert(nvarchar(5), [id]) as [URL], [Teaser] FROM [News] where Published = 1 ORDER BY [CreationDate] DESC"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DiscountsModuleSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="select top 5 substring (Comment, 0, 50) as Comment, '/CatalogueView.aspx?Catalogue=' + convert(nvarchar(10), Catalogue_id) + '&URL=' + URL as URL from Discounts order by CreationDate desc"></asp:SqlDataSource>
    <asp:SqlDataSource ID="ForumModuleSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="select top 5 T.Topic,'http://ikatalog.kz/yaf/pureforum.aspx?g=posts&t=' + convert (nvarchar(5), T.TopicID) as URL from yaf_Topic as T join yaf_Message as M on M.TopicID = T.TopicID where T.Isdeleted = 0 group by T.TopicID, T.Topic order by MAX(M.Posted) desc"></asp:SqlDataSource>
    <asp:SqlDataSource ID="UpsellOffersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
	SelectCommand="
	    select top 4
		    UO.id,
		    UO.Catalogue_id,
		    C.CatalogueName,
		    UO.Article_id,
		    UO.ArticleNameDe,
		    UO.ArticleNameRu,
		    case UO.PriceOld when 0 then null else UO.PriceOld end as PriceOld,
		    UO.PriceNew as PriceNew,
		    UO.CatalogueURL as CatalogueURL,
		    UO.ImageURL as ImageURL,
		    UO.RecordDate as RecordDate,
		    '~/Images/Logos/' + C.ImageLink as LogoURL,
		    C.CatalogueName,
		    case isnull(C.NoFrame, 0)
		    when 0 then 'http://ikatalog.kz/CatalogueView.aspx?catalogue=' + convert (nvarchar(25), UO.Catalogue_id) + '&article=' + convert(nvarchar(25), Article_id) + '&name=' + convert(nvarchar(25), ArticleNameDe) + '&price=' + replace(convert(nvarchar(25), PriceNew), '.', ',') + '&URL=' + CatalogueURL
		    else UO.CatalogueURL
		    end as OrderURL
	    from
		    UpsellOffers as UO with (nolock)
		    join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
	    order by
		    NEWID()">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PopularsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
	SelectCommand="
	    select top 5
		    '~/CatalogueView.aspx?Catalogue=' + convert(nvarchar(10), OI.Catalogue_id) as OpenLink,
		    '~/Images/Logos/' + C.ImageLink as ImageLink
	    from
		    OrderItems as OI
		    join Catalogues as C on C.Catalogue_id = OI.Catalogue_id
	    group by
		    OI.Catalogue_id,
		    C.ImageLink
	    order by
		    MAX (OI.id) desc">
    </asp:SqlDataSource>
    <div class="banner">
	<iframe src="Carousel03.html" scrolling="no" width="636" height="321"></iframe>
    </div>
    <div class="category-holder">
	<div class="title-holder">
	    <h2>Категории товаров</h2>
	</div>
	<asp:HyperLink ID="WebCataloguesMenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=men"><div class="category"><div>Мужчинам</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesWomenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=frau"><div class="category-2"><div>Женщинам</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesChildrenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=children"><div class="category"><div>Детям</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesShoesLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=shoes"><div class="category-2"><div>Обувь</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesHomeLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=home"><div class="category"><div>Дом</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesSportLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=sport"><div class="category-2"><div>Спорт</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesMakeupLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=makeup"><div class="category"><div>Парфюмерия и косметика</div></div></asp:HyperLink>
	<asp:HyperLink ID="WebCataloguesSchmuckLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=jems"><div class="category-2"><div>Ювелирные украшения</div></div></asp:HyperLink>
    </div>
    <div style="clear: both"></div>
    <div class="text-holder">
	<p>Компания Ikatalog (Айкаталог), предлагает сервис по заказу женской, мужской, детской одежды, обуви и других товаров из Европы. Быстрая и недорогая доставка на дом, в любой город Казахстана, безопасно и быстро!</p>
	<p>Ваши заказы не облагаются налогами и пошлинами, так как приобретаются для личного пользования, поэтому цена будет существенно ниже цен в розницу, до 50%!</p>
    </div>
    <div class="title-holder">
	<h2>Горячие предложения</h2>
    </div>
    <asp:Repeater ID="OffersRepeater" runat="server" DataSourceID="UpsellOffersSource">
	<ItemTemplate>
	    <div class="offer">
	    <div>
		<h3><%# Eval("ArticleNameRu")%></h3>
		<asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' />
		<div>
		    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
		    <p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike><br/><strong><%# Eval("PriceNew", "{0:#,#.00 €}") %></strong></p>
		</div>
	    </div>
		<p><asp:HyperLink ID="OrderLink" runat="server" target="_blank" NavigateUrl='<%# Eval("OrderURL") %>'>Открыть >>></asp:HyperLink></p>      
	    </div>
	</ItemTemplate>
    </asp:Repeater>
    <div style="clear: both"></div>
    <div class="title-holder">
	<h2>Популярные каталоги</h2>
    </div>
    <div class="populars">
	<table border="0" cellpadding="0" cellspacing="0">
	    <tbody>
		<tr>
		    <asp:Repeater ID="PopularsRepeater" runat="server" DataSourceID="PopularsSource">
			<ItemTemplate>
			    <td><asp:HyperLink ID="PopularLink" runat="server" target="_blank" NavigateUrl='<%# Eval("OpenLink") %>'><asp:Image ID="PopularLogo" runat="server" ImageUrl='<%# Eval("ImageLink") %>' AlternateText="Logo"/></asp:HyperLink></td>
			</ItemTemplate>
		    </asp:Repeater>
		</tr>
	    </tbody>
	</table>
    </div>
    <div class="likebox">
	<div class="fb-like-box" data-href="https://www.facebook.com/goodsiKatalog" data-width="474" data-colorscheme="light" data-show-faces="true" data-header="true" data-stream="false" data-show-border="true"></div>
    </div>
    <div class="likebox">
	<!-- VK Widget -->
	<div id="vk_groups"></div>
	<script type="text/javascript">
	VK.Widgets.Group("vk_groups", {mode: 0, width: "474", height: "271", color1: 'FFFFFF', color2: '2B587A', color3: '5B7FA6'}, 78423724);
	</script>
    </div>
    <div style="clear: both"></div>
    <div class="title-holder">
	<h2>Горячие предложения</h2>
    </div>
    <asp:Repeater ID="OffersRepeater2" runat="server" DataSourceID="UpsellOffersSource">
	<ItemTemplate>
	    <div class="offer">
	    <div>
		<h3><%# Eval("ArticleNameRu")%></h3>
		<asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' />
		<div>
		    <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
		    <p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike><br/><strong><%# Eval("PriceNew", "{0:#,#.00 €}") %></strong></p>
		</div>
	    </div>
		<p><asp:HyperLink ID="OrderLink" runat="server" target="_blank" NavigateUrl='<%# Eval("OrderURL") %>'>Открыть >>></asp:HyperLink></p>      
	    </div>
	</ItemTemplate>
    </asp:Repeater>
    <div style="clear: both"></div>
</asp:Content>


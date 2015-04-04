<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OffersCarousel.aspx.cs" Inherits="OffersCarousel" ValidateRequest="false" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="Stylesheet" href="css/Offers.css" />
		<link rel="Stylesheet" href="css/Carousel.css" />
		<script src="js/jquery-1.7.js"></script>
		<script src="js/jquery.carousel.min.js"></script>
		<script>
			 $(document).ready(function(){
				$("a#aaa").click(function(event){
				 event.preventDefault();
				 $("img#im01").show("slow");
			   });
			 });
		</script>
		<script type="text/javascript">
			$(function(){
				$("div.foo").carousel({nextBtn:false, prevBtn:false, autoSlide: true, autoSlideInterval: 5000, animSpeed: "slow", effect:"scroll"});
			});
		</script>
	</head>
	<body>
		<asp:SqlDataSource ID="ProductsSource" runat="server" ConnectionString="<%$ ConnectionStrings:ShopConnectionString %>"
			ProviderName="<%$ ConnectionStrings:ShopConnectionString.ProviderName %>"
			SelectCommand="        
				select
					PD.Name,
					CONCAT('http://shop.ikatalog.kz/image/', P.Image) as ImageURL,
					CONCAT('http://shop.ikatalog.kz/index.php?route=product/product&amp;product_id=', P.product_id) as ProductURL,
					P.price
				from
					product as P
					join product_description as PD on PD.product_id = P.product_id
				order by rand()
				limit 3
				">
		</asp:SqlDataSource>
		<asp:SqlDataSource ID="UpsellOffersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
			SelectCommand="
				select top 3
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
					'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=' + convert (nvarchar(25), UO.Catalogue_id) + '&article=' + convert(nvarchar(25), Article_id) + '&name=' + convert(nvarchar(25), ArticleNameDe) + '&price=' + replace(convert(nvarchar(25), PriceNew), '.', ',') + '&URL=' + replace (CatalogueURL, 'http://', '') as OrderURL
				from
					UpsellOffers as UO with (nolock)
					join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
				order by
					NEWID()"
			UpdateCommand="update UpsellOffers set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleNameDe = @ArticleNameDe, ArticleNameRu = @ArticleNameRu, PriceOld = replace(@PriceOld, ',', '.'), PriceNew = replace(@PriceNew, ',', '.'), CatalogueURL = @CatalogueURL, ImageURL = @ImageURL where id = @id">
		</asp:SqlDataSource>
		<div class="foo">
			<div>
				<div>
					<asp:Repeater ID="Repeater1" runat="server" DataSourceID="UpsellOffersSource">
						<ItemTemplate>
							<div class="offer">
								<h3><asp:HyperLink ID="ViewLink1" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><%# Eval("ArticleNameRu")%></asp:HyperLink></h3>
								<div>
									<asp:HyperLink ID="ViewLink2" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' /></asp:HyperLink>
								</div>
								<div>
									<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
									<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
									<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
								</div>
								<asp:HyperLink ID="ViewLink3" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
								<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
				<div>
					<asp:Repeater ID="Repeater2" runat="server" DataSourceID="UpsellOffersSource">
						<ItemTemplate>
							<div class="offer">
								<h3><asp:HyperLink ID="ViewLink4" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><%# Eval("ArticleNameRu")%></asp:HyperLink></h3>
								<div>
									<asp:HyperLink ID="ViewLink5" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' /></asp:HyperLink>
								</div>
								<div>
									<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
									<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
									<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
								</div>
								<asp:HyperLink ID="ViewLink6" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
								<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
				<div>
					<asp:Repeater ID="Repeater3" runat="server" DataSourceID="UpsellOffersSource">
						<ItemTemplate>
							<div class="offer">
								<h3><asp:HyperLink ID="ViewLink7" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><%# Eval("ArticleNameRu")%></asp:HyperLink></h3>
								<div>
									<asp:HyperLink ID="ViewLink8" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' /></asp:HyperLink>
								</div>
								<div>
									<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
									<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
									<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
								</div>
								<asp:HyperLink ID="ViewLink9" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
								<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
				<div>
					<asp:Repeater ID="Repeater4" runat="server" DataSourceID="UpsellOffersSource">
						<ItemTemplate>
							<div class="offer">
								<h3><asp:HyperLink ID="ViewLink10" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><%# Eval("ArticleNameRu")%></asp:HyperLink></h3>
								<div>
									<asp:HyperLink ID="ViewLink11" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' /></asp:HyperLink>
								</div>
								<div>
									<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
									<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
									<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
								</div>
								<asp:HyperLink ID="ViewLink12" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
								<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
				<div>
					<asp:Repeater ID="Repeater5" runat="server" DataSourceID="UpsellOffersSource">
						<ItemTemplate>
							<div class="offer">
								<h3><asp:HyperLink ID="ViewLink13" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><%# Eval("ArticleNameRu")%></asp:HyperLink></h3>
								<div>
									<asp:HyperLink ID="ViewLink14" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank"><asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' /></asp:HyperLink>
								</div>
								<div>
									<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
									<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
									<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
								</div>
								<asp:HyperLink ID="ViewLink15" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
								<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
							</div>
						</ItemTemplate>
					</asp:Repeater>
				</div>
			</div>
		</div>
	</body>
</html>
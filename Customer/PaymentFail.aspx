<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="PaymentFail.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - платеж не прошел</title>
    <link rel="Stylesheet" href="css/Offers.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
		<h2>Уупс! Ваш платеж не прошел.</h2>
		<p>Похоже на то, что по определенной причине ваш платеж не может быть выполнен.</p>
		<p>Если вы уверены, что все сделали правильно, пожалуйста, сообщите мне об этом: <a href="mailto:admin@ikatalog.kz">admin@ikatalog.kz</a>.</p>
		<p>А пока, ознакомьтесь, пожалуйста с нашими горячими предложениям. Вы можете прямо отсюда добавить в заказ то, что вас заинтересует, нажав на кнопку "заказать":</p>
		<asp:SqlDataSource ID="UpsellOffersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
			SelectCommand="
				select top 12
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
		<asp:Repeater ID="UpsellOffersRepeater" runat="server" DataSourceID="UpsellOffersSource">
			<ItemTemplate>
				<div class="offer">
					<h3><%# Eval("ArticleNameRu")%></h3>
					<div>
						<asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' />
					</div>
					<div>
						<asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
						<p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
						<b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
					</div>
					<asp:HyperLink ID="ViewLink" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
					<asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
				</div>
			</ItemTemplate>
		</asp:Repeater>
</asp:Content>


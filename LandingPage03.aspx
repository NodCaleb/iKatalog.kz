<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true" CodeFile="LandingPage03.aspx.cs" Inherits="About" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - заказ товаров по каталогам</title>
    <link rel="Stylesheet" href="css/Landing.css" />
    <link rel="Stylesheet" href="css/Offers.css" />
    <script type="text/javascript" src="js/landing.js"></script>
    <style type="text/css">
	div.catalogue
	{
		--width:703px;
		--height:65px;
		padding:0;
		margin:0;
	}
	div.catalogue > a > img
	{
		margin:5px 10px 5px 10px;
		max-height:55px;
	}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
			    'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=' + convert (nvarchar(25), UO.Catalogue_id) + '&article=' + convert(nvarchar(25), Article_id) + '&name=' + convert(nvarchar(25), ArticleNameDe) + '&price=' + replace(convert(nvarchar(25), PriceNew), '.', ',') + '&URL=' + replace (CatalogueURL, 'http://', '') as OrderURL
		    from
			    UpsellOffers as UO with (nolock)
			    join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
		    order by
			    NEWID()">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="LandingBlocksSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
	    SelectCommand="select Body from StaticPages as SP join BlocksToLandings as BTL on BTL.StaticPage_id = SP.id where BTL.Landing_id = @Landing">
	<SelectParameters>
            <asp:Parameter Name="Landing" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:Repeater ID="BlocksRepeater" runat="server" DataSourceID="LandingBlocksSource">
	<ItemTemplate>
	    <div class="background">
		<%# Eval("Body") %>
	    </div>
	</ItemTemplate>
    </asp:Repeater>
    <div class="background">
	<h2>Получите скидку в 5% на первый заказ</h2>
	<p>Для этого нужно всего-лишь зарегистрироваться на нашем сайте. Процедура регистрации очень проста — вам просто нужно сообщить нам, как вас зовут и как мы сможем с вами связаться.</p>
	<div class="validationsummary">
	    <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="RegisterValidationGroup" />
	</div>
	<div class="LPRegisterForm">
	    <asp:TextBox ID="UserFullNameTextBox" runat="server" placeholder="имя фамилия"></asp:TextBox><br/>
	    <asp:TextBox ID="EmailTextBox" runat="server" placeholder="email"></asp:TextBox><br/>
	    <asp:TextBox ID="PhoneTextBox" runat="server" placeholder="телефон"></asp:TextBox><br/>
	    <asp:Button id="RegisterButton" Text="Зарегистрироваться" OnClick="RegisterCustomer" runat="server" ValidationGroup="RegisterValidationGroup"/><br/>
	    
	    <asp:RequiredFieldValidator ID="UserFullNameRequiredValidator" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="UserFullNameTextBox"></asp:RequiredFieldValidator>
	    <asp:RequiredFieldValidator ID="EmailRequiredValidator" runat="server" ErrorMessage="Не заполнен email" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="EmailTextBox"></asp:RequiredFieldValidator>
	    <asp:RequiredFieldValidator ID="PhoneRequiredValidator" runat="server" ErrorMessage="Не заполнен телефон" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="PhoneTextBox"></asp:RequiredFieldValidator>
	    <asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="EmailTextBox" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="RegisterValidationGroup"></asp:RegularExpressionValidator>
	    <asp:CustomValidator ID="EmailUniquenessValidator" runat="server" ErrorMessage="Пользователь с таким адресом электронной почты уже существует" ControlToValidate="EmailTextBox" Display="None" ValidationGroup="RegisterValidationGroup"></asp:CustomValidator>
	</div>
	<p>Помимо <b>купона на скидку в 5%</b> на первый&nbsp;заказ (не обязательно на первый, можно &mdash;&nbsp;на второй или третий, но &mdash; в течении недели) после рагистрации вы получаете доступ к личному кабинету, где вы сможете:</p>
	<ul>
		<li>всегда быть в курсе, какой статус у Вашего заказа и когда он будет у Вас</li>
		<li>видеть историю своих покупок</li>
		<li>участвовать в наших дисконтных программах</li>
		<li>вести личный архив платежей</li>
	</ul>	
	<p>А также, при регистрации, по мере изменения статуса Вашего заказа Вы будете получать автоматические уведомления об этом на электронную почту.</p>	
	<p>Вся личная информация, которую Вы передаете нам при регистрации, останется строго конфиденциальной! Мы заботимся о Ваших интересах и безопасности.</p>
    </div>
    <div class="background">
	<h2>Вы не владеете немецким и не знаете, как и что искать?</h2>
	<p>Это не проблема. Специально для Вашего удобства мы создали <a href="http://ikatalog.kz/Infos/OrderingRules.aspx">небольшой справочник</a> с видео-примерами и видео-инструкцией по каждому каталогу, представленному на нашем сайте. Также Вы можете заглянуть в <a href="http://ikatalog.kz/StaticPages.aspx?Page=9">краткий словарик немецкого языка</a>, чтобы проверить названия цветов и предметов одежды.</p>
    </div>
    <div class="background">
	<h2>У Вас еще есть вопросы? У нас есть ответы!</h2>    
	<div class="question">
	    <div id="show1">
		<a href=# id="showcataloguesdisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	    </div>
	    <div id="hide1">
		<a href=# id="hidecataloguesdisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	    </div>
	    <h3>С какими каталогами вы работаете?</h3>
	    <div id="cataloguesdisplay">
		<div class="answer">
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_38" href="http://www.hm.com//de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_38" title="H&amp;M предлагает Вам модные и качественные вещи по доступным ценам. Широкий и разнообразный ассортимент для женщин, мужчин, молодых людей и детей." src="Images/Logos/hm_logo.png" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_60" href="https://www.otto.de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_60" title="Самый популярный каталог Otto среди людей самого разного возраста, включает в себя все самые популярные и разнообразные стили моды для женщин, мужчин, подростков и детей." src="Images/Logos/otto.png" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_15" href="http://www.bonprix.de" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_15" title="Универсальный каталог, предлагающий товары высокого качества по невысоким ценам.В этом каталоге представлена модная женская и мужская одежда, превосходное белье, недорогая обувь, товары для дома, а также замечательные наряды для детей и младенцев." src="Images/Logos/bonprix.png" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_18" href="http://www.c-and-a.com/de/de/shop/start.html" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_18" title="Уважаемые коллеги! Мы рады сообщить Вам о начале работы с новым интернет магазином С&amp;A (CA). В каталоге представлены оригинальные модели женской, мужской и детской одежды, а также аксессуаров. Условия работы: цена каталога + 25%. Без возврата" src="Images/Logos/header_canda_logo.png" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_4" href="http://www.amazon.de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_4" title="Главное достоинство, которым славится Амазон Германии, – это широчайший ассортимент самой разнообразной продукции. Жителям СНГ amazon.de известен, как правило, книгами, дисками, кассетами. Именно с такого ассортимента и начиналась деятельность компании в 1995 году. Сегодня же на amazon germany можно купить запчасти для авто- и мототехники, мобильные телефоны, игрушки и товары для дома. Одним словом, всё то, чем славится Германия, Amazon предлагает в широчайшем ассортименте. А ещё здесь есть качественная фото- и видеотехника, компьютерные игры, одежда и спортивные товары – всё высочайшего, истинно европейского качества. Именно на amazon.de Вы можете приобрести новинки из мира электроники, которые еще не начали поступать в розничную торговлю. Если повезёт найти подходящего продавца – то по весьма привлекательной цене." src="Images/Logos/amazon.jpg" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_86" href="http://www.zara.com/de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_86" title="Zara - это качественная и модная одежда, отличающаяся собственным неповторимым стилем и шармом. Многие придерживаются распространенного мнения, что в немалой степени успех Zara обусловлен тем, что большинство моделей имеют вполне уловимое сходство с сезонным pret-a-porte. Модельеры компании Zara тщательно отслеживают последние модные веяния и тенденции мира моды, и сразу же воплощают их в своих коллекциях. Поэтому в одежде Zara Вы всегда будете образцом стиля и моды." src="Images/Logos/logo_Zara.png" alt="Logo"></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_72" href="http://www.tchibo.de/?cs=1" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_72" title="TCHIBO - это магазин - клуб для ценителей качественных товаров по разумной цене, будь то посуда, одежда, товары для дома или вещи-помощники для поддержания порядка и чистоты в доме. И, конечно же, кофе! TCHIBO - это магазин, полный неожиданных сюрпризов и ощущения повседневного праздника, притягателен постоянно меняющимся ассортиментом, проводимыми акциями распродажи и свежими идеями" src="Images/Logos/tcm_logo_126.PNG" alt="Logo"></a>
		</div>
		<div class="more"><a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">Это самые популярные, а всего их около 90-ти, нажмите, чтобы открыть полный список >>></a></div>
	    </div>
	</div>
	<div class="question">
	    <div id="show2">
		<a href=# id="showpricedisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	    </div>
	    <div id="hide2">
		<a href=# id="hidepricedisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	    </div>
	    <h3>Из чего складывается окончательная цена товара?</h3>
	    <div id="pricedisplay">
		<div class="answer">
		    <table>
			<tbody>
				<tr>
				    <td style="width: 287px">
					<img src="Images/pricetag.png" alt="Pricetag"/>
				    </td>
				    <td style="width: 48px">
					<img src="Images/grayplus.png" alt="Plus"/>
				    </td>
				    <td style="width: 287px">
					<img src="Images/percent.png" alt="Percent"/>
				    </td>
				    <td style="width: 48px">
					<img src="Images/grayplus.png" alt="Plus"/>
				    </td>
				    <td style="width: 287px">
					<img src="Images/planedelivery.png" alt="Plane"/>
				    </td>
				</tr>
				<tr>
				    <td>
					Цена товара на каталоге
				    </td>
				    <td>
					
				    </td>
				    <td>
					Комиссия (индивидуальная для каждогого каталога), ее можно увидеть в <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">списке каталогов</a>
				    </td>
				    <td>
					
				    </td>
				    <td>
					Стоимость доставки до Казахстана:<br/> 5-7€/кг. + доставка по городу или в регион
				    </td>
				</tr>
			</tbody>
		    </table>
		    <p>К примеру — джинсы с каталога <a href="http://www.c-and-a.com/de/de/shop/index.html" target="_blank">C&amp;A</a> за 15€. Комиссия каталога составит 22%. Вес джинсов примерно 400 грамм. Итого джинсы вам обойдутся: 15€ + 22% + 0,4 кг.*5€ = 20,3€, что в тенге составит около 4 700 тг.</p>
		</div>
	    </div>
	</div>
	<div class="question">
	    <div id="show3">
		<a href=# id="showpaymentdisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	    </div>
	    <div id="hide3">
		<a href=# id="hidepaymentdisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	    </div>
	    <h3>Какими способами можно оплатить заказ?</h3>
	    <div id="paymentdisplay">
		<div class="answer">
		    <table>
			<tbody>
				<tr>
				    <td style="width: 287px">
					<img src="Images/paycash.png" alt="Cash"/>
				    </td>
				    <td style="width: 48px">
				    </td>
				    <td style="width: 287px">
					<img src="Images/paycard.png" alt="Card"/>
				    </td>
				    <td style="width: 48px">
				    </td>
				    <td style="width: 287px">
					<img src="Images/payqiwi.png" alt="Qiwi"/>
				    </td>
				</tr>
				<tr>
				    <td>
					Наличными
				    </td>
				    <td>
					
				    </td>
				    <td>
					Платежной картой VISA или Mastercard <a href="http://ikatalog.kz/StaticPages.aspx?Page=3" target="_blank">прямо на сайте</a>
				    </td>
				    <td>
					
				    </td>
				    <td>
					Через платежные терминалы Qiwi
				    </td>
				</tr>
			</tbody>
		    </table>
		</div>
	    </div>
	</div>
	<div class="question">
	    <div id="show4">
		<a href=# id="showorderdisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	    </div>
	    <div id="hide4">
		<a href=# id="hideorderdisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	    </div>
	    <h3>Как сделать заказ на вашем сайте?</h3>
	    <div id="orderdisplay">
		<div class="answer">
		    <table>
			<tbody>
				<tr>
				    <td style="width: 191px">
					<img src="Images/catalogues.png" alt="Выбаерите товар"/>
				    </td>
				    <td style="width: 48px">
					<img src="Images/Buttons/grayarrow.png" alt="Arrow"/>
				    </td>
				    <td style="width: 191px">
					<img src="Images/makeanorder.png" alt="Оформите заказ"/>
				    </td>
				    <td style="width: 48px">
					<img src="Images/Buttons/grayarrow.png" alt="Arrow"/>
				    </td>
				    <td style="width: 191px">
					<img src="Images/advancepayment.png" alt="Внесите предоплату"/>
				    </td>
				    <td style="width: 48px">
					<img src="Images/Buttons/grayarrow.png" alt="Arrow"/>
				    </td>
				    <td style="width: 191px">
					<img src="Images/parcel.png" alt="Получите ваш заказ"/>
				    </td>
				</tr>
				<tr>
				    <td>
					Выберите интетесующий ват товар из <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">более чем 90 каталогов</a>
				    </td>
				    <td>
					
				    </td>
				    <td>
					Оформите заказ удобным для вас способом: на сайте, по почте или телефону
				    </td>
				    <td>
					
				    </td>
				    <td>
					Внесите предоплату в размере 25% от стоимости заказа (для заказов менее 50€)
				    </td>
				    <td>
					
				    </td>
				    <td>
					Получите ваш заказ. Время доставки 2-3 недели.
				    </td>
				</tr>
			</tbody>
		    </table>
		</div>
	    </div>
	</div>
	<p><center><a class="CTA" style="top:0;" href="http://ikatalog.kz/Catalogues.aspx?Tag=active">Перейти к выбору товара >>></a></center></p>
    </div>
    <div class="background">
	<h2>Что говорят наши клиенты</h2>
	<asp:SqlDataSource ID="TestimonialsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="select Name + ' (' + City + ')' as Header, Body from Testimonials where isnull(Approved, -1) = 1 order by CreationDate desc"></asp:SqlDataSource>
	<asp:Repeater ID="TestimonialsRepeater" runat="server" DataSourceID="TestimonialsSource">
	    <ItemTemplate>
		<div class="testomonial">
		    <div>
			<h4><%# Eval("Header") %></h4>
			<asp:Label ID="TextLabel" runat="server" Text='<%# Eval("Body") %>'></asp:Label>
		    </div>
		</div>
	    </ItemTemplate>
	</asp:Repeater>
	<asp:ValidationSummary ID="SubscribeValidationGroup" runat="server" ValidationGroup="LandingValidationGroup" />
    </div>
</asp:Content>




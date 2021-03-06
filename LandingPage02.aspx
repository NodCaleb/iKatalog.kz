<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true" CodeFile="LandingPage02.aspx.cs" Inherits="About" %><asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">    <title>iKatalog - заказ товаров по каталогам</title>
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
    </style></asp:Content><asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
    </asp:SqlDataSource>    <h1>Европейский шопинг у вас дома!</h1>
    <div class="advantages">
	<ul>
	    <li>OTTO, H&amp;M, Lacoste, ZARA, Amazon - <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">более 90 каталогов из Германии</a>!
		<div class="catalogue">
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_80" href="http://www.otto.de" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_80" Title="Самый популярный каталог Otto среди людей самого разного возраста, включает в себя все самые популярные и разнообразные стили моды для женщин, мужчин, подростков и детей." src="Images/Logos/otto.png" alt="Logo" /></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_46" href="http://shop.hm.com/de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_46" Title="H&amp;M предлагает Вам модные и качественные вещи по доступным ценам. Широкий и разнообразный ассортимент для женщин, мужчин, молодых людей и детей." src="Images/Logos/hm_logo.png" alt="Logo" /></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_104" href="http://goo.gl/dA6Jm" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_104" Title="Zara - это качественная и модная одежда, отличающаяся собственным неповторимым стилем и шармом. Многие придерживаются распространенного мнения, что в немалой степени успех Zara обусловлен тем, что большинство моделей имеют вполне уловимое сходство с сезонным pret-a-porte. Модельеры компании Zara тщательно отслеживают последние модные веяния и тенденции мира моды, и сразу же воплощают их в своих коллекциях. Поэтому в одежде Zara Вы всегда будете образцом стиля и моды." src="Images/Logos/logo_Zara.png" alt="Logo" /></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_72" href="http://www.tchibo.de/?cs=1" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_72" title="TCHIBO - это магазин - клуб для ценителей качественных товаров по разумной цене, будь то посуда, одежда, товары для дома или вещи-помощники для поддержания порядка и чистоты в доме. И, конечно же, кофе! TCHIBO - это магазин, полный неожиданных сюрпризов и ощущения повседневного праздника, притягателен постоянно меняющимся ассортиментом, проводимыми акциями распродажи и свежими идеями" src="Images/Logos/tcm_logo_126.PNG" alt="Logo"></a>
		    
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_22" href="http://www.c-and-a.com/de/de/shop/start.html" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_22" Title="Уважаемые коллеги! Мы рады сообщить Вам о начале работы с новым интернет магазином С&amp;A (CA). В каталоге представлены оригинальные модели женской, мужской и детской одежды, а также аксессуаров. Условия работы: цена каталога + 20%. Без возврата" src="Images/Logos/header_canda_logo.png" alt="Logo" /></a>
		    <a id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLink_6" href="http://www.amazon.de/" target="_blank"><img id="ContentPlaceHolder1_ContentPlaceHolder1_CataloguesRepeater_CatalogueLogo_6" Title="Главное достоинство, которым славится Амазон Германии, – это широчайший ассортимент самой разнообразной продукции. Жителям СНГ amazon.de известен, как правило, книгами, дисками, кассетами. Именно с такого ассортимента и начиналась деятельность компании в 1995 году. Сегодня же на amazon germany можно купить запчасти для авто- и мототехники, мобильные телефоны, игрушки и товары для дома. Одним словом, всё то, чем славится Германия, Amazon предлагает в широчайшем ассортименте. А ещё здесь есть качественная фото- и видеотехника, компьютерные игры, одежда и спортивные товары – всё высочайшего, истинно европейского качества. Именно на amazon.de Вы можете приобрести новинки из мира электроники, которые еще не начали поступать в розничную торговлю. Если повезёт найти подходящего продавца – то по весьма привлекательной цене." src="Images/Logos/amazon.jpg" alt="Logo" /></a>
		</div>
	    </li>
	    <li>Компания Ikatalog (Айкаталог), предлагает сервис по заказу женской, мужской, детской одежды, обуви и других товаров из Европы. Быстрая и недорогая доставка на дом, в любой город - Актау, Атырау, Астану, Алматы и по всем городам Казахстана, безопасно и быстро!</li>
	    <li>Ваши заказы не облагаются налогами и пошлинами, так как приобретаются для личного пользования, поэтому цена будет существенно ниже цен в розницу, до 50%!&nbsp;Мы служим гарантом выполнения заказов получая от вас лишь частичную предоплату, поэтому заказывать через сервис Ikatalog (Айкаталог) абсолютно надежно и безопасно.</li>
	    <li>Удобные способы <a href="http://ikatalog.kz/StaticPages.aspx?Page=14" target="_blank">оплаты</a> и <a href="http://ikatalog.kz/StaticPages.aspx?Page=15" target="_blank">доставки</a></li>
	    <li>Простая <a href="http://ikatalog.kz/StaticPages.aspx?Page=1" target="_blank">процедура оформления заказа</a></li>
	    <li><a href="http://ikatalog.kz/StaticPages.aspx?Page=16" target="_blank">Возврат товара</a> 365 дней!</li>
	</ul>
    </div>
    <p><center><a class="CTA" style="top:0;" href="http://ikatalog.kz/Customer/Register.aspx">Регистрируйтесь на нашем портале >></a></center></p>
    <div class="question">
	<div id="show0">
	    <a href=# id="showregdisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	</div>
	<div id="hide0">
	    <a href=# id="hideregdisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	</div>
	<h3>Для чего мне регистрироваться на вашем сайте?</h3>
	<div id="regdisplay">
	    <div class="answer">
		<p>Вы сможете в любой момент проверить статус ваших заказов и понимать их местонахождение в личном кабинете</p>
		<p>По мере изменения статуса вы будете получать автоматические уведомления об этом на электронную почту</p>
	    </div>
	</div>
    </div>
    <h2>Что-то ищете? Мы вам поможем!</h2>
    <div class="request">
	<asp:UpdatePanel ID="RequestUpdatePanel" runat="server" UpdateMode="Conditional">
	    <ContentTemplate>
		<asp:MultiView ID="RequestMultiView" ActiveViewIndex="0" runat="server">
                    <asp:View ID="Ask" runat="server">
			<table class="requestform">
			    <tbody>
				    <tr>
					    <td colspan="3">
						<asp:TextBox ID="SearchInput" runat="server" TextMode="multiline" placeholder="Напишите, что вы ищете, к примеру — куртку, сумку или косметику. Мы можем привезти все! Укажите также предпочтения по бренду, размеру или цвету, если есть."></asp:TextBox>
					    </td>
				    </tr>
				    <tr>
					    <td>
						<asp:TextBox ID="NameInput" runat="server" placeholder="Введите ваше имя"></asp:TextBox>
					    </td>
					    <td>
						<asp:TextBox ID="EmailInput" runat="server" placeholder="ваш email"></asp:TextBox>
					    </td>
					    <td>
						<asp:TextBox ID="PhoneInput" runat="server" placeholder="и телефон"></asp:TextBox>
					    </td>
				    </tr>
				    <tr>
					    <td colspan="2">
						Нажмите кнопку "отправить запрос" и мы вышлем вам варианты для выбора <br/>
						Помните, что отправка запроса вас ни к чему не обязывает!
					    </td>
					    <td>
						<asp:Button ID="AskMeButton" runat="server" Text="Отправить запрос" OnClick="AskMeButton_Click" ValidationGroup="LandingValidationGroup" />
					    </td>
				    </tr>
			    </tbody>
			</table>
			<asp:RequiredFieldValidator ID="NameInputRrequiredValidator" runat="server" ControlToValidate="NameInput" ErrorMessage="Не указано имя." ValidationGroup="LandingValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			<asp:RequiredFieldValidator ID="EmailInputRrequiredValidator" runat="server" ControlToValidate="EmailInput" ErrorMessage="Не указан Email." ValidationGroup="LandingValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			<asp:RequiredFieldValidator ID="PhoneInputRrequiredValidator" runat="server" ControlToValidate="PhoneInput" ErrorMessage="Не указан телефон." ValidationGroup="LandingValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			<asp:RequiredFieldValidator ID="SearchInputRrequiredValidator" runat="server" ControlToValidate="SearchInput" ErrorMessage="Не указан запрос." ValidationGroup="LandingValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Не более 500 символов, пожалуйста." Display="None" ValidationExpression=".{0,500}" ValidationGroup="LandingValidationGroup" ControlToValidate="SearchInput">*</asp:RegularExpressionValidator>
			<asp:ValidationSummary ID="AskMeValidationSummary" runat="server" ValidationGroup="LandingValidationGroup" />
		    </asp:View>
		    <asp:View ID="Answer" runat="server">
			<div class="confirm">
			    <p>Благодарим, ваш запрос принят. Наш менеджер свяжется с вами в ближайшее время.</p>
			</div>
		    </asp:View>
                </asp:MultiView>
	    </ContentTemplate>
	</asp:UpdatePanel>
    </div>
    <h2>Есть вопросы? Мы подскажем!</h2>    
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
    <div class="question">
	<div id="show5">
	    <a href=# id="showofferdisplay"><img src="Images/Buttons/plus28.png" alt="показать"/></a>
	</div>
	<div id="hide5">
	    <a href=# id="hideofferdisplay"><img src="Images/Buttons/minus28.png" alt="скрыть"/></a>
	</div>
	<h3>Какие есть акции, скидки и спец-предложения?</h3>
	<div id="offerdisplay">
	    <div class="answer">
		<asp:Repeater ID="OffersRepeater" runat="server" DataSourceID="UpsellOffersSource">
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
		<asp:UpdatePanel ID="SubscribeUpdatePanel" runat="server" UpdateMode="Conditional">
		    <ContentTemplate>
			<asp:MultiView ID="SubscribeMultiView" ActiveViewIndex="0" runat="server">
			    <asp:View ID="Enter" runat="server">
				<h3>Наши спец-предложения постоянно обновляются, оставьте свои контактные данные и мы сообщим, когда появится что-то новое и интересное</h3>
				<asp:TextBox ID="SubscribeNameInput" runat="server" placeholder="Введите ваше имя"></asp:TextBox>
				<asp:TextBox ID="SubscribeEmailInput" runat="server" placeholder="и ваш email"></asp:TextBox>
				<asp:Button ID="SubscribeButton" runat="server" Text="Подтвердить" OnClick="SubscribeButton_Click" ValidationGroup="SubscribeValidationGroup" />
			    </asp:View>
			    <asp:View ID="Thanks" runat="server">
				<div class="confirm">
				    <p>Премного благодарны!</p>
				</div>
			    </asp:View>
			</asp:MultiView>
		    </ContentTemplate>
		</asp:UpdatePanel>
		<asp:RequiredFieldValidator ID="SubscribeNameInputRrequiredValidator" runat="server" ControlToValidate="SubscribeNameInput" ErrorMessage="Не указано имя." ValidationGroup="SubscribeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
		<asp:RequiredFieldValidator ID="SubscribeEmailInputRrequiredValidator" runat="server" ControlToValidate="SubscribeEmailInput" ErrorMessage="Не указан Email." ValidationGroup="SubscribeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
		
	    </div>	    
	</div>
    </div>
    <p><center><a class="CTA" style="top:0;" href="http://ikatalog.kz/Customer/Register.aspx">Регистрируйтесь на нашем портале >></a></center></p>
    <asp:ValidationSummary ID="SubscribeValidationGroup" runat="server" ValidationGroup="LandingValidationGroup" />
</asp:Content>


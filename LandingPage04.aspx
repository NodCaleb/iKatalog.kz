<%@ Page Title="" Language="C#" MasterPageFile="~/iKLandingPage.master" AutoEventWireup="true" CodeFile="LandingPage04.aspx.cs" Inherits="About" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - заказ товаров по каталогам</title>
    <link rel="Stylesheet" href="css/Landing.css" />
    <link rel="Stylesheet" href="css/Offers.css" />
    <script type="text/javascript" src="js/landing.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="validationsummary">
	    <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="RegisterValidationGroup" />
	</div>
    </div>
    <div class="bannerblock">
	<div class="title_mid">Покупайте в популярных интернет-магазинах Германии,</div>
	<div class="title_big">Используя бесплатный склад в Ганновере для пересылки в Казахстан</div>
	<div class="title_small" style="margin-bottom: 16px;"><img src="http://ru.litemf.com/img/benefit_bg.png" style="position: relative; top: 14px;"/>Безналоговый сервис<img src="http://ru.litemf.com/img/benefit_bg.png" style="position: relative; top: 14px; margin-left: 30px;"/>Выгодная экспресс-доставка<img src="http://ru.litemf.com/img/benefit_bg.png" style="position: relative; top: 14px; margin-left: 30px;"/>Без скрытых платежей</div>
	<table border="0" cellpadding="0" cellspacing="0" style="width: 800px; margin: auto">
	<tbody>
		<tr>
		    <td>
			<table border="0" cellpadding="0" cellspacing="0">
			    <tbody>
				<tr>
				    <td class="regCTA">Получите скидку 5 %<br/> на первый заказ</td>
				    <td class="regCTA"><img src="http://www.clker.com/cliparts/9/N/a/Q/C/n/white-arrow-right-md.png" /></td>
				</tr>
			    </tbody>
			</table>
		    </td>
		    <td>	
			<div class="LPRegisterForm2">
			    <asp:TextBox ID="UserFullNameTextBox" runat="server" placeholder="имя фамилия"></asp:TextBox><br/>
			    <asp:TextBox ID="EmailTextBox" runat="server" placeholder="email"></asp:TextBox><br/>
			    <asp:TextBox ID="PhoneTextBox" runat="server" placeholder="телефон"></asp:TextBox><br/>
			    <asp:Button id="RegisterButton" Text="ПОЛУЧИТЬ СКИДКУ 5 %" OnClick="RegisterCustomer" runat="server" ValidationGroup="RegisterValidationGroup"/><br/>
			    
			    <asp:RequiredFieldValidator ID="UserFullNameRequiredValidator" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="UserFullNameTextBox"></asp:RequiredFieldValidator>
			    <asp:RequiredFieldValidator ID="EmailRequiredValidator" runat="server" ErrorMessage="Не заполнен email" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="EmailTextBox"></asp:RequiredFieldValidator>
			    <asp:RequiredFieldValidator ID="PhoneRequiredValidator" runat="server" ErrorMessage="Не заполнен телефон" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="PhoneTextBox"></asp:RequiredFieldValidator>
			    <asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="EmailTextBox" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="RegisterValidationGroup"></asp:RegularExpressionValidator>
			    <asp:CustomValidator ID="EmailUniquenessValidator" runat="server" ErrorMessage="Пользователь с таким адресом электронной почты уже существует" ControlToValidate="EmailTextBox" Display="None" ValidationGroup="RegisterValidationGroup"></asp:CustomValidator>
			</div>
		    </td>
		</tr>
	    </tbody>
	</table>
	<p><input type="checkbox" checked="checked" name="agree" value="1">Я принимаю <a href="http://ikatalog.kz/StaticPages.aspx?Page=2" target="_blank">условия соглашения</a> для первого заказа </p>
    </div>
    <div class="colorblock whiteblock">
	<div class="title_big title_dark" style="padding: 0px 250px 0px 250px;">Как это работает?</div>
	<table border="0" cellpadding="0" cellspacing="0" style="width: 900px; margin: auto;">
	<tbody>
		<tr>
			<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan1_1.png" /></td>
			<td><img alt="" src="images/arrow_right_grey.png" /></td>
			<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan1_2.png" /></td>
			<td><img alt="" src="images/arrow_right_grey.png" /></td>
			<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan1_3.png" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td style="width: 300px; vertical-align: top;">Вы делаете лишь <a href="http://ikatalog.kz/StaticPages.aspx?Page=14" target="_blank">частичную предоплату</a> за выбранный товар удобным для вас способом, а наши менеджеры оплачивают ваши заказы в интернет <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">магазинах Германии</a>. Мы не взимаем скрытых платежей или комиссий, а <a href="http://ikatalog.kz/StaticPages.aspx?Page=14" target="_blank">наши тарифы</a> указаны в разделе с каталогами магазинов и в форме заказа.</td>
			<td>&nbsp;</td>
			<td style="width: 300px; vertical-align: top;">Мы получаем ваши покупки на наш склад в Германии (в течении 3 - 4 дней после оплаты), далее консолидируем их и формируем отправку посылки в Алматы (срок доставки около 7 дней).</td>
			<td>&nbsp;</td>
			<td style="width: 300px; vertical-align: top;">По получении взвешиваем ваши покупки, сообщаем вам остаток к оплате за товар и <a href="http://ikatalog.kz/StaticPages.aspx?Page=15" target="_blank">сумму за доставку</a>. Вы завершаете оплату и забираете бесплатно заказ с нашего склада в Алматы, либо выбираете доставку на дом в любой город Казахстана курьерской службой. После получения покупки у вас есть возможность <a href="http://ikatalog.kz/Testimonials.aspx" target="_blank">оставить отзыв</a>. Мы стремимся сделать наш сервис удобным и выгодным, поэтому нам важно ваше мнение.</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td style="height: 35px; background-color: #ED9E7C; font-weight: bold; border-radius: 5px;"><a href="http://ikatalog.kz/Infos/OrderingRules.aspx" target="_blank">Узнать подробнее</a></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
    </div>
    <div class="colorblock">
	<table border="0" cellpadding="0" cellspacing="0" style="width: 800px; margin: auto">
	<tbody>
		<tr>
		    <td>
			<table border="0" cellpadding="0" cellspacing="0">
			    <tbody>
				<tr>
				    <td class="regCTA">Получите скидку 5 %<br/> на первый заказ</td>
				    <td class="regCTA"><img src="http://www.clker.com/cliparts/9/N/a/Q/C/n/white-arrow-right-md.png" /></td>
				</tr>
			    </tbody>
			</table>
		    </td>
		    <td>
			<div class="validationsummary">
			    <asp:ValidationSummary ID="OrderPositionValidationSummary2" runat="server" ValidationGroup="RegisterValidationGroup2" />
			</div>
			<div class="LPRegisterForm2">
			    <asp:TextBox ID="UserFullNameTextBox2" runat="server" placeholder="имя фамилия"></asp:TextBox><br/>
			    <asp:TextBox ID="EmailTextBox2" runat="server" placeholder="email"></asp:TextBox><br/>
			    <asp:TextBox ID="PhoneTextBox2" runat="server" placeholder="телефон"></asp:TextBox><br/>
			    <asp:Button id="RegisterButton2" Text="ПОЛУЧИТЬ СКИДКУ 5 %" OnClick="RegisterCustomer2" runat="server" ValidationGroup="RegisterValidationGroup2"/><br/>
			    
			    <asp:RequiredFieldValidator ID="UserFullNameRequiredValidator2" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="RegisterValidationGroup2" ControlToValidate="UserFullNameTextBox2"></asp:RequiredFieldValidator>
			    <asp:RequiredFieldValidator ID="EmailRequiredValidator2" runat="server" ErrorMessage="Не заполнен email" Display="None" ValidationGroup="RegisterValidationGroup2" ControlToValidate="EmailTextBox2"></asp:RequiredFieldValidator>
			    <asp:RequiredFieldValidator ID="PhoneRequiredValidator2" runat="server" ErrorMessage="Не заполнен телефон" Display="None" ValidationGroup="RegisterValidationGroup2" ControlToValidate="PhoneTextBox2"></asp:RequiredFieldValidator>
			    <asp:RegularExpressionValidator ID="EmailRegularExpressionValidator2" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="EmailTextBox2" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="RegisterValidationGroup2"></asp:RegularExpressionValidator>
			    <asp:CustomValidator ID="EmailUniquenessValidator2" runat="server" ErrorMessage="Пользователь с таким адресом электронной почты уже существует" ControlToValidate="EmailTextBox2" Display="None" ValidationGroup="RegisterValidationGroup2"></asp:CustomValidator>
			</div>
		    </td>
		</tr>
	    </tbody>
	</table>
	<p><input type="checkbox" checked="checked" name="agree" value="1">Я принимаю <a href="http://ikatalog.kz/StaticPages.aspx?Page=2" target="_blank">условия соглашения</a> для первого заказа </p>
	<div class="title_mid" style="padding: 0px 250px 0px 250px; margin-top: 20px;">Помимо купона на скидку в 5% на первый заказ вы получаете доступ к личному кабинету, где сможете:</div>
	<div class="list">
		<ul> 
		    <li>
			    <span>Всегда быть в курсе, какой статус у Вашего заказа</span>
		    </li>
		    <li>
			    <span>Получать уведомления при изменении статуса</span>
		    </li>
		    <li>
			    <span>Видеть историю своих покупок</span>
		    </li>
		    <li>
			    <span>Участвовать в наших дисконтных программах</span>
		    </li>
		    <li>
			    <span>Вести личный архив платежей</span>
		    </li>
		</ul>
	</div>
	<div class="title_mid" style="padding: 0px 250px 0px 250px;">Лучшие товары из Германии прямо к Вашему порогу</div>
	<div class="title_small" style="padding: 0px 150px 0px 150px;">Вы любите носить качественную одежду известных брендов и модные аксессуары? Вы цените уют и комфорт в доме? Но Вам не с руки ездить в Европу за каждым предметом? Ikatalog (Айкаталог) предлагает услуги по доставке косметики, женской, мужской, детской одежды, обуви и других товаров из лучших магазинов Германии. Быстрая и недорогая доставка на дом, в любой город – Алматы, Астану, Актау, Атырау и по всему Казахстану!</div>
    </div>
    
	<div class="colorblock yellowblock">
		<div class="title_big title_dark" style="padding: 0px 250px 0px 250px;">Чем мы лучше остальных?</div>
		<table border="0" cellpadding="0" cellspacing="0" style="margin: auto;">
		<tbody>
			<tr>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_1.png" /></td>
				<td style="width: 30px;"></td>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_2.png" /></td>
				<td style="width: 30px;"></td>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_3.png" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td style="width: 300px; vertical-align: top;"><b>Выгодные условия</b><br/>Ваши заказы не облагаются налогами и пошлинами, так как приобретаются для личного пользования, поэтому цена будет существенно ниже цен в розницу, до 50%!  Мы не требуем 100 % предоплаты для запуска заказа в работу!</td>
				<td>&nbsp;</td>
				<td style="width: 300px; vertical-align: top;"><b>Удобные варианты оплаты</b><br/>на ваш выбор: банковской картой, банковским переводом, наличными и через терминалы Qiwi!</td>
				<td>&nbsp;</td>
				<td style="width: 300px; vertical-align: top;"><b>Наши услуги по обработке посылок бесплатны</b><br/>Мы не взимаем скрытых комиссий за упаковку, комплектацию, хранение и консолидацию посылок. </td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_4.png" /></td>
				<td style="width: 30px;"></td>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_5.png" /></td>
				<td style="width: 30px;"></td>
				<td style="width: 300px; vertical-align: top;"><img alt="" src="images/Lan2_6.png" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td style="width: 300px; vertical-align: top;"><b>Быстрая доставка</b><br/>Экспресс-доставка от  14 дней по выгодным тарифам!</td>
				<td>&nbsp;</td>
				<td style="width: 300px; vertical-align: top;"><b>Защита посылок</b><br/>Если с вашим заказом что-то случится в дороге, мы возместим стоимость посылки!</td>
				<td>&nbsp;</td>
				<td style="width: 300px; vertical-align: top;"><b>Лёгкие и безопасные покупки в Германии</b><br/>Просто оформите заказ на нашем сайте лишь с небольшой предоплатой и ожидайте прихода заказа в Казахстан!</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3" style="height: 35px; background-color: #ED9E7C; font-weight: bold; border-radius: 5px;"><a href="http://ikatalog.kz/Infos/OrderingRules.aspx" target="_blank">Узнать подробнее</a></td>
				<td>&nbsp;</td>
			</tr>
		</tbody>
	</table>
	</div>
	<div class="colorblock whiteblock">
		<div class="title_big title_dark" style="padding: 0px 250px 0px 250px;">Делайте заказы на популярных интернет магазинах Германии!</div>

<table border="0" cellpadding="0" cellspacing="0" class="cats">
	<tbody>
		<tr>
			<td><a href="http://www.amazon.de/" target="_blank"><img src="Images/Logos/amazon.jpg" /></a></td>
			<td><a href="http://www.ebay.de/" target="_blank"><img src="Images/Logos/ebay.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=OTTO" target="_blank"><img src="Images/Logos/otto.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=HM" target="_blank"><img src="Images/Logos/hm_logo.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=NEXT" target="_blank"><img src="Images/Logos/next.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=KIK24" target="_blank"><img src="Images/Logos/kik_logo.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=ZARA" target="_blank"><img src="Images/Logos/logo_Zara.png" /></a></td>
			<td><a href="http://ikatalog.kz/CatalogueView.aspx?Catalogue=MANGO" target="_blank"><img src="Images/Logos/mango.png" /></a></td>
			<td><a href="http://goo.gl/YLVuJ" target="_blank"><img src="Images/Logos/stradivarius.png" /></a></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="3" style="height: 35px; background-color: #ED9E7C; font-weight: bold; border-radius: 5px;"><a href="http://ikatalog.kz/Catalogues.aspx?Tag=active" target="_blank">КАТАЛОГ ИНТЕРНЕТ-МАГАЗИНОВ!</a></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>

<div class="colorblock lightgreenblock">
    <div class="title_big title_dark" style="padding: 0px 250px 0px 250px;">Что говорят наши клиенты?</div>
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
</div>
    
</asp:Content>




<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true" CodeFile="Catalogues.aspx.cs" Inherits="Catalogues" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <%--<title>Ktrade - каталоги товаров</title>--%>
    <link rel="Stylesheet" href="css/OnlineCatalogues.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="leftbar">
	<div class="categoryBlock">
	    <h3>Категории</h3>
	    <asp:LinkButton ID="alleButton" runat="server" Text="Все" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="premiumButton" runat="server" Text="Премиум" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="economyButton" runat="server" Text="Эконом" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="menButton" runat="server" Text="Мужчинам" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="frauButton" runat="server" Text="Женщинам" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="childrenButton" runat="server" Text="Детям" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="shoesButton" runat="server" Text="Обувь" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="homeButton" runat="server" Text="Дом" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="sportButton" runat="server" Text="Спорт" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="makeupButton" runat="server" Text="Косметика и парфюм" OnClick="ChangeCategoryButton_Click" />
	    <asp:LinkButton ID="jemsButton" runat="server" Text="Ювелирые украшения" OnClick="ChangeCategoryButton_Click" />
	</div>
	<div class="categoryBlock">
	    <p>Рабочий курс: <asp:Label ID="XrateLabel" runat="server" Text=""></asp:Label> &#8376;</p>
	</div>
    </div>
    <div class="listBlock">
        <asp:SqlDataSource ID="CataloguesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
            SelectCommand="select * from CataloguesView where Tags like '%' + @Tag + '%' order by SortOrder, CatalogueName">
            <SelectParameters>
                <asp:Parameter Name="Tag" DefaultValue="Active" />
            </SelectParameters>
        </asp:SqlDataSource>
    	<h3>Каталоги<asp:Label ID="TagLabel" runat="server" Text=""></asp:Label></h3>
        <p><span style="color:#B22222;">Внимание</span>: нажимая на логотип, вы переходите на сайт каталога на немецком языке.<br />Вверху сайта будет шапка, в которой вы можете посмотреть условия и правила заказа и оформить заказ.<br />Для более комфортного поиска нужного товара вы можете воспользоваться <a href="https://translate.google.com/" target="_blank">Переводчиком Google</a>.</p>
        <table border="0" cellpadding="0" cellspacing="0">
            <tbody>
		<tr style="height: 20px;">
		    <td colspan=2 style="text-align: center; font-weight: bold">Название</td>
		    <td style="text-align: center; font-weight: bold">Описание</td>
		    <td style="text-align: center; font-weight: bold">Наценка</td>
		    <td></td>
		</tr>
                <asp:UpdatePanel ID="ListUpdatePanel" runat="server" UpdateMode="Conditional">
		    <ContentTemplate>
                        <asp:Repeater ID="CataloguesRepeater" runat="server" DataSourceID="CataloguesSource">
                            <ItemTemplate>
                                <tr>
                                    <td width='106px'><asp:HyperLink ID="CatalogueLink1" runat="server" Text='' NavigateUrl='<%# Eval("FrameViewNameUrl") %>' Target='<%# Eval("Target") %>'><asp:Image ID="CatalogueLogo" runat="server" ImageUrl='<%# Eval("ImageLink") %>' AlternateText="Logo" /></asp:HyperLink></td>
                                    <td width='114px'>
					<asp:HyperLink ID="CatalogueLink2" runat="server" Text='<%# Eval("CatalogueName") %>' NavigateUrl='<%# Eval("FrameViewNameUrl") %>' Target='<%# Eval("Target") %>' />
				    </td>
                                    <td colspan="1" rowspan="2"><asp:Label ID="DescriptionLabel" runat="server" style="font-size: smaller; line-height: normal;" Text='<%# Eval("DescriptionWithNoFrames") %>'/></td>
                                    <td width='110px' style="text-align: center" colspan="1"><asp:Label ID="IndexLabel" style="font-size: large" runat="server" Text='<%# Eval("PriceIndex") %>'/><br/><asp:Label ID="NoReturnLabel" style="font-size: smaller" runat="server" Text='<%# Eval("ShortNoReturnTitle") %>'/></td>
				    <td colspan="1"><asp:HyperLink ID="NewTabCatalogueLink" runat="server" Text='' NavigateUrl='<%# Eval("Link") %>' Target='_blank'><asp:Image ID="LinkLogo" runat="server" ImageUrl='~/Images/ext_link.png' AlternateText="Logo" /></asp:HyperLink></td>
                                </tr>
				<tr  style="height:30px;">
				    <td colspan="2" rowspan="1" style="border-top: 0;"><asp:HyperLink ID="CatalogueLink3" runat="server" Text="Перейти к выбору товара>>>" NavigateUrl='<%# Eval("FrameViewNameUrl") %>' Target='<%# Eval("Target") %>' class="catCTA" style="color:#CB0000;" /></td>
				    <td colspan="2" rowspan="1" style="text-align: center; border-top: 0;" ><asp:HyperLink ID="HelpLink" runat="server" Text="Как заказать?" NavigateUrl='<%# Eval("HelpURL") %>' Target="_blank" style="color:#CB0000;" class="catCTA"/></td>
				</tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ContentTemplate>
		</asp:UpdatePanel>
            </tbody>
        </table>
    </div>
    <asp:MultiView id="CategoryTextSelector" ActiveViewIndex="0" runat="Server">
	<asp:View id="ActiveView" runat="Server">
	    <p>Вас интересует стильная и качественная одежда для женщин, мужчин и детей? Вы ищите красивые и надежные вещи (мебель, текстиль, посуда) для дома? Тогда Вы можете с легкостью найти все это на нашем сайте.</p>
            <p>Вам достаточно просто выбрать товар в одном из более 90 каталогов Германии (ОТТО, H&amp;M, Amazon.de, ZARA и многие другие).</p>
            <p>Зачем заказывать товар по каталогу из Германии?</p>
            <p><strong>Во-первых, это экономит время</strong>. Вы можете легко просматривать большое количество товара и выбрать именно то, что нужно, без длительных поездок в транспорте до магазина, без толп и очередей, просто из дома.</p>
            <p><strong>Во-вторых, это экономит деньги</strong>. Качественная одежда, посуда или домашний текстиль в обычном магазине стоит намного дороже, чем на нашем сайте. Ведь его цена включает налоги и таможенные сборы продавца. У нас Вы можете купить товар дешевле до 50%!</p>
            <p><strong>В-третьих, Вы получите высококлассное обслуживание</strong>. Мы с уважением и заботой относимся к нашим клиентам. Каждый заказ сопровождается от момента получения до доставки товара (почтой или курьером) к Вам домой. Кроме того, у нас есть система обмена и возврата вещей, которые по какой-либо причине не подошли.</p>
            <p><strong>И, конечно же, все товары из каталогов Германии &ndash; это стильные, качественные, модные вещи,</strong> которые будут дарить Вам радость и ощущение комфорта каждый день!</p>
	</asp:View>
	<asp:View id="MenView" runat="Server">
	    <p>Если Вам интересен модная и качественная одежда или обувь для мужчин, а также аксессуары и другой товар, тогда это можно найти в данном разделе.</p>
	    <p>Множество знаменитых брендов: KENZO, CHRISTIAN DIOR, EMPORIO ARMANI, ZARA, MANGO, H&amp;M и многие другие.</p>
	    <p>В чем преимущество заказа одежды для мужчин из Германии?</p>
	    <p>Во-первых, Вы тратите куда меньше времени, чем при покупке товаров в обычных магазинах.</p>
	    <p>Во- вторых, Вы экономите свои деньги. Пользуясь нашим сервисом, Вы как частное лицо экономите на оплате пошлин и налогов.</p>
	    <p>Поэтому цена товара получается ниже до 50%</p>
	    <p>В-третьих, все заказанные Вами товары для мужчин: одежда, обувь, пояса, очки и другие аксессуары - из каталогов Германии отличается особым качеством.</p>
	    <p> Если Вы выбрали нужный товар, то Вам следует обратить внимание на правила оформления заказов с выбранного Вами каталога, а также почитать немного полезной информации: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="FrauView" runat="Server">
	    <p>Женщинам во все времена хочется выглядеть привлекательно и стильно. Всё, что необходимо Вам для того, чтобы всегда оставаться неотразимой, находится в одном из этих 80 каталогов! Большое количество популярных брендов для женщин: ORSAY, H&amp;M, ZARA, MANGO, MARC O'POLO, TOM TAILOR и многие другие.</p>
	    <p>Почему лучше заказывать одежду, обувь или сумки из каталогов Германии? </p>
	    <p>Первая причина - экономия времени. Вы потратите намного меньше времени, чем будете ходить и смотреть товар в магазинах.</p>
	    <p>Вторая - экономия денег. Пользуясь нашей услугой, Вы сэкономите на оплате пошлин и налогов. В связи с этим, цена товара получается ниже до 50%.</p>
	    <p>Третья - качество товара. При заказе товара из каталогов Германии Вы можете быть уверенны в его высоком качестве.</p>
	    <p>Для комфортного выбора и заказа товара обратите внимание на правила оформления заказов в каталогах.</p>
	    <p>Немного полезной информации: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="ChildrenView" runat="Server">
	    <p>Если Вы хотите, чтобы Ваш сыночек или дочка были стильными, играли в самые лучшие куклы или машинки, катались на самых лучших велосипедах или самокатах, то Вы с легкостью сможете найти это в каталогах, представленных в этом разделе!</p>
	    <p>Вы сомневаетесь, стоит ли заказывать детскую одежду и игрушки в Германии?</p>
	    <p>Определенно, стоит.</p>
	    <p>Во-первых, Вы сэкономите свое драгоценное время, которое Вы можете провести с детьми. Заказывать товар, просматривая каталоги, намного удобнее и быстрее, чем ходить по магазинам.</p>
	    <p>Во-вторых, Вы потратите значительно меньше, получив больше. Цена товара, заказанного через наш сервис, получается ниже до 50%, чем аналогичный товар в магазинах.</p>
	    <p>В-третьих, мы уверенны в качестве товара из Германии. А значит, Вы приобретаете только проверенные и качественные вещи.</p>
	    <p>Вам стоит обратить внимание на правила оформления заказов в предложенных каталогах. Также, немного полезной информации: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="ShoeView" runat="Server">
	    <p>Вам нужны туфли или босоножки ко дню рождения или на какое-то мероприятие? Тогда обувь на любой случай жизни Вы можете найти в каталогах данного раздела.</p>
	    <p>Вы не уверены удобно ли заказывать обувь через каталог?</p>
	    <p>Не только удобно, но и выгодно.</p>
	    <p>Во-первых, это сэкономит Ваше время. Заказывая обувь по каталогам, Вы тратите куда меньше времени, чем когда покупаете обувь в магазинах.</p>
	    <p>Во-вторых, это сэкономит Ваши деньги. Пользуясь нашей услугой, цена Вашей обуви будет ниже до 50%.</p>
	    <p>В-третьих, качество Вашего товара будет радовать Вас каждый день!</p>
	    <p>Выбрав определенный товар, обратите внимание на правила оформления заказа. Также Вам стоит прочесть полезную информацию: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
        <asp:View id="HomeView" runat="Server">
	    <p>Вы только что сделали ремонт и хотите украсить свой дом по последним модным критериям? Тогда все, что необходимо Вам для интерьера можно найти в предложенных каталогах.</p>
	    <p>Зачем заказывать товар для дома по каталогам Германии?</p>
	    <p>Во-первых, Вы потратите меньше времени на поиск и выбор нужного товара.</p>
	    <p>Во-вторых, Ваш кошелек скажет Вам спасибо. Используя наш сервис, цена Вашего товара будет намного ниже - до 50%.</p>
	    <p>В-третьих, признанная всем миром надежность немецких производителей гарантирует Вам качественную продукцию.</p>
	    <p>Стоит обратить внимание на правила оформления заказа в представленных каталогах. Также немного полезной информации: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="SportView" runat="Server">
	    <p>Вы ведете активный образ жизни? Тогда данный раздел каталогов предлагает огромный&nbsp;ассортимент спортивных товаров.</p>
            <p>Почему лучше заказывать по каталогам Германии?</p>
            <p>Во-первых, Вы экономите свое время, потому что его не приходится тратить на походы по&nbsp;магазинам.</p>
            <p>Во-вторых, Вы тратите меньше денег, потому что как частное лицо, Вы экономите на оплате&nbsp;налогов и пошлин. Именно по этой причине стоимость Вашего товара будет ниже на 50%.</p>
            <p>В-третьих, все спортивные товары, заказанные Вами из каталогов Германии, имеют высокое&nbsp;качество.</p>
            <p>Увидев нужный товар, обратите внимание на правила оформления заказов с выбранного Вами&nbsp;каталога. Также Вам может пригодится следующая полезная информация:&nbsp;<a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="MakeupView" runat="Server">
	    <p>Увлекаетесь ароматами? Любите выглядеть роскошно? Тогда Вы попали в нужный раздел&nbsp;каталогов &ndash; косметика и парфюмерия.</p>
            <p>Множество различных брендов: DIOR, GUCCI, ARMANI, MAC, NYX, CHRISTINA AGUILERA, L&#39;Or&eacute;al,&nbsp;Maybelline и многие другие!</p>
            <p>В чем же преимущество покупки брендовой косметики и парфюмерии по каталогам Германии?</p>
            <p>Во-первых, Вы экономите свое время, ведь, походы по магазинам всегда утомляют и отнимают уйму времени.</p>
            <p>Во-вторых, Ваш кошелек скажет огромное спасибо, потому что, пользуясь нашим сервисом, как частное лицо, Вы экономите на оплате пошлин и налогов, поэтому цена Вашего товара будет ниже на 50%.</p>
            <p>В-третьих, весь товар, который Вы заказали из каталогов Германии отличается хорошим качеством. К тому же, мы всегда тщательно проверяем товар и может гарантировать оригинальность товара. В отличие от обычных магазинов.</p>
            <p>Если Вы выбрали товар из каталога, то обратите внимание на правила оформления заказа с&nbsp;данного каталога. Также Вам стоит прочесть полезную информацию: <a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
	<asp:View id="GemsView" runat="Server">
	    <p>Если Вы ищите подарок ко дню рождения мамы или дочери, тогда изделие из чистого золота или&nbsp;серебра, украшенное драгоценными камнями, будет идеальным вариантом.</p>
            <p>Украшения от различных брендов: H&amp;M, ZARA, SWAROVSKI, ORSAY, AMAZON, TCHIBO,ALBA MODA, PANDORA и т.д.</p>
            <p>В чем преимущества заказов ювелирных изделий по каталогам Германии?</p>
            <p>Во-первых, Вам не понадобится тратить на это много времени. Вы можете в спокойной&nbsp;обстановке, в удобное Вам время выбрать именно то украшение, которое вызовет радость и&nbsp;восторг у будущей хозяйки. Никаких уговоров продавцов или импульсивных покупок в толчее и&nbsp;суматохе магазина.</p>
            <p>Во-вторых, Вы экономите свои деньги, так как, пользуясь нашей услугой, Вы, как частное лицо&nbsp;сэкономите на оплате налогов и пошли, тем самым, стоимость товара будет ниже. Представьте -&nbsp;оригинальное брендовое украшение со скидкой до 50%, по сравнению с обычными ювелирками.</p>
            <p>В-третьих, товар, который Вы заказываете по каталогам из Европы, отличается особым качеством.</p>
            <p>Как только Вы определились с понравившимся ювелирным изделием, обратите внимание на правила оформления заказа с выбранного&nbsp;<a href="http://ikatalog.kz/StaticPages.aspx?Page=7">Примерный вес товаров</a> <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Размеры одежды</a></p>
	</asp:View>
    </asp:MultiView>
</asp:Content>

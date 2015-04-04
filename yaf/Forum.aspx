<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Forum.aspx.cs" Inherits="Forum" ValidateRequest="false" %>
<%@ Register TagPrefix="YAF" Assembly="YAF" Namespace="YAF" %>
<script runat="server">
	public void Page_Error( object sender, System.EventArgs e )
	{
		Exception x = Server.GetLastError();
		YAF.Classes.Data.DB.eventlog_create(YafServices.InitializeDb.Initialized ? (int?)YafContext.Current.PageUserID : null , this, x );
		YAF.Classes.Core.CreateMail.CreateLogEmail( x );
	}		
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="YafHead" runat="server">
<meta id="YafMetaScriptingLanguage" http-equiv="Content-Script-Type" runat="server" name="scriptlanguage" content="text/javascript" />
    <meta id="YafMetaStyles" http-equiv="Content-Style-Type" runat="server" name="styles" content="text/css" />
    <meta id="YafMetaDescription" runat="server" name="description" content="Yet Another Forum.NET -- A bulletin board system written in ASP.NET" />
    <meta id="YafMetaKeywords" runat="server" name="keywords" content="Yet Another Forum.net, Forum, ASP.NET, BB, Bulletin Board, opensource" />
    <meta charset="utf-8" />
    <%--<title>Ktrade</title>--%>
    <link rel="Stylesheet" href="../css/Master.css" />
    <link rel="Stylesheet" href="../css/Wide.css" />
    <!--link rel="stylesheet" type="../text/css" href="../css/superfish.css" media="screen"/-->
    <link rel="stylesheet" href="../css/superfish.css"/>
    <script type="text/javascript" src="../js/jquery-1.2.6.min.js"></script>
    <script type="text/javascript" src="../js/hoverIntent.js"></script>
    <script type="text/javascript" src="../js/superfish.js"></script>
    <script type="text/javascript">
        // initialise plugins
        jQuery(function () {
            jQuery('ul.sf-menu').superfish();
        });
    </script>
    <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-27249274-1']);
        _gaq.push(['_trackPageview']);
        (function () {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
    </script>
    <link rel="shortcut icon" href="../images/favicon2.ico" />
    <title></title>
</head>
<body>
    <asp:SqlDataSource ID="NewsModuleSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="SELECT top 5 [Header] FROM [News] where Published = 1 ORDER BY [CreationDate] DESC">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DiscountsModuleSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select top 5 Comment, URL from Discounts order by CreationDate desc">
    </asp:SqlDataSource>
    <form id="MasterForm" runat="server">
    <div class="layout">
        <div class="leftshadow">
            <asp:Image ID="LeftShadowImage" ImageUrl="~/images/LeftShadowTransparent.png" runat="server" />
		</div>
		<div class="rightshadow">
            <asp:Image ID="RightShadowImage" ImageUrl="~/images/RightShadowTransparent.png" runat="server" />
		</div>
        <div class="innerlayout">
            <div class="header">
                <asp:HyperLink ID="HomeLink" NavigateUrl="~" runat="server"><asp:Image ID="KtradeLogo" ImageUrl="~/images/KtradeLogo.png" runat="server" /></asp:HyperLink>                
                <%--<asp:Image ID="KtradeLogo" ImageUrl="~/images/KtradeLogoNY.png" runat="server" />--%>
                <div class="login">
                    <asp:MultiView ID="LoginMultiView" ActiveViewIndex="0" runat="server">
                        <asp:View ID="Anonimous" runat="server">
                            <asp:TextBox ID="UserNameTextBox" runat="server" placeholder="имя"></asp:TextBox>
					        <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" placeholder="пароль"></asp:TextBox>
                            <div><asp:ImageButton ID="LoginImageButton" runat="server" ImageUrl="~/Images/Unlock.png" ToolTip="Вход" onclick="LoginImageButton_Click" /></div>
					        <div title="Запомнить меня"><asp:Image ID="RememberImage" ImageUrl="~/images/Remember.png" runat="server" /><asp:CheckBox ID="RememberMe" runat="server" /></div>
					        <div><asp:HyperLink ID="RegisterLink" NavigateUrl="~/Customer/Register.aspx" runat="server"><asp:Image ID="RegisterImage" ImageUrl="~/Images/Register.png" ToolTip="Регистрация нового покупателя" runat="server" /></asp:HyperLink></div>
                        </asp:View>
                        <asp:View ID="Authorised" runat="server">
                            <div class="greetings"><asp:Label ID="UserFullNameDisplay" runat="server" Text="Юзер"></asp:Label></div>
			                <div><asp:ImageButton ID="LogoutImageButton" runat="server" ImageUrl="~/Images/Lock.png" onclick="LogoutImageButton_Click" ToolTip="Выход" /></div>
			                <div><asp:HyperLink ID="ChangePasswordLink" NavigateUrl="~/Customer/ChangePassword.aspx" runat="server"><asp:Image ID="ChangePasswordImage" ImageUrl="~/Images/Key.png" runat="server" ToolTip="Сменить пароль" /></asp:HyperLink></div>
                        </asp:View>
                    </asp:MultiView>
                </div>
                <div class="contacts">
                    <p>8 (7212) 41-90-61</p>
                    <p><asp:HyperLink ID="MailLink" runat="server" NavigateUrl="mailto:sale@ktrade.kz">sale@ktrade.kz</asp:HyperLink></p>
                    <p>Skype: ktrade.kz</p>
                    <%--<p>г. Караганда, ул. Кривогуза, 5, офис 311</p>--%>
                </div>
			</div>
            <div class="menue">
				<ul class="sf-menu">
					<li>
						<asp:HyperLink ID="DummyLink01" runat="server" NavigateUrl="#">Ktrade</asp:HyperLink>
						<ul>
							<li>
                                <asp:HyperLink ID="NewsLink" runat="server" NavigateUrl="~/News.aspx">Новости</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="DiscountsLink" runat="server" NavigateUrl="~/Discount.aspx">Скидки</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="AboutLink" runat="server" NavigateUrl="~/About.aspx">О нас</asp:HyperLink>
							</li>
                            <li>
                                <asp:HyperLink ID="ContactsLink" runat="server" NavigateUrl="~/Contacts.aspx">Контакты</asp:HyperLink>
							</li>
						</ul>
					</li>
					<li>
						<asp:HyperLink ID="DummyLink02" runat="server" NavigateUrl="#">Каталоги</asp:HyperLink>
						<ul>
							<li>
								<asp:HyperLink ID="WebCataloguesMainLink" runat="server" NavigateUrl="~/Catalogues.aspx">Электронные</asp:HyperLink>
								<ul>
									<li>
                                        <asp:HyperLink ID="WebCataloguesAllesLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=active">Все сразу</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesMenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=men">Мужская одежда</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesWomenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=frau">Женская одежда</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesChildrenLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=children">Детская одежда</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesShoesLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=shoes">Обувь</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesChubbyLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=chubby">Одежда для полных дам</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesToysLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=toys">Все для детей</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesSportLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=sport">Все для спорта</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesHomeLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=home">Все для дома и уюта</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesLederLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=leather">Кожаные изделия</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesMakeupLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=makeup">Косметика</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesBedLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=bed">Постельное белье</asp:HyperLink>
									</li>
									<li>
                                        <asp:HyperLink ID="WebCataloguesSchmuckLink" runat="server" NavigateUrl="~/Catalogues.aspx?Tag=jems">Ювелирные украшения</asp:HyperLink>
									</li>
								</ul>
							</li>
							<li>
                                <asp:HyperLink ID="EmbeddedCataloguesLink" runat="server" NavigateUrl="~/CataloguesEmbedded.aspx">Бумажные online</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="CataloguesDownloadLink" runat="server" NavigateUrl="~/CataloguesDownload.aspx">Скачать</asp:HyperLink>
							</li>
						</ul>
					</li>
										<li>
						<a href="#">Информация</a>
						<ul>
							<li>
                                <asp:HyperLink ID="WoerteBuchLink" runat="server" NavigateUrl="~/Infos/WoerteBuch.aspx">Словарик немецкого</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="GroessenLink" runat="server" NavigateUrl="~/Infos/Groessen.aspx">Размеры одежды</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="OrderMakingLink" runat="server" NavigateUrl="~/Infos/OrderMaking.aspx">Оформление заказа</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="KleidungPfledgeSymboleLink" runat="server" NavigateUrl="~/Infos/KleidungPfledgeSymbole.aspx">Символы ухода за одеждой</asp:HyperLink>
							</li>
							<li>
                                <asp:HyperLink ID="LieferungLink" runat="server" NavigateUrl="~/Infos/Lieferung.aspx">Доставка и возврат</asp:HyperLink>
							</li>
                            <li>
                                <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Infos/FigureTypes.aspx">Подбор одежды по типу фигуры</asp:HyperLink>
							</li>
						</ul>
					</li>                   
					<li>
						<a href="#">Заказ online</a>
						<ul>
							<li>
                                <asp:HyperLink ID="OrdersInfoLink" runat="server" NavigateUrl="~/Customer/OrdersInfo.aspx">Заказы в работе</asp:HyperLink>
							</li>
                            <li>
                                <asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/Customer/OrdersHistory.aspx">История заказов</asp:HyperLink>
							</li>
							<li>
                                <u><asp:HyperLink ID="NewOrderLink" runat="server" NavigateUrl="~/Customer/NewOrder.aspx">Оформить новый заказ</asp:HyperLink></u>
							</li>
						</ul>
					</li>
				</ul>
                <asp:Panel ID="ControlPanel" runat="server" Visible="False">
                <ul class="sf-menu">
					<li>
						<a href="#">Управление порталом</a>
						<ul>
							<li>
                                <asp:HyperLink ID="OrderManagementLink" runat="server" NavigateUrl="~/Admin/OrderManagement.aspx">Заказы</asp:HyperLink>
							</li>
							<li>
								<asp:HyperLink ID="CatalogueDictionaryLink" runat="server" NavigateUrl="~/Admin/CatalogueDictionary.aspx">Каталоги</asp:HyperLink>
							</li>
							<li>
								<asp:HyperLink ID="CustomerManagementLink" runat="server" NavigateUrl="~/Admin/CustomerManagement.aspx">Покупатели</asp:HyperLink>
							</li>
                            <li>
								<asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl="~/Admin/ImportData.aspx">Импорт данных</asp:HyperLink>
							</li>
                            <li>
								<asp:HyperLink ID="NewsManagementLink" runat="server" NavigateUrl="~/Admin/NewsManagement.aspx">Новости</asp:HyperLink>
							</li>
                            <li>
								<asp:HyperLink ID="DiscountManagementLink" runat="server" NavigateUrl="~/Admin/DiscountManagement.aspx">Скидки</asp:HyperLink>
							</li>
						</ul>
					</li>
                </ul>
                </asp:Panel>
			</div>
            <div class="contentlayout">
                <div class="content">
                    <YAF:Forum runat="server" ID="forum"></YAF:Forum>
                    <div style="clear:both;"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="cellar">
	</div>
    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CatalogueView.aspx.cs" Inherits="CatalogueView" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>iKatalog - заказ товаров по каталогам</title>
    <link rel="Stylesheet" href="css/FrameView.css" />
    <!--Это скрипт Google analytics-->
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
    <!-- Yandex.Metrika counter -->
    <script type="text/javascript">
    (function (d, w, c) {
	(w[c] = w[c] || []).push(function() {
	    try {
		w.yaCounter26407257 = new Ya.Metrika({id:26407257,
			webvisor:true,
			clickmap:true,
			trackLinks:true,
			accurateTrackBounce:true});
	    } catch(e) { }
	});
    
	var n = d.getElementsByTagName("script")[0],
	    s = d.createElement("script"),
	    f = function () { n.parentNode.insertBefore(s, n); };
	s.type = "text/javascript";
	s.async = true;
	s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";
    
	if (w.opera == "[object Opera]") {
	    d.addEventListener("DOMContentLoaded", f, false);
	} else { f(); }
    })(document, window, "yandex_metrika_callbacks");
    </script>
    <noscript><div><img src="//mc.yandex.ru/watch/26407257" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
    <!-- /Yandex.Metrika counter -->
    <script language="JavaScript"> 
        function resizeIFrame(id) {
            document.getElementById(id).height = "100px";
            var newheight;
            if (document.getElementById) {
                newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
            }
            document.getElementById(id).height = (newheight) + "px";
        }
    </script>
    <meta name="description" content="Мы предоставляем услуги доставки товаров по каталогам - OTTO, H&M, Lacoste, ZARA, MEXX, Amazon и других - из Германии. Вашему вниманию предлагаются более 130 европейских каталогов одежды онлайн с огромным ассортиментом товаров на любой вкус для людей разного возраста." />
    <link rel="shortcut icon" href="images/favicon.png" />
</head>
<body>    
    <form id="CatalogueViewForm" runat="server">
	<asp:ScriptManager ID="ViewScriptManager" runat="server"></asp:ScriptManager>	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
	    <tr >
		<td height="75" width="162px">
		    
		    <asp:HyperLink ID="HomeLink" NavigateUrl="~/Catalogues.aspx" runat="server"><asp:Image ID="LogoImage" runat="server" ImageUrl="~/images/BackToCatalogues3.png" AlternateText="Logo" /></asp:HyperLink>
		</td>
		<td height="75">
		    <asp:UpdatePanel ID="FormUpdatePanel" runat="server" UpdateMode="Conditional">
			<ContentTemplate>
			    <div class="validationsummary">
				<asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="OrderPositionValidationGroup" />
			    </div>
			    <asp:Label ID="TermsLabel" runat="server" Text=''></asp:Label>
			    <asp:LinkButton ID="OrderSelectButton" runat="server" CausesValidation="False" Text="Как заказать?" OnClick="ShowVideoGuide"></asp:LinkButton><br/>
			    <asp:HyperLink ID="HelpLink" runat="server" NavigateUrl='' Target="_blank">
				<asp:Image ID="HelpIcon" runat="server" ImageUrl='~/Images/help.png' AlternateText='help' Title='' />
			    </asp:HyperLink>
			    <asp:TextBox ID="Article_idInput" runat="server" placeholder="Артикул"></asp:TextBox>
			    <asp:TextBox ID="ArticleNameInput" runat="server" placeholder="Название"></asp:TextBox>
			    <asp:TextBox ID="PriceInput" runat="server" placeholder="Цена"></asp:TextBox>
			    <asp:TextBox ID="SizeInput" runat="server" placeholder="Размер"></asp:TextBox>
			    <asp:TextBox ID="ColorInput" runat="server" placeholder="Цвет"></asp:TextBox>
			    <asp:Button ID="AddItemButton" runat="server" Text="В корзину >" OnClick="AddItemButton_Click" ValidationGroup="OrderPositionValidationGroup" />
			    
			    <asp:RequiredFieldValidator ID="ArticleRequiredValidator" runat="server" ErrorMessage="Не заполнен артикул." Display="None" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RequiredFieldValidator>
			    <asp:RegularExpressionValidator ID="ArticleExpressionValidator" runat="server" ErrorMessage="Артикул должен состоять из цифр (иногда - одна буква в конце)." Display="None" ValidationExpression="[0-9]+[A-Z]?" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RegularExpressionValidator>
			    <asp:RequiredFieldValidator ID="ArticleNameRrequiredValidator" runat="server" ControlToValidate="ArticleNameInput" ErrorMessage="Не указано наименование." ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			    <asp:RequiredFieldValidator ID="PriceRequiredValidator" runat="server" ErrorMessage="Не указана цена." ControlToValidate="PriceInput" ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
			    <asp:RegularExpressionValidator ID="PriceExpressionValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Неверно указана цена (не более двух знаков после запятой, десятичный разделитель - запятая)." ValidationGroup="OrderPositionValidationGroup" ValidationExpression="\d+(\,\d{1,2})?">*</asp:RegularExpressionValidator>
			    <asp:CustomValidator ID="MinimumPriceValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Цена артикула по данному каталогу должна быть не менее 7 евро." ValidationGroup="OrderPositionValidationGroup">*</asp:CustomValidator>
			    <asp:RegularExpressionValidator ID="SizeExpressionValidator" runat="server" ErrorMessage="Размер может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="SizeInput">*</asp:RegularExpressionValidator>
			    <asp:RegularExpressionValidator ID="ColorExpressionValidator" runat="server" ErrorMessage="Цвет может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="ColorInput">*</asp:RegularExpressionValidator>
			    
			    <asp:Panel id="VideoGuidePanel" visible="false" runat="server">
				<div class="Overlay">
				    <div><iframe id="VideoFrame" runat="server" allowfullscreen="" frameborder="0" height="480" src="http://www.youtube.com/embed/LsRO7b5oNHs?rel=0&amp;controls=0&amp;showinfo=0&autoplay=1" width="640"></iframe></div>
				    <asp:ImageButton ID="CloseVideoButton" runat="server" ImageUrl="~/Images/Buttons/close.png" Title="Закрыть" onclick="CloseVideoGuide" />
				</div>
			    </asp:Panel>
			</ContentTemplate>
		    </asp:UpdatePanel>
		</td>
		<td height="75" width="170px">
		    <asp:UpdatePanel ID="BasketUpdatePanel" runat="server" UpdateMode="Conditional">
			<ContentTemplate>
			    Вещей в корзине: <asp:Label ID="ItemsCountLabel" runat="server" Text=''></asp:Label><br/>
			    На сумму: <asp:Label ID="AmmountLabel" runat="server" Text=''></asp:Label><br/>
			    <asp:Button ID="ArrangeOrderButton" runat="server" Text="Оформить заказ" OnClick="ArrangeOrderButton_Click" />
			</ContentTemplate>
		    </asp:UpdatePanel>
		</td>
		    
	    </tr>
	    <tr>
		<td colspan="3" bgcolor="#801735" height="3"></td>
	    </tr>          
	    <tr>
		<td colspan="3" height="99%" id="view">
		    <iframe id="CatalogueFrame" src="" runat="server" width="100%" height="100%" style="border:none;"></iframe>
		</td>
	    </tr>
	    <tr>
		<td colspan="3" bgcolor="#801735" height="3"></td>
	    </tr>
	</table>
	<asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="FormUpdatePanel">
	    <ProgressTemplate>
		<div class="Warning">
		    <asp:Image ID="LoadImage1" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
		</div>
	    </ProgressTemplate>
	</asp:UpdateProgress>
    </form>
</body>
</html>

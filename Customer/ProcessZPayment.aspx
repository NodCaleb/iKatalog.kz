<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProcessZPayment.aspx.cs" Inherits="rss" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Обработка платежа</title>
    <script type="text/javascript" src="../js/jquery-1.7.js"></script>
    <script type="text/javascript">
    	$(document).ready(function(){
    		//var elem = document.getElementsByName('LMI_PAYMENT_NO')[0];
			//elem.setAttribute('value', '0293412348');
			//document.getElementsByName('LMI_PAYMENT_NO')[0].value = '0293412348';
			document.forms["pay_zpayment"].submit();
		});
    </script>
	<style type="text/css">
		div {margin:0 auto; text-align:center; width:700px; padding-top:100px;}
		img {--display:block;}
		p {color:#16509d; font-size:large; font-weight:bold; font-family:Verdana, Arial, Sans-Serif;}
	</style>
</head>
<body>
	<div>
		<img src="../images/iKatalog-logo2.png" alt="" /><br />
		<!-- img src="../Images/LoadingProgressCircle.gif" alt="" / -->
		<p>Отправляем данные.</p>
	</div>
	<form id="pay_zpayment" name="pay_zpayment" method="post" action="https://z-payment.com/merchant.php">
		<input type="hidden" name="LMI_PAYEE_PURSE" value="12142"/>
		<input type="hidden" name="ZP_SIGN" value="77771140008"/>
		<input runat="server" type="hidden" id="LMI_PAYMENT_NO" name="LMI_PAYMENT_NO" value=""/>
		<input runat="server" type="hidden" id="LMI_PAYMENT_AMOUNT" name="LMI_PAYMENT_AMOUNT" value=""/>
		<input runat="server" type="hidden" name="LMI_PAYMENT_DESC" id="LMI_PAYMENT_DESC" value=""/>
		<input runat="server" name="CLIENT_MAIL" id="CLIENT_MAIL" type="hidden" value=""/>
		<input type="submit" style="visibility:hidden;" value="Оплатить"/>
	</form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PaymentForm.aspx.cs" Inherits="rss" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<!-- link rel="Stylesheet" href="../css/Master.css" / -->
    <title></title>
    <script type="text/javascript" src="../js/jquery-1.7.js"></script>
    <script type="text/javascript">
    	$(document).ready(function(){
    		//var elem = document.getElementsByName('LMI_PAYMENT_NO')[0];
			//elem.setAttribute('value', '0293412348');
			//document.getElementsByName('LMI_PAYMENT_NO')[0].value = '0293412348';
		});
    </script>
	<style type="text/css">
	input[name="LMI_PAYMENT_AMOUNT"]
	{
		font-size:16px;
	}
	input[type="submit"]
	{
		font-size:24px;
		height:24px;
		font-weight:bold;
		color:Green;
		margin: 2px 0px 2px 0px;
	}
	body
	{
		font-family: Verdana, Helvetica, Arial, sans-serif;
		font-size: 13px;
		line-height: 150%;
		color: #454545;
		text-align:center;
		margin:0;
	}
	td
	{
		--min-width:200px;
	}
	</style>
	<link rel="Stylesheet" href="../css/Admin.css" />
    <link rel="Stylesheet" href="../css/Infos.css" />
</head>
<body>
	    <div class="tableholder">
		<table>
			<caption>Способы оплаты</caption>
			<tr>
				<td style="width:125px">
					<img src="../images/zlogo.png" /><b
				</td>
				<td style="width:200px">
					VISA, MasterCard<br/> WebMoney, Яндекс.Деньги
				</td>
				<td style="width:200px">
					<form id="pay_zpayment" name="pay_zpayment" method="post" action="https://z-payment.com/merchant.php">
						<input type="hidden" name="LMI_PAYEE_PURSE" value="12142"/>
						<input runat="server" type="hidden" id="LMI_PAYMENT_NO" name="LMI_PAYMENT_NO" value=""/>
						<input name="LMI_PAYMENT_AMOUNT" type="text" size="10" maxlength="10"/>
						<input runat="server" type="hidden" name="LMI_PAYMENT_DESC" id="LMI_PAYMENT_DESC" value=""/>
						<input runat="server" name="CLIENT_MAIL" id="CLIENT_MAIL" type="hidden" value=""/>
						<input type="submit" value="Оплатить"/>
					</form>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>

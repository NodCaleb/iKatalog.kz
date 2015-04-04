<%@ Page Title="" Language="C#" MasterPageFile="~/KtradeMasterPageII.master" AutoEventWireup="true"
    CodeFile="TestOnlinePayment.aspx.cs" Inherits="Test_TestGeneral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<link rel="Stylesheet" href="../css/Offers.css" />
	<title>Ktrade - оплата online</title>
	<link rel="Stylesheet" href="../css/Admin.css" />
    <link rel="Stylesheet" href="../css/Infos.css" />
    <style>
    td > input[type="submit"]
    {
		--height: 80px;
		width: 100px;
		font-size: large;
		font-weight:bold;
		color:Green;
		margin: 5px 5px 5px 5px;
	}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h2>Оплата online:</h2>
    <!-- iframe frameborder="0" scrolling="no" width="700px" height="600px" src="PaymentForm.aspx"></iframe -->
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
</asp:Content>

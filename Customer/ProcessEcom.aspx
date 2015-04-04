<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProcessEcom.aspx.cs" Inherits="rss" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Обработка платежа</title>
    <script type="text/javascript" src="../js/jquery-1.7.js"></script>
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
		<p>Проверка данных.</p>
	</div>
	<form id="Validate_eComCharge" runat="server">
	</form>
</body>
</html>

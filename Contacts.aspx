<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="Contacts.aspx.cs" Inherits="Contacts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - контактная информация</title>
    <link rel="Stylesheet" href="css/About.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="background">
	<h2>Контактная информация:</h2>
	<table>
	    <tr valign="top">
		<td>
		    <h3>ТОО Internet Katalog (Алматы)</h3>
		    <p>
			Алматы 050063 Казахстан<br/>
			мкр. Аксай-5 д. 1<br/>
			Тел.: +7 701 543 62 59<br/>
			Тел.: (8 727) 373 50 70<br/>
			Skype: ikatalog<br/>
			Mail: <a id="ctl00_MailLink" href="mailto:eg@ikatalog.kz">eg@ikatalog.kz</a><br/>
		    </p>
		</td>
		<td width="30px"></td>
		<td>
		    <h3>KtradeCommerce OÜ (Таллин)</h3>
		    <p>
			Narva mnt 7-563<br/>
			10117, Tallina linn<br/>
			Harju maakond<br/>
			Eesti Vabariik<br/>
			+372 535 188 66<br/>
			<a href="http://ktrade2.eu" target="_blank">ktrade2.eu</a>
		    </p>
		</td>
		<td width="30px"></td>
		<td>
		</td>
	    </tr>
	</table>
    </div>
</asp:Content>


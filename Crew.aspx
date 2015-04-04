<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="Crew.aspx.cs" Inherits="Crew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - наша команда</title>
    <link rel="Stylesheet" href="css/Crew.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="background" style="min-height: 430px;">
	<h1>Наша команда</h1>
	<div class="member">
	    <img src="Images/Crew/Galina.png" alt="" title="Евгений Рожков" />
	    <h2>Галина Еремина</h2>
	    <p>Директор офиса в г. Алматы.</p>
	    <p>Отвечает за работу с клиентами в offline, консультации, прием заказов, приемку посылок, выдачу заказов.</p>
	</div>
	<div class="member">
	    <img src="Images/Crew/Eugene.png" alt="" title="Евгений Рожков" />
	    <h2>Евгений Рожков</h2>
	    <p>Обеспечивает техническую составляющую проекта, функционирование бизнеса в online, сайта с возможностью оформления заказов через интернет.</p>
	    <p>Автоматизацию основных рабочих процессов, позволяющую обеспечить минимальное время от поступления посылки о выдачи заказов по сравнению с конкурентами.</p>
	</div>
	
    </div>
</asp:Content>


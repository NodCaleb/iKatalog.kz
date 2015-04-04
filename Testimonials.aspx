<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesTestimonials.master" AutoEventWireup="true" CodeFile="Testimonials.aspx.cs" Inherits="Crew" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog — отзывы наших клиентов</title>
    <link rel="Stylesheet" href="css/Testimonials.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="background">
	<h1>Отзывы наших клиентов</h1>
	<p>Мы всегда благодарим наших клиентов за оформление заказов на нашем сайте. Довольно часто они тоже отправляют нам ответы с благодарностями. Некоторые мы приводим в данном разделе.</p>
	<asp:UpdatePanel ID="TestimonialUpdatePanel" runat="server" UpdateMode="Conditional">
	    <ContentTemplate>
		<asp:Panel id="FormPanel" runat="server">
		    <p>Мы будем весьма признательны, если вы также оставите нам отзыв, для этого воспользуйтесь, пожалуйста, формой ниже:</p>
		    <asp:TextBox ID="NameInput" runat="server" MaxLength="50" placeholder="Имя"></asp:TextBox>
		    <asp:TextBox ID="CityInput" runat="server" MaxLength="50" placeholder="Город"></asp:TextBox>
		    <asp:TextBox ID="EmailInput" runat="server" MaxLength="50" placeholder="Email"></asp:TextBox><br/>
		    <asp:TextBox ID="TestimonialInput" runat="server" Text='' MaxLength="1000" placeholder="Текст отзыва" TextMode="MultiLine"></asp:TextBox><br/>
		    <asp:Button ID="AddItemButton" runat="server" Text="Добавить отзыв" OnClick="AddTestimonialButton_Click" ValidationGroup="TestimonialValidationGroup" />
		    <div class="validationsummary">
			<asp:ValidationSummary ID="TestimonialValidationSummary" runat="server" ValidationGroup="TestimonialValidationGroup" />
		    </div>
		    <asp:RequiredFieldValidator ID="NameRequiredValidator" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="TestimonialValidationGroup" ControlToValidate="NameInput"></asp:RequiredFieldValidator>
		    <asp:RequiredFieldValidator ID="CityRequiredValidator" runat="server" ErrorMessage="Не заполнен город" Display="None" ValidationGroup="TestimonialValidationGroup" ControlToValidate="CityInput"></asp:RequiredFieldValidator>
		    <asp:RequiredFieldValidator ID="EmailRequiredValidator" runat="server" ErrorMessage="Не заполнен email" Display="None" ValidationGroup="TestimonialValidationGroup" ControlToValidate="EmailInput"></asp:RequiredFieldValidator>
		    <asp:RequiredFieldValidator ID="TextRequiredValidator" runat="server" ErrorMessage="Не заполнен текст отзыва" Display="None" ValidationGroup="TestimonialValidationGroup" ControlToValidate="TestimonialInput"></asp:RequiredFieldValidator>
		</asp:Panel>
		<asp:Panel id="GratitudePanel" visible="false" runat="server">
		    <p><i>Мы благодарим за ваш отзыв, он обязательно появится на сайте после проверки администратором.</i></p>
		</asp:Panel>
	    </ContentTemplate>
	</asp:UpdatePanel>
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


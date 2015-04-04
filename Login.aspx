<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - необходима авторизация</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="background">
	<h1>Требуется авторизация</h1>
	<img src="Images/Lock_64.png" alt="Замок" style="float: left;" />
	<p>Для доступа к выбранному вами разделу сайта необходимо авторизироваться!</p>
	<p>Вы можете прямо сейчас <asp:LinkButton id="LoginLinkButton" Text="войти" OnClick="LoginLinkButton_Click" runat="server"/>, используя ваш логин и пароль, если вы уже зарегистрированы на сайте.</p>
	<p>Если нет, вы можете зарегистрироваться, воспользовавшись <asp:LinkButton id="RegisterLinkButton" Text="формой регистрации" OnClick="RegisterLinkButton_Click" runat="server"/>.</p>
    </div>
    <asp:Panel id="LoginFormPanel" visible="false" runat="server">
	<div class="Overlay">
	    <div class="LoginForm">
		<asp:TextBox ID="UserNameTextBox" runat="server" placeholder="логин или email"></asp:TextBox>
		<asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" placeholder="пароль"></asp:TextBox><br/>
		<asp:Button id="LoginButton" Text="Вход" OnClick="LoginButton_Click" runat="server"/>
		<asp:Button id="CancelButton" Text="Отмена" OnClick="CancelButton_Click" runat="server"/>
	    </div>
	</div>
    </asp:Panel>
    <asp:Panel id="RegisterFormPanel" visible="false" runat="server">
	<div class="Overlay">
	    <div class="validationsummary">
		<asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="RegisterValidationGroup" />
	    </div>
	    <div class="RegisterForm">
		<h2>Регистрация на сайте</h2>
		<p>Зарегистрироваться на сайте очень просто — укажите ваши имя и фамилию, email и телефон и нажмите кнопку Зарегистрироваться.</p>
		<asp:TextBox ID="UserFullNameTextBox" runat="server" placeholder="имя фамилия"></asp:TextBox><br/>
		<asp:TextBox ID="EmailTextBox" runat="server" placeholder="email"></asp:TextBox><br/>
		<asp:TextBox ID="PhoneTextBox" runat="server" placeholder="телефон"></asp:TextBox><br/>
		<asp:Button id="RegisterButton" Text="Зарегистрироваться" OnClick="RegisterCustomer" runat="server" ValidationGroup="RegisterValidationGroup"/><br/>
		<asp:LinkButton id="CancelRegisterLinkButton" Text="отмена" OnClick="CancelButton_Click" runat="server"/>
		
		<asp:RequiredFieldValidator ID="UserFullNameRequiredValidator" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="UserFullNameTextBox"></asp:RequiredFieldValidator>
		<asp:RequiredFieldValidator ID="EmailRequiredValidator" runat="server" ErrorMessage="Не заполнен email" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="EmailTextBox"></asp:RequiredFieldValidator>
		<asp:RequiredFieldValidator ID="PhoneRequiredValidator" runat="server" ErrorMessage="Не заполнен телефон" Display="None" ValidationGroup="RegisterValidationGroup" ControlToValidate="PhoneTextBox"></asp:RequiredFieldValidator>
		<asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="EmailTextBox" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="RegisterValidationGroup"></asp:RegularExpressionValidator>
		<asp:CustomValidator ID="EmailUniquenessValidator" runat="server" ErrorMessage="Пользователь с таким адресом электронной почты уже существует" ControlToValidate="EmailTextBox" Display="None" ValidationGroup="RegisterValidationGroup"></asp:CustomValidator>
	    </div>
	</div>
    </asp:Panel>
</asp:Content>


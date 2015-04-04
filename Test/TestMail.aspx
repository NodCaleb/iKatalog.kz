<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true"
    CodeFile="TestMail.aspx.cs" Inherits="Test_TestGeneral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<link rel="Stylesheet" href="../css/Offers.css" />
	<link rel="Stylesheet" href="../css/Slideout.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <p>Логин:<asp:TextBox ID="LoginInput" runat="server"></asp:TextBox></p>
    <p>Пароль:<asp:TextBox ID="PasswordInput" runat="server"></asp:TextBox></p>
    <p>Email:<asp:TextBox ID="EmailInput" runat="server"></asp:TextBox></p>
    <p>Имя:<asp:TextBox ID="FirstNameInput" runat="server"></asp:TextBox></p>
    <p>Фамилия:<asp:TextBox ID="LastNameInput" runat="server"></asp:TextBox></p>
    <p>Телефон:<asp:TextBox ID="PhoneInput" runat="server"></asp:TextBox></p>
    <p>Адрес:<asp:TextBox ID="AddressInput" runat="server"></asp:TextBox></p>
    <p><asp:Button ID="Register" runat="server" Text="Feuer!" onclick="Button_Click" /><asp:Label ID="TestLabel" runat="server" Text=''></asp:Label></p>
</asp:Content>

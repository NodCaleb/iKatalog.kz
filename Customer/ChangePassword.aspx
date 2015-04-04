<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="ChangePassword.aspx.cs" Inherits="Customer_ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - смена пароля</title>
    <link rel="Stylesheet" href="../css/Register.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <h1>Смена пароля</h1>
    <asp:ChangePassword ID="KtradeChangePassword" CancelDestinationPageUrl="~/" runat="server">
        <ChangePasswordTemplate>
            <div class="inputfield">
                <asp:TextBox ID="CurrentPassword" runat="server" TextMode="Password"></asp:TextBox>
                <p>Старый пароль:</p>
                <asp:RequiredFieldValidator ID="CurrentPasswordRequiredFieldValidator" runat="server" ErrorMessage="Введите старый пароль" ControlToValidate="CurrentPassword" Display="None" ValidationGroup="KtradeChangePassword"></asp:RequiredFieldValidator>
            </div>
            <div class="inputfield">
                <asp:TextBox ID="NewPassword" runat="server" TextMode="Password"></asp:TextBox>
                <p>Новый пароль:</p>
                <asp:RequiredFieldValidator ID="PasswordRequiredFieldValidator" runat="server" ErrorMessage="Введите новый пароль" ControlToValidate="NewPassword" Display="None" ValidationGroup="KtradeChangePassword"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="PasswordRegularExpressionValidator1" runat="server" ErrorMessage="Длина пароля должна быть не менее 6 символов" ControlToValidate="NewPassword" ValidationExpression=".{6,}" Display="None" ValidationGroup="KtradeChangePassword"></asp:RegularExpressionValidator>
            </div>
            <div class="inputfield">
                <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox>
                <p>Подтвердите пароль:</p>
                <asp:CompareValidator ID="PasswordCompareValidator" runat="server" ErrorMessage="Пароль и подтверждение пароля должны совпадать" ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" Display="None" ValidationGroup="KtradeChangePassword"></asp:CompareValidator>
            </div>
            <div>
                <asp:ValidationSummary ID="RegisterValidationSummary" runat="server" ValidationGroup="KtradeChangePassword" />
            </div>
            <div class="inputfield">
                <asp:Button ID="ChangePasswordPushButton" runat="server" CommandName="ChangePassword" Text="Изменить пароль" ValidationGroup="KtradeChangePassword" />
            </div>
        </ChangePasswordTemplate>
        <SuccessTemplate>
            <p>Пароль изменен!</p>
        </SuccessTemplate>
        <MailDefinition From="admin@iKatalog.kz" Subject="Смена пароля iKatalog.kz" BodyFileName="~/Customer/ChangePassword.txt" />
    </asp:ChangePassword>
</asp:Content>


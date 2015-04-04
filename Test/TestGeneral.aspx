<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true"
    CodeFile="TestGeneral.aspx.cs" Inherits="Test_TestGeneral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<link rel="Stylesheet" href="../css/Offers.css" />
	<link rel="Stylesheet" href="../css/Slideout.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    
   <asp:Label ID="TestLabel" runat="server" Text=''></asp:Label>
   <!-- div id="slideout">
	<asp:UpdatePanel ID="AskMeUpdatePanel" runat="server" UpdateMode="Conditional">
	    <ContentTemplate>
		<asp:MultiView ID="AskMultiView" ActiveViewIndex="0" runat="server">
                    <asp:View ID="Ask" runat="server">
			<asp:Image ID="AskImage" alt="Задать вопрос" ImageUrl="~/images/AskMe.png" runat="server" />
			<div id="slideout_inner">
			    <p>
				Ваше имя:<asp:RequiredFieldValidator ID="NameInputRrequiredValidator" runat="server" ControlToValidate="NameInput" ErrorMessage="Не указано имя." ValidationGroup="AskMeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
				<asp:TextBox ID="NameInput" runat="server"></asp:TextBox>
				Email:<asp:RequiredFieldValidator ID="EmailInputRrequiredValidator" runat="server" ControlToValidate="EmailInput" ErrorMessage="Не указан Email." ValidationGroup="AskMeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
				<asp:TextBox ID="EmailInput" runat="server"></asp:TextBox>
				Телефон:<asp:RequiredFieldValidator ID="PhoneInputRrequiredValidator" runat="server" ControlToValidate="PhoneInput" ErrorMessage="Не указан телефон." ValidationGroup="AskMeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
				<asp:TextBox ID="PhoneInput" runat="server"></asp:TextBox>
				Что вы ищете:<asp:RequiredFieldValidator ID="SearchInputRrequiredValidator" runat="server" ControlToValidate="SearchInput" ErrorMessage="Не указан запрос." ValidationGroup="AskMeValidationGroup" Display="None">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Не более 500 символов, пожалуйста." Display="None" ValidationExpression=".{0,500}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="SearchInput">*</asp:RegularExpressionValidator>
				<asp:TextBox ID="SearchInput" runat="server" TextMode="multiline"></asp:TextBox>
				<asp:Button ID="AskMeButton" runat="server" Text="Отправить запрос" OnClick="AskMeButton_Click" ValidationGroup="AskMeValidationGroup" />
				<asp:ValidationSummary ID="AskMeValidationSummary" runat="server" ValidationGroup="AskMeValidationGroup" />
			    </p>
			</div>
		    </asp:View>
		    <asp:View ID="Answer" runat="server">
			<asp:Image ID="AskImage2" alt="Задать вопрос" ImageUrl="~/images/AskMe.png" runat="server" />
			<div id="slideout_inner">
			    <p>Благодарим, ваш запрос принят.</p>
			    <p>Наш менеджер свяжется с вами в ближайшее время.</p>
			</div>
		    </asp:View>
                </asp:MultiView>
	    </ContentTemplate>
	</asp:UpdatePanel>
    </div -->
   
   <!-- p>Если вас интересует како-то определенный товар (например — курка на зиму), заполните форму ниже и мы вышлем вам интересующую вас информацию в ближайшее время.</p -->
   
</asp:Content>

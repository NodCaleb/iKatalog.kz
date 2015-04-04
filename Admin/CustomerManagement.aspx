<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CustomerManagement.aspx.cs" Inherits="Admin_CustomerManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - покупатели</title>
    <link rel="Stylesheet" href="../css/Dictionary.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CustomerListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="select UserId, FullName from UserView order by FullName asc"></asp:SqlDataSource>
    <asp:SqlDataSource ID="CustomerDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select UserID, Customer_id, FirstName, LastName, Alias, Email, UserName, Password, IsLockedOut, Source from UserView where UserId = @UserId"
        UpdateCommand=" update aspnet_Users set UserName = @UserName, LoweredUserName = LOWER(@UserName) where UserId = @UserId
                        update aspnet_Membership set Email = @Email, LoweredEmail = LOWER(@Email), Password = @Password, IsLockedOut = @IsLockedOut where UserId = @UserId
                        update Customers set FirstName = @FirstName, LastName = @LastName, Alias = @Alias where User_id = @UserId">
        <SelectParameters>
            <asp:ControlParameter ControlID="CustomersDropDownList" Name="UserId" PropertyName="SelectedValue" DefaultValue="0" Type="String" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="UserId" Type="Object" />
            <asp:Parameter Name="Customer_id" Type="Int32" />
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="FirstName" Type="String" />
            <asp:Parameter Name="LastName" Type="String" />
            <asp:Parameter Name="Alias" Type="String" />
            <asp:Parameter Name="IsLockedOut" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="CustomerManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Покупатели</h2>
    <asp:UpdatePanel ID="CustomersUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="dictionaryheader">
                <asp:DropDownList ID="CustomersDropDownList" runat="server" DataValueField="UserId" DataTextField="FullName" DataSourceID="CustomerListSource" AutoPostBack="True"></asp:DropDownList>
            </div>
            <asp:DetailsView ID="CustomerDetailsView" runat="server"
                AutoGenerateRows="False"
                DataKeyNames="UserId" 
                DataSourceID="CustomerDetailsSource"
                GridLines="None"
                OnItemCommand="UserCommand"
                EnableModelValidation="True">
                 <Fields>
                    <asp:TemplateField HeaderText="ID">
                        <EditItemTemplate>
                            <asp:Label ID="UserIdLabel" runat="server" Text='<%# Bind("Customer_id") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="UserIdLabel" runat="server" Text='<%# Bind("Customer_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Фамилия">
                        <EditItemTemplate>
                            <asp:TextBox ID="LastNameTextBox" runat="server" Text='<%# Bind("LastName") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="LastNameLabel" runat="server" Text='<%# Bind("LastName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Имя">
                        <EditItemTemplate>
                            <asp:TextBox ID="FirstNameTextBox" runat="server" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="FirstNameLabel" runat="server" Text='<%# Bind("FirstName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Псевдоним">
                        <EditItemTemplate>
                            <asp:TextBox ID="AliasTextBox" runat="server" Text='<%# Bind("Alias") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="AliasLabel" runat="server" Text='<%# Bind("Alias") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Email">
                        <EditItemTemplate>
                            <asp:TextBox ID="EmailTextBox" runat="server" Text='<%# Bind("Email") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="EmailLabel" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Логин">
                        <EditItemTemplate>
                            <asp:TextBox ID="UserNameTextBox" runat="server" Text='<%# Bind("UserName") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="UserNameLabel" runat="server" Text='<%# Bind("UserName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Пароль">
                        <EditItemTemplate>
                            <asp:TextBox ID="PasswordTextBox" runat="server" Text='<%# Bind("Password") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="PasswordLabel" runat="server" Text='<%# Bind("Password") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Блокирован" SortExpression="Chilrden">
                        <EditItemTemplate>
                            <asp:CheckBox ID="IsLockedOutCheckBox" runat="server" Checked='<%# Bind("IsLockedOut") %>' />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="IsLockedOutCheckBox" runat="server" Checked='<%# Bind("IsLockedOut") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Источник" SortExpression="Source">
                        <EditItemTemplate>
                            <asp:Label ID="SourceLabel" runat="server" Text='<%# Bind("Source") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="SourceLabel" runat="server" Text='<%# Bind("Source") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:ImageButton ID="UpdateButton" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Update" Title="OK" />
                            <asp:ImageButton ID="CancelButton" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                            <asp:ImageButton ID="DeleteButton" runat="server" ImageUrl="~/Images/Buttons/Trash32.png" CausesValidation="False" CommandName="Delete" CommandArgument='<%# Bind("Customer_id") %>' Title="Удалить пользователя" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:ImageButton ID="EditButton" runat="server" ImageUrl="~/Images/Buttons/Edit.png" CausesValidation="False" CommandName="Edit" Title="Редактировать" />
                            <asp:ImageButton ID="MailButton" runat="server" ImageUrl="~/Images/Buttons/Letter.png" CausesValidation="False" CommandName="Mail" Title="Выслать сообщения о регистрации" />
                            
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <p>
        <asp:ImageButton ID="ExportCustomersButton" runat="server" ImageUrl="~/Images/Buttons/Export.png" Title="Экспорт для Unisender" onclick="ExportCustomersButton_Click" />
    </p>
</asp:Content>


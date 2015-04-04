<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="StaticPagesManagement.aspx.cs" Inherits="Admin_NewsManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Ktrade_Admin - страницы</title>
    <link rel="Stylesheet" href="../css/Dictionary.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="PagesListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                        id,
	                        convert (nvarchar(10), id) + ': ' + Name as Title
                        from
	                        StaticPages
                        order by
	                        id asc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PagesDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        DeleteCommand="DELETE FROM [StaticPages] WHERE [id] = @id"
        InsertCommand="INSERT INTO [StaticPages] ([Name], [Body]) VALUES (@Name, @Body)"
        SelectCommand="SELECT [id], [Name], [Body] FROM [StaticPages] WHERE [id] = @id"
        UpdateCommand="UPDATE [StaticPages] SET [Name] = @Name, [Body] = @Body WHERE [id] = @id">
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="PagesDropDownList" Name="id" PropertyName="SelectedValue" DefaultValue="0" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewsManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Страницы</h2>
        <div>
            <div class="dictionaryheader">
                <asp:DropDownList ID="PagesDropDownList" runat="server" DataValueField="id" DataTextField="Title" DataSourceID="PagesListSource" AutoPostBack="True"></asp:DropDownList>
            </div>
            <asp:DetailsView ID="PagesEditView" runat="server"
                GridLines="None"
                Width="100%"
                DataKeyNames="id"
                AutoGenerateRows="False"
                DataSourceID="PagesDetailsSource"
                EnableModelValidation="True">
                <Fields>
		    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:ImageButton ID="ImageButton11" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Update" Title="OK" />
                            <asp:ImageButton ID="ImageButton21" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:ImageButton ID="ImageButton11" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Insert" Title="OK" />
                            <asp:ImageButton ID="ImageButton21" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton11" runat="server" ImageUrl="~/Images/Buttons/Edit.png" CausesValidation="False" CommandName="Edit" Title="Редактировать" />
                            <asp:ImageButton ID="ImageButton21" runat="server" ImageUrl="~/Images/Buttons/NewDoc.png" CausesValidation="False" CommandName="New" Title="Создать" />
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:TemplateField HeaderText="Название" SortExpression="Name">
                        <ItemTemplate>
                            <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>'></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Текст" SortExpression="Body">
                        <ItemTemplate>
                            <asp:Label ID="BodyLabel" runat="server" Text='<%# Bind("Body") %>' ></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <CKEditor:CKEditorControl ID="CKEditor" ForcePasteAsPlainText="true" Height="800" ResizeDir="Vertical" Toolbar="Full" Text='<%# Bind("Body") %>' runat="server"></CKEditor:CKEditorControl>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <CKEditor:CKEditorControl ID="CKEditor" ForcePasteAsPlainText="true" Height="800" ResizeDir="Vertical" Toolbar="Full" Text='<%# Bind("Body") %>' runat="server"></CKEditor:CKEditorControl>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Update" Title="OK" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Insert" Title="OK" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/Edit.png" CausesValidation="False" CommandName="Edit" Title="Редактировать" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/NewDoc.png" CausesValidation="False" CommandName="New" Title="Создать" />
                        </ItemTemplate>
                    </asp:TemplateField>            
                </Fields>
            </asp:DetailsView>
        </div>
</asp:Content>


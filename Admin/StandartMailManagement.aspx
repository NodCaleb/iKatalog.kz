<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="StandartMailManagement.aspx.cs" Inherits="Admin_NewsManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Ktrade_Admin - страницы</title>
    <link rel="Stylesheet" href="../css/Dictionary.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="MailListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                        id,
	                        convert (nvarchar(10), id) + ': ' + isnull(Comment,Subject) as Title
                        from
	                        StandartMail
                        order by
	                        id asc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="MailDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        DeleteCommand="DELETE FROM [StandartMail] WHERE [id] = @id"
        InsertCommand="INSERT INTO [StandartMail] ([Subject], [Body], [Comment]) VALUES (@Subject, @Body, @Comment)"
        SelectCommand="SELECT [id], [Subject], [Body], [Comment] FROM [StandartMail] WHERE [id] = @id"
        UpdateCommand="UPDATE [StandartMail] SET [Subject] = @Subject, [Body] = @Body, [Comment] = @Comment WHERE [id] = @id">
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Subject" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
	    <asp:Parameter Name="Comment" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Subject" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
	    <asp:Parameter Name="Comment" Type="String" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="MailDropDownList" Name="id" PropertyName="SelectedValue" DefaultValue="0" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewsManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Стандартные письма</h2>
        <div>
            <div class="dictionaryheader">
                <asp:DropDownList ID="MailDropDownList" runat="server" DataValueField="id" DataTextField="Title" DataSourceID="MailListSource" AutoPostBack="True"></asp:DropDownList>
            </div>
            <asp:DetailsView ID="MailEditView" runat="server"
                GridLines="None"
                Width="100%"
                DataKeyNames="id"
                AutoGenerateRows="False"
                DataSourceID="MailDetailsSource"
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
                    <asp:TemplateField HeaderText="Тема" SortExpression="Subject">
                        <ItemTemplate>
                            <asp:Label ID="SubjectLabel" runat="server" Text='<%# Bind("Subject") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="SubjectTextBox" runat="server" Text='<%# Bind("Subject") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="SubjectTextBox" runat="server" Text='<%# Bind("Subject") %>'></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Тело письма" SortExpression="Body">
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
		    <asp:TemplateField HeaderText="Комментарий" SortExpression="Body">
                        <ItemTemplate>
                            <asp:Label ID="CommentLabel" runat="server" Text='<%# Bind("Comment") %>' ></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="CommentTextBox" runat="server" Text='<%# Bind("Comment") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="CommentTextBox" runat="server" Text='<%# Bind("Comment") %>'></asp:TextBox>
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
	    <p><i>Комментарий — только для внутреннего пользования, пользователи его не видят.</i></p>
	    <p>Стандартные поля:
	    <ul>
		<li>%USER_NAME% — имя и фамилия пользователя, указанное им при регистрации</li>
	    </ul>
	    
	    </p>
        </div>
</asp:Content>


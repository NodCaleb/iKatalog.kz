<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NewsManagement.aspx.cs" Inherits="Admin_NewsManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - новости</title>
    <link rel="Stylesheet" href="../css/Dictionary.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="NewsListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                        id,
	                        CONVERT (varchar(10), CONVERT (date, CreationDate)) + ' ' + Header as Title
                        from
	                        News
                        where
	                        DATEDIFF(DD, case @All when 0 then CreationDate else GETDATE() end, GETDATE()) &lt; 90
                        order by
	                        CreationDate desc">
        <SelectParameters>
            <asp:ControlParameter ControlID="AllNewsCheckBox" Name="All" PropertyName="Checked" DefaultValue="false" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="NewsDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        DeleteCommand="DELETE FROM [News] WHERE [id] = @id"
        InsertCommand="INSERT INTO [News] ([Header], [Body], [Published],[Teaser], [MetaTitle], [MetaDescription]) VALUES (@Header, @Body, @Published, @Teaser, @MetaTitle, @MetaDescription)"
        SelectCommand="SELECT [id], [Header], [Body], isnull([Published],0) as Published, [CreationDate], isnull([Teaser],'...') as Teaser, isnull([MetaTitle],'...') as MetaTitle, isnull([MetaDescription],'...') as MetaDescription FROM [News] WHERE [id] = @id"
        UpdateCommand="UPDATE [News] SET [Header] = @Header, [Body] = @Body, [Published] = @Published, [CreationDate] = @CreationDate, [Teaser] = @Teaser, [MetaTitle] = @MetaTitle, [MetaDescription] = @MetaDescription WHERE [id] = @id">
        <DeleteParameters>
            <asp:Parameter Name="id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="Header" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
            <asp:Parameter Name="Published" Type="Boolean" />
            <asp:Parameter Name="CreationDate" Type="DateTime" />
            <asp:Parameter Name="Teaser" Type="String" />
	    <asp:Parameter Name="MetaTitle" Type="String" />
	    <asp:Parameter Name="MetaDescription" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Header" Type="String" />
            <asp:Parameter Name="Body" Type="String" />
            <asp:Parameter Name="Published" Type="Boolean" />
            <asp:Parameter Name="CreationDate" Type="DateTime" />
            <asp:Parameter Name="Teaser" Type="String" />
            <asp:Parameter Name="id" Type="Int32" />
	    <asp:Parameter Name="MetaTitle" Type="String" />
	    <asp:Parameter Name="MetaDescription" Type="String" />
        </UpdateParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="NewsDropDownList" Name="id" PropertyName="SelectedValue" DefaultValue="0" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="TagsListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                    id,
	                    Tag
                        from
	                    Tags
                        order by
	                    Tag asc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="CurrentTagsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
	                    T.id,
	                    T.Tag
                        from
	                    Tags as T
			    join NewsTags as NT on NT.Tag_id = T.id
			where
			    NT.News_id = @News_id
                        order by
	                    Tag asc">
	<SelectParameters>
            <asp:ControlParameter ControlID="NewsDropDownList" Name="News_id" PropertyName="SelectedValue" DefaultValue="0" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewsManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Новости</h2>
    <%--<asp:UpdatePanel ID="NewsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
        <div>
            <div class="dictionaryheader">
                <asp:DropDownList ID="NewsDropDownList" runat="server" DataValueField="id" DataTextField="Title" DataSourceID="NewsListSource" AutoPostBack="True"></asp:DropDownList>
                <asp:CheckBox ID="AllNewsCheckBox" Checked="false" AutoPostBack="true" Text="Показать старые" runat="server" />
            </div>
            <asp:DetailsView ID="NewsEditView" runat="server"
                GridLines="None"
                Width="100%"
                DataKeyNames="id"
                AutoGenerateRows="False"
                DataSourceID="NewsDetailsSource"
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
                    <asp:TemplateField HeaderText="Дата создания" SortExpression="CreationDate">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("CreationDate") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("CreationDate") %>'></asp:Label>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("CreationDate") %>'></asp:Label>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Опубликовано" SortExpression="Published">
                        <ItemTemplate>
                            <asp:CheckBox ID="CheckBoxPublished" runat="server" Checked='<%# Bind("Published") %>' Enabled="false" />
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:CheckBox ID="CheckBoxPublished" runat="server" Checked='<%# Bind("Published") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="CheckBoxPublished" runat="server" Checked='<%# Bind("Published") %>' />
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Заголовок" SortExpression="Header">
                        <ItemTemplate>
                            <asp:Label ID="HeaderLabel" runat="server" Text='<%# Bind("Header") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="HeaderTextBox" runat="server" Text='<%# Bind("Header") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="HeaderTextBox" runat="server" Text='<%# Bind("Header") %>'></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Анонс" SortExpression="Teaser">
                        <ItemTemplate>
                            <asp:Label ID="TeaserLabel" runat="server" Text='<%# Bind("Teaser") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="TeaserTextBox" runat="server" Text='<%# Bind("Teaser") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="TeaserTextBox" runat="server" Text='<%# Bind("Teaser") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Meta title" SortExpression="MetaTitle">
                        <ItemTemplate>
                            <asp:Label ID="MetaTitleLabel" runat="server" Text='<%# Bind("MetaTitle") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="MetaTitleTextBox" runat="server" Text='<%# Bind("MetaTitle") %>' MaxLength="1000"></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="MetaTitleTextBox" runat="server" Text='<%# Bind("MetaTitle") %>' MaxLength="1000"></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Meta description" SortExpression="MetaDescription">
                        <ItemTemplate>
                            <asp:Label ID="MetaDesciptionLabel" runat="server" Text='<%# Bind("MetaDescription") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="MetaDesciptionTextBox" runat="server" Text='<%# Bind("MetaDescription") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="MetaDesciptionTextBox" runat="server" Text='<%# Bind("MetaDescription") %>' MaxLength="1000" TextMode="MultiLine"></asp:TextBox>
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
	<asp:UpdatePanel ID="TagsUpdatePanel" runat="server" UpdateMode="Conditional">
	    <ContentTemplate>
		<div>
		    <div>
			<table> 
			    <tbody> 
				    <tr> 
					    <td>Теги:</td>
					    <td>
						<asp:Repeater ID="CurrentTagsRepeater" runat="server" DataSourceID="CurrentTagsSource" OnItemCommand="CurrentTagsRepeaterCommand">
						    <ItemTemplate>
							<asp:Label ID="TagLabel" runat="server" Text='<%# Eval("Tag") %>'></asp:Label>
							<asp:ImageButton ID="DeleteTag" runat="server" CommandName="Delete" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Xer.png" CausesValidation="false" Title="Удалить тэг" style="height: 12px;" />
						    </ItemTemplate>
						</asp:Repeater>
					    </td>
				    </tr>
				    <tr> 
					    <td>
						Добавить новый:
					    </td>
					    <td>
						<asp:TextBox ID="NewTagTextBox" runat="server" style="width: 300px;"></asp:TextBox>
						<asp:ImageButton ID="AddNewTagImageButton" runat="server" ImageUrl="~/Images/Buttons/Add.png" CausesValidation="False" Title="Добавить" OnClick="AddNewTagButton_Click" style="height: 19px; margin: 0px 0px -3px 0px;" />
					    </td>
				    </tr>
				    <tr> 
					    <td>
						Добавить существующий:
					    </td>
					    <td>
						<asp:DropDownList ID="TagsDropDownList" runat="server" DataValueField="id" DataTextField="Tag" DataSourceID="TagsListSource" ></asp:DropDownList>
						<asp:ImageButton ID="AddExistingTagImageButton" runat="server" ImageUrl="~/Images/Buttons/Add.png" CausesValidation="False" Title="Добавить" OnClick="AddExistingTagButton_Click" style="height: 19px; margin: 0px 0px -3px 0px;" />
					    </td>
				    </tr>
			    </tbody>
			</table>
		    </div>
		</div>
	    </ContentTemplate>
	</asp:UpdatePanel>
        <h3>Help</h3>
        <p>Чтобы добавить в материал кнопку "Заказать" нужно нажать в редакторе кнопку "Источник" и вставить в нужное место следующий HTML код:</p>
        <p>&lt;p class="orderbutton"&gt;&lt;a href="http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=<b>№каталога</b>&article=<b>артикул</b>&name=<b>наименование</b>&price=<b>цена</b>&size=<b>размер</b>&color=<b>цвет</b>&URL=<b>ссылка</b>"&gt;&lt;img alt="" src="Images/OrderButton.png" title="Заказать" /&gt;&lt;/a&gt;&lt;p&gt;</p>
        <p>Вместо <b>№каталога</b>, <b>артикул</b>, <b>наименование</b>, <b>цена</b>, <b>размер</b>, <b>цвет</b>, <b>ссылка</b> - нужно подставить нужные значения.</p>
        <p>Важно: № каталога можно подсмотреть в <a href="CatalogueDictionary.aspx">Управлении каталогами</a>, из URL нужно удалить <b>http://</b>!</p>
     <%--   </ContentTemplate>
    </asp:UpdatePanel>--%>
    <%--<asp:UpdateProgress ID="NewsUpdateProgress" runat="server" AssociatedUpdatePanelID="NewsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>--%>
</asp:Content>


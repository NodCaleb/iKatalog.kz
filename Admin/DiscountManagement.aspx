<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="DiscountManagement.aspx.cs" Inherits="Admin_DicountManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - скидики и акции</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT [Catalogue_id], [CatalogueName] FROM [Catalogues] where [Active] = 1 ORDER BY [CatalogueName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DiscountSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" select
                            D.id,
                            'http://ikatalog.kz/Images/Logos/' +  C.ImageLink as [ImageLink],
                            C.CatalogueDescription,
	                        D.URL,
	                        D.Comment,
							D.CreationDate
                        from
	                        Discounts as D with (nolock)
	                        join Catalogues as C with (nolock) on C.Catalogue_id = D.Catalogue_id
                        where
	                        isnull (D.Expired, 0) = 0
                        order by D.CreationDate desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Скидки и акции</h2>
    <div class="inputfield">
        <asp:DropDownList ID="CatalogueList" runat="server" DataSourceID="CatalogueListSource" DataTextField="CatalogueName" DataValueField="Catalogue_id"></asp:DropDownList>
        <p>Каталог:</p>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="URLInput" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator ID="URLInputValidator" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="URLInput">!</asp:RequiredFieldValidator>
        <p>Ссылка:</p>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="CommentInput" runat="server" ></asp:TextBox>
        <asp:RequiredFieldValidator ID="CommentInputValidator" runat="server" ErrorMessage="RequiredFieldValidator" ControlToValidate="CommentInput">!</asp:RequiredFieldValidator>
        <p>Комментарий:</p>
    </div>
    <div class="inputfield">
        <asp:Button ID="AddButton" runat="server" Text="Добавить" onclick="AddButton_Click" />
    </div>
        
    <asp:UpdatePanel ID="DiscountUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="DiscountsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="DiscountSource" 
                EnableModelValidation="True"
                OnRowCommand="DiscountsView_RowCommand"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Дата публикации" SortExpression="id">
                        <ItemTemplate>
                            <asp:Label ID="CreationDateLabel" runat="server" Text='<%# Bind("CreationDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Каталог" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:HyperLink ID="DsicountLink" runat="server" NavigateUrl='<%# Eval("URL") %>' target="_blank">
                                <img src='<%# Eval("ImageLink") %>' />
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Комментарий" SortExpression="CreationDate">
                        <ItemTemplate>
                            <asp:Label ID="CommentLabel" runat="server" Text='<%# Bind("Comment") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Удалить">
                        <ItemTemplate>
                            <asp:ImageButton ID="DeleteLine" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Удалить" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>


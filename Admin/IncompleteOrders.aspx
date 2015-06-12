<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="IncompleteOrders.aspx.cs" Inherits="Admin_IncompleteOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - управление заказами</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="OrderDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select * from ImcompleteOrdersView order by CreationDate desc"
            UpdateCommand="update OrderItems set KtradeStatus_id = @KtradeStatus_id where id = @Line_id">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Неоформленные заказы:</h2>
    <asp:UpdatePanel ID="OrderDetailsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="OrderDetailsGridView" runat="server"
                GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="Line_id"
                DataSourceID="OrderDetailsSource" 
                EnableModelValidation="True"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Клиент" SortExpression="FullName">
                        <EditItemTemplate>
                            <asp:Label ID="LineIDLabel" runat="server" Text='<%# Bind("FullName") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                        	<a href='<%# Eval("mailURL") %>'><%# Eval("FullName") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Каталог" SortExpression="CatalogueName">
                        <EditItemTemplate>
                            <asp:Label ID="CatalogueLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="CatalogueLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Артикул" SortExpression="Article_id">
                        <EditItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" SortExpression="ArticleName">
                        <EditItemTemplate>
                            <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("ArticleName") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("ArticleName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <EditItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Дата создания" SortExpression="CreationDate">
                        <EditItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("CreationDate", "{0:d}") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("CreationDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="OrderDetailsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div class="download">
        <p>Выгрузить:</p>
        <asp:ImageButton ID="ExportCSVButton" runat="server" ImageUrl="~/Images/excel-icon.png" Title="Экспорт в CSV" onclick="ExportCSVButton_Click" />
    </div>
</asp:Content>


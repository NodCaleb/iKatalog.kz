<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ImportData.aspx.cs" Inherits="Admin_ImportData" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - импорт данных</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="ImportedStatusesSource" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
	        KSI.id as ImportedLine_id,
                KSI.OrderItem_id,
                OI.Order_id,
                convert (varchar (10), OI.Order_id) + ' / ' + convert (varchar (10), KSI.OrderItem_id) as OrderLine,
                C.CatalogueName,
                OI.Article_id,
                OI.ArticleName,
                OI.Comment,
                KSI.KtradeStatus,
                KS.KtradeStatusDescription,
                KSI.Price,
		CU.FirstName + ' ' + CU.LastName as CustomerName
            from
	        KtradeStatusImport as KSI
                join OrderItems as OI on OI.id = KSI.OrderItem_id
                join Catalogues as C on C.Catalogue_id = OI.Catalogue_id
                join KtradeStatuses as KS on KS.KtradeStatus_id = KSI.KtradeStatus
                join Orders as O on O.id = OI.Order_id
		join Customers as CU on CU.Customer_id = O.Customer_id
            order by
                OI.id asc"
        UpdateCommand="update KtradeStatusImport set KtradeStatus = @KtradeStatus where OrderItem_id = @OrderItem_id"
        runat="server">
        <UpdateParameters>
            <asp:Parameter Name="KtradeStatus" />
            <asp:Parameter Name="ImportedLine_id" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="KtradeStatusesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT KtradeStatus_id, KtradeStatusDescription FROM [KtradeStatuses]"></asp:SqlDataSource>
    <asp:ScriptManager ID="ImportDataScriptManager" runat="server"></asp:ScriptManager>
    <h2>Импорт данных</h2>
    <asp:UpdatePanel ID="ImportedDataUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="ImportedStatusesView" runat="server"
                AutoGenerateColumns="False"
                DataSourceID="ImportedStatusesSource"
                EnableModelValidation="True"
                DataKeyNames="OrderItem_id"
                GridLines="None"
                OnRowCommand="ImportedStatusesView_RowCommand" 
                ondatabound="ImportedStatusesView_DataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Заказ/строка" SortExpression="OrderLine">
                        <ItemTemplate>
                            <asp:Label ID="OrderLineLabel" runat="server" Text='<%# Bind("OrderLine") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="OrderLineLabel" runat="server" Text='<%# Bind("OrderLine") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Клиент" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:Label ID="CustomerNameLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="CustomerNameLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Каталог" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Артикул" SortExpression="Article_id">
                        <ItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" SortExpression="ArticleName">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Bind("Comment") %>' Text='<%# Bind("ArticleName") %>'></asp:HyperLink>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Bind("Comment") %>' Text='<%# Bind("ArticleName") %>'></asp:HyperLink>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Статус артикула" SortExpression="KtradeStatusDescription">
                        <ItemTemplate>
                            <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit" Text='<%# Bind("KtradeStatusDescription") %>'></asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="KtradeStatusDropDownList" runat="server" DataSourceID="KtradeStatusesSource" DataTextField="KtradeStatusDescription" DataValueField="KtradeStatus_id" SelectedValue='<%# Bind("KtradeStatus") %>'></asp:DropDownList>
                            <asp:ImageButton ID="OKButton2" runat="server" CommandName="Update" ImageUrl="~/Images/Buttons/OK16.png" Title="OK" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Удалить" SortExpression="Comment">
                        <ItemTemplate>
                            <asp:ImageButton ID="DeleteLineButton" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("ImportedLine_id") %>' ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Удалить" />
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:FileUpload ID="ImportFile" runat="server" />
    <asp:Button ID="UploadFileButton" runat="server" Text="Загрузить" />
    <asp:Label ID="Indicator" runat="server" Text=""></asp:Label>
    <asp:UpdatePanel ID="ButtonsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:CheckBox ID="NotifyCheckBox" runat="server" Text="Разослать уведомления покупателям" Checked="True" Enabled="false" />
            <br />
            <asp:Button ID="ConfirmImportButton" runat="server" Text="Подтвердить" CausesValidation="false" OnClick="ConfirmImportButton_Click" Enabled="false" />
            <asp:Button ID="CancelImportButton" runat="server" Text="Отменить" CausesValidation="false" OnClick="CancelImportButton_Click" Enabled="false" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="ImportDataUpdateProgress" runat="server" AssociatedUpdatePanelID="ImportedDataUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdateProgress ID="ButtonsUpdateProgress" runat="server" AssociatedUpdatePanelID="ButtonsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImageII" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


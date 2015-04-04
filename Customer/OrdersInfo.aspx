<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="OrdersInfo.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - заказы в работе</title>
    <link rel="Stylesheet" href="../css/Account.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="ActiveOrdersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
                O.id as id,
                MAX (O.CreationDate) as CreationDate,
                COUNT (OI.id) as LineCount,
                ROUND (SUM(OI.Price * Ca.PriceIndex), 2) as Amount,
                MAX (O.OrderStatus) as OrderStatus,
                MAX (ISNULL (OS.StatusDescription, 'Статус не определен')) as StatusDescription
            from
                Orders as O with (nolock)
                join OrderStatuses as OS with (nolock) on OS.Status_id = O.OrderStatus
                join OrderItems as OI with (nolock) on OI.Order_id = O.id
                left join Catalogues as Ca with (nolock) on Ca.Catalogue_id = OI.Catalogue_id
            where   
                O.Customer_id = @Customer_id
            group by
                O.Customer_id,
                O.id        ,
                O.OrderStatus
            having
                MAX (O.OrderStatus) in (0,1,2)
            order by
                O.id desc"
            UpdateCommand="UPDATE [Orders] SET [OrderStatus] = @OrderStatus WHERE [id] = @id">
        <%--<UpdateParameters>
            <asp:Parameter Name="OrderStatus" Type="Int32" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>--%>
        <SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="OrderStatusesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT Status_id, StatusDescription FROM [OrderStatuses]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="OrderDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                OI.id as Line_id,
                OI.Order_id,
                C.CatalogueName,
                OI.Article_id,
                OI.ArticleName,
                OI.Price,
                OI.Size,
                OI.Colour,
                OI.Comment,
                OI.KtradeStatus_id,
                KS.KtradeStatusDescription
            from
                OrderItems as OI
                join Catalogues as C on C.Catalogue_id = OI.Catalogue_id
                join KtradeStatuses as KS on KS.KtradeStatus_id = OI.KtradeStatus_id	
            where
	            Order_id = @Order_id
            order by
                OI.id asc"
            UpdateCommand="update OrderItems set KtradeStatus_id = @KtradeStatus_id where id = @Line_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActiveOrdersGridView" Name="Order_id" PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="KtradeStatus_id" />
            <asp:Parameter Name="Line_id" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="KtradeStatusesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT KtradeStatus_id, KtradeStatusDescription FROM [KtradeStatuses]"></asp:SqlDataSource>
    
    <h2>Заказы в работе:</h2>
    <asp:UpdatePanel ID="OrderListUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="ActiveOrdersGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="ActiveOrdersSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="15"
                onselectedindexchanged="ActiveOrdersGridView_SelectedIndexChanged"
                >
                <Columns>
                    <asp:TemplateField HeaderText="№ заказа" InsertVisible="False" SortExpression="id">
                        <ItemTemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select" Text='<%# Bind("id") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Дата создания" SortExpression="CreationDate">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("CreationDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Количество позиций" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("LineCount") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Сумма заказа" SortExpression="Amount">
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("Amount", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Статус заказа" SortExpression="StatusDescription">
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Bind("StatusDescription") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <SelectedRowStyle BackColor="#FFFF66" />
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <h3>Детали выбранного заказа:</h3>
    <asp:UpdatePanel ID="OrderDetailsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="OrderDetailsGridView" runat="server"
                GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="Line_id"
                DataSourceID="OrderDetailsSource" 
                EnableModelValidation="True"
                OnRowcommand="OrderDetailsGridView_RowCommand"
                ondatabound="OrderDetailsGridView_DataBound"
                >
                <Columns>
                    <%--<asp:TemplateField HeaderText="ID" SortExpression="Line_id">
                        <ItemTemplate>
                            <asp:Label ID="LineIDLabel" runat="server" Text='<%# Bind("Line_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>--%>
                    <asp:TemplateField HeaderText="Каталог" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="CatalogueLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Артикул" SortExpression="Article_id">
                        <ItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" SortExpression="ArticleName">
                        <ItemTemplate>
                            <a href='<%# Eval("Comment") %>' target="_blank"><%# Eval("ArticleName") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Размер" SortExpression="Size">
                        <ItemTemplate>
                            <asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цвет" SortExpression="Colour">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("Colour") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Статус артикула" SortExpression="StatusDescription">
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Bind("KtradeStatusDescription") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <ItemTemplate>
                            <asp:ImageButton ID="ReorderLine" runat="server" CommandName="ReorderLine" CommandArgument='<%# Bind("Line_id") %>' ImageUrl="~/Images/Buttons/Reorder16.png" CausesValidation="false" Title="Перезаказать" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <p><asp:Label ID="EmptyOrderLabel" runat="server" Text="Заказ не выбран или пуст"></asp:Label></p>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderListUpdateProgress" runat="server" AssociatedUpdatePanelID="OrderListUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderListLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="OrderDetailsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


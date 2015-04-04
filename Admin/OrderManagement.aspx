<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderManagement.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - управление заказами</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="ActiveOrdersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
                O.Customer_id,
                O.id as id,
                case
		    when O.Customer_id = -1 then MAX(OMD.CustomerFullName) + ' (б/р)'
		    else MAX (C.FirstName) + ' ' + MAX (C.LastName)
		    end as CustomerName,
                MAX (O.CreationDate) as CreationDate,
                COUNT (OI.id) as LineCount,
                O.OrderStatus,
                MAX (ISNULL (OS.StatusDescription, 'Статус не определен')) as StatusDescription
            from
                Orders as O with (nolock)
                join OrderStatuses as OS with (nolock) on OS.Status_id = O.OrderStatus
                join OrderItems as OI with (nolock) on OI.Order_id = O.id
                left join Customers as C with (nolock) on C.Customer_id = O.Customer_id
                left join OrdersMetaData as OMD with (nolock) on OMD.Order_id = O.id
            where
                O.OrderStatus in (0,1,2)
                and O.id = case when @Order_id = -1 then O.id else @Order_id end
            group by
                O.Customer_id,
                O.id,
                O.OrderStatus
            order by
                O.id"
            UpdateCommand="UPDATE [Orders] SET [OrderStatus] = @OrderStatus WHERE [id] = @id">
        <SelectParameters>
            <asp:ControlParameter ControlID="Order_Search_Input" Name="Order_id" Type="String" PropertyName="Text" DefaultValue="-1" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="OrderStatus" Type="Int32" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
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
    <asp:SqlDataSource ID="OrderMetaDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
		Order_id,
		CustomerEmail,
		CustomerPhone,
		case DeliveryMethod
		when 0 then 'Самовывоз'
		when 1 then 'Курьерская: ' + DeliveryAddress
		end as DeliveryAddress,
		case PaymentMethod
		when 0 then 'Наличными'
		when 1 then 'Qiwi'
		when 2 then 'eComCharge'
		when 3 then 'KazCom'
		end as PaymentMethod
	    from 
		OrdersMetaData as OMD
	    where
		Order_id = @Order_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="ActiveOrdersGridView" Name="Order_id" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="KtradeStatusesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="SELECT KtradeStatus_id, KtradeStatusDescription FROM [KtradeStatuses]"></asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Заказы в работе: <asp:TextBox ID="Order_Search_Input" runat="server" placeholder="Поиск по номеру" class="suchen"></asp:TextBox><asp:Button ID="SuchenMachen" runat="server" Text=">>" onclick="SuchenMachenButton_Click" ></asp:Button></h2>
    
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
                onrowcommand="ActiveOrdersGridView_RowCommand"
                onselectedindexchanged="ActiveOrdersGridView_SelectedIndexChanged"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Номер заказа" SortExpression="id">
                        <EditItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="OrderSelectButton" runat="server" CausesValidation="False" CommandName="Select" Text='<% #Bind("id") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Покупатель" SortExpression="CustomerName">
                        <EditItemTemplate>
                            <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
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
                    <asp:TemplateField HeaderText="Количество позиций" SortExpression="LineCount">
                        <EditItemTemplate>
                            <asp:Label ID="PositionCountLabel" runat="server" Text='<%# Bind("LineCount") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="PositionCountLabel" runat="server" Text='<%# Bind("LineCount") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Статус заказа" SortExpression="OrderStatus">
                        <EditItemTemplate>
                            <asp:DropDownList ID="OrderStatusDropDownList" runat="server" DataSourceID="OrderStatusesSource" DataTextField="StatusDescription" DataValueField="Status_id" SelectedValue='<%# Bind("OrderStatus") %>'></asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="OrderStatusUpdateButton" runat="server" CausesValidation="False" CommandName="Edit" Text='<%# Bind("StatusDescription") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <EditItemTemplate>
                            <asp:ImageButton ID="OKButton" runat="server" CommandName="Update" ImageUrl="~/Images/Buttons/OK16.png" Title="OK" />
                            <asp:ImageButton ID="CancelButton" runat="server" CommandName="Cancel" ImageUrl="~/Images/Buttons/Cancel16.png" Title="Отмена" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" CommandName="GetTAB" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/SaveFileMaker16.png" Title="Экспорт для FileMaker" />
                            <asp:ImageButton ID="NotifyButton" runat="server" CommandName="NotifyCustomer" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Letter16.png" Title="Подтверждение статуса заказа по почте" />
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
                ondatabound="OrderDetailsGridView_DataBound"
                >
                <Columns>
                    <asp:TemplateField HeaderText="ID" SortExpression="Line_id">
                        <EditItemTemplate>
                            <asp:Label ID="LineIDLabel" runat="server" Text='<%# Bind("Line_id") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="LineIDLabel" runat="server" Text='<%# Bind("Line_id") %>'></asp:Label>
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
                            <a href='<%# Eval("Comment") %>' target="_blank"><%# Eval("ArticleName") %></a>
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
                    <asp:TemplateField HeaderText="Размер" SortExpression="Size">
                        <EditItemTemplate>
                            <asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цвет" SortExpression="Colour">
                        <EditItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("Colour") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("Colour") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Статус артикула" SortExpression="StatusDescription">
                        <EditItemTemplate>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="KtradeStatusesSource" DataTextField="KtradeStatusDescription" DataValueField="KtradeStatus_id" SelectedValue='<%# Bind("KtradeStatus_id") %>'></asp:DropDownList>
                            <asp:ImageButton ID="OKButton2" runat="server" CommandName="Update" ImageUrl="~/Images/Buttons/OK16.png" Title="OK" />
                            <asp:ImageButton ID="CancelButton2" runat="server" CommandName="Cancel" ImageUrl="~/Images/Buttons/Cancel16.png" Title="Отмена" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit" Text='<%# Bind("KtradeStatusDescription") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
	    <br/>
	    <asp:GridView ID="OrderMetaDataGridView" runat="server"
                GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="Order_id"
                DataSourceID="OrderMetaDataSource" 
                >
		<Columns>
		    <asp:TemplateField HeaderText="Email" SortExpression="CustomerEmail">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("CustomerEmail") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Телефон" SortExpression="CustomerPhone">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("CustomerPhone") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Доставка" SortExpression="DeliveryAddress">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("DeliveryAddress") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Оплата" SortExpression="PaymentMethod">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("PaymentMethod") %>'></asp:Label>
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
    <div class="download">
        <p>Выгрузить все:</p>
        <asp:ImageButton ID="KtradeExportTotalButton" runat="server" ImageUrl="~/Images/Buttons/SaveFileMakertotal.png" Title="Экспорт для FileMaker" onclick="KtradeExportTotalButton_Click" />
    </div>
    <div class="download">
        <p>Выгрузить новое:</p>
        <asp:ImageButton ID="KtradeExportNewButton" runat="server" ImageUrl="~/Images/Buttons/SaveFileMakertotal.png" Title="Экспорт для FileMaker" onclick="KtradeExportNewButton_Click" />
    </div>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="Account.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - заказы в работе</title>
    <link rel="Stylesheet" href="../css/Account.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="ActiveOrdersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select top 5
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
    <asp:SqlDataSource ID="PaymentsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select top 5
				P.id,
                P.payment_num,
				P.PaymentTime,
				P.PaymentSystem,
				P.Ammount,
                P.Committed
			from
				PaymentsView as P
			where
				P.Customer_id = @Customer_id
			order by
				P.PaymentTime desc">
		<SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="CouponsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select top 5
		    DC.id,
		    DC.Number,
		    left (convert (nvarchar(10), (DC.DiscountValue - 1) * 100), len(convert (nvarchar(10), (DC.DiscountValue - 1) * 100)) - 3) + '%' as Discount,
		    DC.IssueTime,
		    dateadd(dd, 7, DC.IssueTime) as DeadLine,
		    dbo.TimeLeft (dateadd(dd, DC.DurationDays, DC.IssueTime)) as Status
	    from
		    DiscountCoupons as DC with (nolock)
	    where
		    DC.Customer_id = @Customer_id
		    and dateadd(dd, DC.DurationDays, DC.IssueTime) > GetDate()
		    and DC.Order_id is null
	    order by
		    DC.IssueTime desc">
	<SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <h1>Личный кабинет</h1>
    <h2>Заказы в работе:</h2>
    <asp:GridView ID="ActiveOrdersGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataKeyNames="id"
	DataSourceID="ActiveOrdersSource" 
	EnableModelValidation="True"
	AllowSorting="False"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	PageSize="15"
	ondatabound="OrderListDataBound"
	>
	<Columns>
	    <asp:TemplateField HeaderText="№ заказа" InsertVisible="False" SortExpression="id">
		<ItemTemplate>
		    <asp:Label ID="Label1" runat="server" Text='<%# Bind("id") %>'></asp:Label>
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
    <p><asp:Label ID="NoOrderLabel" runat="server" Text="Нет заказов в работе"></asp:Label><asp:HyperLink ID="OrdersInfoLink" runat="server" NavigateUrl="~/Customer/OrdersInfo.aspx">Подробная информация о заказах в работе >>></asp:HyperLink></p>
    <h2>Платежи</h2>
    <asp:GridView ID="PaymentsGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataKeyNames="id"
	DataSourceID="PaymentsSource" 
	EnableModelValidation="True"
	AllowSorting="False"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	PageSize="25"
	ondatabound="PaymentsListDataBound"
	>
	<Columns>
	    <asp:TemplateField HeaderText="Дата платежа" SortExpression="PaymentTime">
		<ItemTemplate>
		    <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("PaymentTime", "{0:f}") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Платежная система" SortExpression="PaymentSystem">
		<ItemTemplate>
		    <asp:Label ID="PaymetnSystemLabel" runat="server" Text='<%# Eval("PaymentSystem") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>                    
		<asp:TemplateField HeaderText="Сумма" SortExpression="Ammount">
		<ItemTemplate>
		    <asp:Label ID="AmmountLabel" runat="server" Text='<%#Bind("Ammount", "{0:f2}")%>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	</Columns>
    </asp:GridView>
    <p><asp:Label ID="NoPaymentLabel" runat="server" Text="Нет платежей"></asp:Label><asp:HyperLink ID="PaymentInfoLink" runat="server" NavigateUrl="~/Customer/AllPaymentsHistory.aspx">Подробная информация о платежах >>></asp:HyperLink></p>
    <h2>Купоны на скидку</h2>
    <asp:GridView ID="CouponsGridView" runat="server" GridLines="None"
	AutoGenerateColumns="False"
	DataKeyNames="id"
	DataSourceID="CouponsSource" 
	EnableModelValidation="True"
	AllowSorting="False"
	AllowPaging="False"
	PagerSettings-Mode="NumericFirstLast"
	PageSize="25"
	ondatabound="CouponsListDataBound"
	>
	<Columns>
	    <asp:TemplateField HeaderText="Номер" SortExpression="Number">
		<ItemTemplate>
		    <asp:Label ID="ContractLabel" runat="server" Text='<%# Bind("Number") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Размер скидки" SortExpression="Discount">
		<ItemTemplate>
		    <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("Discount") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	    <asp:TemplateField HeaderText="Статус" SortExpression="Status">
		<ItemTemplate>
		    <asp:Label ID="UsageLabel" runat="server" Text='<%# Bind("Status") %>'></asp:Label>
		</ItemTemplate>
	    </asp:TemplateField>
	</Columns>
    </asp:GridView>
    <p><asp:Label ID="NoCouponsLabel" runat="server" Text="Нет купонов на скидку"></asp:Label><asp:HyperLink ID="CouponsInfoLink" runat="server" NavigateUrl="~/Customer/MyDiscountCoupons.aspx">Подробная информация о скидочных купонах >>></asp:HyperLink></p>
</asp:Content>


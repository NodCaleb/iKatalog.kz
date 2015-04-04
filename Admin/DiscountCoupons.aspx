<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="DiscountCoupons.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - скидочные купоны</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CouponsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
		    DC.id,
		    DC.Number,
		    case
			when DC.Customer_id = -1 then 'Неименной купон'
			else C.FirstName + ' ' + C.LastName
			end as CustomerName,
		    left (convert (nvarchar(10), (DC.DiscountValue - 1) * 100), len(convert (nvarchar(10), (DC.DiscountValue - 1) * 100)) - 3) + '%' as Discount,
		    DC.IssueTime,
		    dateadd(dd, DC.DurationDays, DC.IssueTime) as DeadLine,
		    case when O.id is not null then 'Заказ № ' + convert (nvarchar(6), O.id) + ' от ' + convert(nvarchar(10), convert (date, O.CreationDate)) 
		    else case when dateadd(dd, DC.DurationDays, DC.IssueTime) < GetDate() then 'Просрочен' else 'Нет' end
		    end as Usage
	    from
		    DiscountCoupons as DC with (nolock)
		    left join Customers as C with (nolock) on DC.Customer_id = C.Customer_id
		    left join Orders as O with (nolock) on DC.Order_id = O.id
	    order by
		    DC.IssueTime desc">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="CustomersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
		    -1 as Customer_id,
		    'Не именной' as FullName,
		    '' as SortName
	    union
	    select
		    Customer_id,
		    FirstName + ' ' + LastName as FullName,
		    FirstName + ' ' + LastName as SortName
	    from
		    Customers
	    order by
		    SortName">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Скидочные купоны:</h2>
    <div class="validationsummary">
	<asp:ValidationSummary ID="CouponValidationSummary" runat="server" ValidationGroup="CouponValidationGroup" />
	<asp:ValidationSummary ID="WarningValidationSummary" runat="server" ValidationGroup="WarningValidationGroup" />
	<asp:ValidationSummary ID="ActivationValidationSummary" runat="server" ValidationGroup="AcrivationValidationGroup" />
    </div>
    
    <h3>Выдать купон</h3>
    <asp:DropDownList ID="CustomerList" runat="server" DataSourceID="CustomersSource" DataTextField="FullName" DataValueField="Customer_id"></asp:DropDownList>
    <asp:TextBox ID="DiscountValueInput" runat="server" placeholder="Размер скидки в %"></asp:TextBox>
    <asp:TextBox ID="DurationInput" runat="server" placeholder="Срок действия в днях"></asp:TextBox>
    <asp:Button ID="CraftCouponButton" runat="server" Text="OK" OnClick="CraftCouponButton_Click" ValidationGroup="CouponValidationGroup" />
    
    <asp:RequiredFieldValidator ID="DiscountValueRequiredValidator" runat="server" ErrorMessage="Не заполнена величина скидки" Display="None" ValidationGroup="CouponValidationGroup" ControlToValidate="DiscountValueInput"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DiscountValueExpressionValidator" runat="server" ErrorMessage="Только целые числа, будьте добры" Display="None" ValidationExpression="[0-9]+" ValidationGroup="CouponValidationGroup" ControlToValidate="DiscountValueInput"></asp:RegularExpressionValidator>
    <asp:RequiredFieldValidator ID="DurationRequiredValidator" runat="server" ErrorMessage="Не заполнен срок действия" Display="None" ValidationGroup="CouponValidationGroup" ControlToValidate="ActivationDurationInput"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="DurationExpressionValidator" runat="server" ErrorMessage="Только целые числа, будьте добры" Display="None" ValidationExpression="[0-9]+" ValidationGroup="CouponValidationGroup" ControlToValidate="ActivationDurationInput"></asp:RegularExpressionValidator>
    
    <h3>Выдать активационные купоны</h3>
    <p>Купоны выдаются всем, кто ни разу не заказывал и у кого нет действующих купонов,<br/>уведомления высылаются автоматически</p>
    <asp:TextBox ID="ActivationDiscountValueInput" runat="server" placeholder="Размер скидки в %"></asp:TextBox>
    <asp:TextBox ID="ActivationDurationInput" runat="server" placeholder="Срок действия в днях"></asp:TextBox>
    <asp:Button ID="GenerateActivationCouponsButton" runat="server" Text="OK" OnClick="GenerateActivationCoupons" ValidationGroup="AcrivationValidationGroup" />
    
    <asp:RequiredFieldValidator ID="ActiovationDiscountValueRequiredValidator" runat="server" ErrorMessage="Не заполнена величина скидки" Display="None" ValidationGroup="AcrivationValidationGroup" ControlToValidate="ActivationDiscountValueInput"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="ActiovationDiscountValueExpressionValidator" runat="server" ErrorMessage="Только целые числа, будьте добры" Display="None" ValidationExpression="[0-9]+" ValidationGroup="AcrivationValidationGroup" ControlToValidate="ActivationDiscountValueInput"></asp:RegularExpressionValidator>
    <asp:RequiredFieldValidator ID="ActiovationDurationRequiredValidator" runat="server" ErrorMessage="Не заполнен срок действия" Display="None" ValidationGroup="AcrivationValidationGroup" ControlToValidate="ActivationDurationInput"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="ActiovationDurationExpressionValidator" runat="server" ErrorMessage="Только целые числа, будьте добры" Display="None" ValidationExpression="[0-9]+" ValidationGroup="AcrivationValidationGroup" ControlToValidate="DurationInput"></asp:RegularExpressionValidator>
    
    <h3>Выслать массовое уведомление об оставшемся сроке действия</h3>
    <asp:TextBox ID="LeftDurationInput" runat="server" placeholder="Остаточный срок в днях"></asp:TextBox>
    <asp:Button ID="SendWarningButton" runat="server" Text="OK" OnClick="SendWarning" ValidationGroup="WarningValidationGroup" />
    <asp:RequiredFieldValidator ID="LeftDurationRequiredValidator" runat="server" ErrorMessage="Не заполнен остаточный срок" Display="None" ValidationGroup="WarningValidationGroup" ControlToValidate="LeftDurationInput"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="LeftDurationExpressionValidator" runat="server" ErrorMessage="Только целые числа, будьте добры" Display="None" ValidationExpression="[0-9]+" ValidationGroup="WarningValidationGroup" ControlToValidate="LeftDurationInput"></asp:RegularExpressionValidator>
    
    <h3>Выданные купоны</h3>
    <asp:UpdatePanel ID="CouponsListUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="CouponsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="CouponsSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="100"
		onrowcommand="CouponsGridView_RowCommand"
                >
                <Columns>
		    <asp:TemplateField HeaderText="Номер" SortExpression="Number">
                        <ItemTemplate>
                            <asp:Label ID="ContractLabel" runat="server" Text='<%# Bind("Number") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Покупатель" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Размер скидки" SortExpression="Discount">
                        <ItemTemplate>
                            <asp:Label ID="ValueLabel" runat="server" Text='<%# Bind("Discount") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Дата выдачи" SortExpression="IssueTime">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("IssueTime", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Срок действия" SortExpression="IssueTime">
                        <ItemTemplate>
                            <asp:Label ID="DeadLineLabel" runat="server" Text='<%# Bind("DeadLine", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Использован" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="UsageLabel" runat="server" Text='<%# Bind("Usage") %>'></asp:Label>
                        </ItemTemplate>
		    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Действия" SortExpression="Number">
                        <ItemTemplate>
                            <asp:ImageButton ID="NotifyButton" runat="server" CommandName="NotifyCustomer" CommandArgument='<%# Bind("Number") %>' ImageUrl="~/Images/Buttons/Letter16.png" Title="Уведомить покупателя о выдаче купона" />
                        </ItemTemplate>
		    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="CouponsListUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


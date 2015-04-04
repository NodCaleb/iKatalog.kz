<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="MyDiscountCoupons.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - скидочные купоны</title>
    <link rel="Stylesheet" href="../css/Account.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CouponsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
		    DC.id,
		    DC.Number,
		    left (convert (nvarchar(10), (DC.DiscountValue - 1) * 100), len(convert (nvarchar(10), (DC.DiscountValue - 1) * 100)) - 3) + '%' as Discount,
		    DC.IssueTime,
		    dateadd(dd, DC.DurationDays, DC.IssueTime) as DeadLine,
		    case
			    when O.id is null then dbo. TimeLeft (dateadd(dd, DC.DurationDays, DC.IssueTime))
			    else 'Использован для заказа №' + convert (nvarchar(6), O.id) + ' от ' + convert(nvarchar(10), convert (date, O.CreationDate))
		    end as Status
	    from
		    DiscountCoupons as DC with (nolock)
		    left join Orders as O with (nolock) on DC.Order_id = O.id
	    where
		    DC.Customer_id = @Customer_id
	    order by
		    DC.IssueTime desc">
	<SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <h2>Скидочные купоны:</h2>
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
                PageSize="25"
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


<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ZPaymentsLog.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - платежи Z-Payment</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="ZPaymentsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
			  Z.id,
			  substring('000000',1,6-len(Z.id)) + convert (nvarchar(6), Z.id) as PaymentNumber,
			  Z.PaymentTime,
			  C.FirstName + ' ' + C.LastName as CustomerName,
			  substring('000000',1,6-len(C.Customer_id)) + convert (nvarchar(6), C.customer_id) as ContractNumber,
			  C.Alias,
				Z.Ammount
			from
			  ZPayments as Z
			  join Customers as C with (nolock) on C.Customer_id = Z.Customer_id
			where
			  Z.Committed = 1
			order by
			  Z.PaymentTime desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Платежи Z-Payment:</h2>
    <asp:UpdatePanel ID="PaymentsListUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="ZPaymentsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="ZPaymentsSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="25"
                >
                <Columns>
					<asp:TemplateField HeaderText="Номер платежа" SortExpression="PaymentNumber">
                        <ItemTemplate>
                            <asp:Label ID="NumberLabel" runat="server" Text='<%# Bind("PaymentNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
					<asp:TemplateField HeaderText="Дата платежа" SortExpression="PaymentTime">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("PaymentTime", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Покупатель" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                    <asp:TemplateField HeaderText="Номер договора" SortExpression="ContractNumber">
                        <ItemTemplate>
                            <asp:Label ID="ContractLabel" runat="server" Text='<%# Bind("ContractNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Псевдоним" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="AliasLabel" runat="server" Text='<%# Bind("Alias") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
					<asp:TemplateField HeaderText="Сумма" SortExpression="Ammount">
                        <ItemTemplate>
                            <asp:Label ID="AmmountLabel" runat="server" Text='<%# Bind("Ammount", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="PaymentsListUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


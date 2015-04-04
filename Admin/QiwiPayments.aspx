<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="QiwiPayments.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - платежи Qiwi</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="PaymentsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
				P.id,
				P.txn_date,
				C.FirstName + ' ' + C.LastName as CustomerName,
				substring('000000',1,6-len(C.Customer_id)) + convert (nvarchar(6), C.customer_id) as ContractNumber,
				C.Alias,
				P.Ammount
			from
				Payments as P with (nolock)
				join Customers as C with (nolock) on C.Customer_id = P.Customer_id
			order by
				P.txn_date desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Платежи Qiwi:</h2>
    <asp:UpdatePanel ID="PaymentsListUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="PaymentsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="PaymentsSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="25"
                >
                <Columns>
					<asp:TemplateField HeaderText="Дата платежа" SortExpression="CreationDate">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("txn_date", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Покупатель" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:Label ID="CustomerLabel" runat="server" Text='<%# Bind("CustomerName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                    <asp:TemplateField HeaderText="Номер договора" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="ContractLabel" runat="server" Text='<%# Bind("ContractNumber") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
					<asp:TemplateField HeaderText="Псевдоним" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="AliasLabel" runat="server" Text='<%# Bind("Alias") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
					<asp:TemplateField HeaderText="Сумма" SortExpression="LineCount">
                        <ItemTemplate>
                            <asp:Label ID="AmmountLabel" runat="server" Text='<%# Bind("Ammount", "{0:#,# 〒}") %>'></asp:Label>
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


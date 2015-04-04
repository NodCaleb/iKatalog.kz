<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesOrders.master" AutoEventWireup="true" CodeFile="EcomPaymentsHistory.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - история платежей Woopay</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="PaymentsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
				P.tracking_id,
				P.PaymentTime,
				P.Customer_id,
				P.Ammount,
                P.transaction_uid,
                P.Committed
			from
				EComChargePayments as P
			order by
				P.PaymentTime desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>История платежей:</h2>
    <p>Внимание — здесь отображаются только платежи через платежнeную систему Woopay</p>
    <p>Чтобы получить полную информацию о ваших платежах и текущем балансе вы можете запросить акт сверки у офис-менеджера.</p>
    <asp:UpdatePanel ID="PaymentsListUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="PaymentsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="tracking_id"
                DataSourceID="PaymentsSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="25"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Номер платежа" SortExpression="tracking_id">
                        <ItemTemplate>
                            <asp:Label ID="tracking_id" runat="server" Text='<%# Bind("tracking_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Id пользователя" SortExpression="Customer_id">
                        <ItemTemplate>
                            <asp:Label ID="Customer_id" runat="server" Text='<%# Bind("Customer_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Номер платежа eComCharge" SortExpression="Woopay_id">
                        <ItemTemplate>
                            <asp:Label ID="transaction_uid" runat="server" Text='<%# Bind("transaction_uid") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
					<asp:TemplateField HeaderText="Дата платежа" SortExpression="PaymentTime">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("PaymentTime", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                   	<asp:TemplateField HeaderText="Сумма" SortExpression="Ammount">
                        <ItemTemplate>
                            <asp:Label ID="AmmountLabel" runat="server" Text='<%# Bind("Ammount", "{0:#,# 〒}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Состояние платежа" SortExpression="Committed">
                        <ItemTemplate>
                            <asp:Label ID="PaymentState" runat="server" Text='<%#String.Compare(Convert.ToString(Eval("Committed")),"True",true)==0?"Подтвержден":"Не подтвержен"%>'></asp:Label>                            
                            <!--<asp:Label ID="PaymentValidate" Visible='<%#((String.Compare(Convert.ToString(Eval("Committed")),"True",true)==0) || (Convert.ToString(Eval("transaction_uid")).Length<1))?false:true%>' runat="server" Text='<%#String.Format("<a href=ProcessEcom.aspx?result=fail&tracking_id={0}>Подтвердить?</a>",Eval("tracking_id"))%>'></asp:Label>-->
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <p><b><asp:Label ID="EmptyOrderLabel" runat="server" Text="Платежи отсутствуют"></asp:Label></b></p>
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


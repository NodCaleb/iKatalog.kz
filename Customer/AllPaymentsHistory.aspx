<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="AllPaymentsHistory.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - история платежей</title>
    <link rel="Stylesheet" href="../css/Account.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="PaymentsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="        
            select
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
    
    <h2>История платежей:</h2>
    <p>Внимание — здесь отображаются только платежи через платежные системы, платежи наличными в офисе и переводы на карту — здесь не отражены</p>
    <p>Чтобы получить полную информацию о ваших платежах и текущем балансе вы можете запросить акт сверки у офис-менеджера.</p>
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
					<asp:TemplateField HeaderText="Дата платежа" SortExpression="PaymentTime">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("PaymentTime", "{0:f}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
  					<asp:TemplateField HeaderText="Номер платежа" SortExpression="payment_num">
                        <ItemTemplate>
                            <asp:Label ID="PaymentNum" runat="server" Text='<%# Eval("payment_num") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Платежная система" SortExpression="PaymentSystem">
                        <ItemTemplate>
                            <asp:Label ID="PaymetnSystemLabel" runat="server" Text='<%# Eval("PaymentSystem") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                   	<asp:TemplateField HeaderText="Сумма за вычетом комиссии" SortExpression="Ammount">
                        <ItemTemplate>
                            <asp:Label ID="AmmountLabel" runat="server" Text='<%#Bind("Ammount", "{0:f2}")%>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Состояние платежа" SortExpression="Committed">
                        <ItemTemplate>
                            <asp:Label ID="PaymentState" runat="server" Text='<%#String.Compare(Convert.ToString(Eval("Committed")),"1",true)==0?"Подтвержден":"Не подтвержен"%>'></asp:Label>
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


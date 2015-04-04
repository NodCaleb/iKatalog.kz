<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="EuroXrateHistory.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - курс евро</title>
    <link rel="Stylesheet" href="../css/Account.css" />
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="XrateSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select Date, MAX(Xrate) as Xrate from Xrates group by Date order by Date desc">
    </asp:SqlDataSource>
    <h1>Курс евро:</h1>
    <p>Поскольку мы доставляем ваши заказы из Европы, их стоимость напрямую зависит от курса евро. Мы со своей стороны не только ежедневно корректируем рабочий курс в соответствии с изменениями официального курса Национального Банка Республики Казахстан, но и собираем статистическую информацию о коллебаниях курса.</p>
    <p>На этой странице мы решили поделиться с вами накопленной информацией.</p>
    <h3>Рабочий курс € на сегодня: <asp:Label ID="XrateLabel" runat="server" Text=""></asp:Label> &#8376;</h3>
    <h2>График курса € за прошедший квартал</h2>
	<asp:Literal ID="lt" runat="server"></asp:Literal>
        <div id="chart_div"></div>
    <h2>История курса €</h2>
    <asp:UpdatePanel ID="XrateHistoryUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="XrateGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="Date"
                DataSourceID="XrateSource" 
                EnableModelValidation="True"
                AllowSorting="True"
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="91"
                >
		<pagersettings mode="NumericFirstLast"
		    firstpagetext="Первая"
		    lastpagetext="Последняя"
		    PageButtonCount="20"
		    position="Bottom"/> 
                <Columns>
		    <asp:TemplateField HeaderText="Дата" SortExpression="Date">
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Курс" SortExpression="Xrate">
                        <ItemTemplate>
                            <asp:Label ID="XrateLabelTable" runat="server" Text='<%# Bind("Xrate", "{0:#,#.00 &#8376;}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="XrateUpdateProgress" runat="server" AssociatedUpdatePanelID="XrateHistoryUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="XrateLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


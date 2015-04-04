<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="OrdersPry.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - что заказывают люди...</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
    <link rel="Stylesheet" href="../css/Pry.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<asp:SqlDataSource ID="PrySource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select top 50
			dbo.TimePassed (OI.CreationDate) as [TimePassed],
			'http://ikatalog.kz/Images/Logos/' +  C.ImageLink as [ImageLink],
			C.CatalogueName,
			left (OI.ArticleName, 25) as ArticleName,
			OI.Price,
			OI.Comment,
			'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue='+ convert (nvarchar(5), OI.Catalogue_id) + '&article=' + OI.Article_id + '&name=' + OI.ArticleName +'&price=' + REPLACE (convert(nvarchar(10),OI.Price), '.', ',') + '&size=' + OI.Size + '&color=' + OI.Colour + '&URL=' + REPLACE (OI.Comment, 'http://', '') as OrderURL   
		from
			OrderItems as OI
			join Orders as O on OI.Order_id = O.id
			join Catalogues as C on OI.Catalogue_id = C.Catalogue_id
			    
		where
			order_id <> -1
			and O.OrderStatus <> -1
		order by
			  OI.id desc">
    </asp:SqlDataSource>
	
	<asp:Timer ID="UpdateTimer" runat="server" OnTick="UpdateTimer_Tick" Interval="60000" Enabled="True"></asp:Timer>
	<h2>Что заказывают люди:</h2>
	<asp:UpdatePanel ID="PryUpdatePanel" runat="server">
		<Triggers>
			<asp:AsyncPostBackTrigger ControlID="UpdateTimer" EventName="Tick" />
		</Triggers>
		<ContentTemplate>
			<asp:GridView ID="PryGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataSourceID="PrySource" 
                EnableModelValidation="True"
                >
                <Columns>                    
                    <asp:TemplateField HeaderText="Откуда" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <img src='<%# Eval("ImageLink") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Что" SortExpression="ArticleName">
                        <ItemTemplate>
                            <asp:HyperLink ID="DsicountLink" runat="server" NavigateUrl='<%# Eval("Comment") %>' target="_blank">
                                <asp:Label ID="ArticleNameLabel" runat="server" Text='<%# Eval("ArticleName") %>'></asp:Label>
                            </asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <%-- asp:TemplateField HeaderText="Когда" SortExpression="TimePassed">
                        <ItemTemplate>
                            <asp:Label ID="TimePassedLabel" runat="server" Text='<%# Eval("TimePassed") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField --%>
                    <asp:TemplateField HeaderText="Почем" SortExpression="Price">
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="" SortExpression="Price">
                        <ItemTemplate>
							<asp:HyperLink ID="OrderLink" class="CTA" runat="server" NavigateUrl='<%# Eval("OrderURL") %>' target="_blank">Заказать себе!</asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
		</ContentTemplate>
	</asp:UpdatePanel>
</asp:Content>


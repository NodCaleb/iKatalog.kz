<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="TestimonialManagement.aspx.cs" Inherits="Admin_DicountManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - скидики и акции</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="TestimonialsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="select * from TestimonialsView order by CreationDate desc">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h2>Отзывы клиентов</h2>

        
    <asp:UpdatePanel ID="TestimonialsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="TestimonialsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="TestimonialsSource" 
                EnableModelValidation="True"
		AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="20"
                OnRowCommand="TestimonialsView_RowCommand"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Дата" SortExpression="id">
                        <ItemTemplate>
                            <asp:Label ID="CreationDateLabel" runat="server" Text='<%# Bind("CreationDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Клиент" SortExpression="CustomerName">
                        <ItemTemplate>
                            <asp:Label ID="NameLabel" runat="server" Text='<%# Bind("Name") %>'></asp:Label><br/>
			    <asp:Label ID="CityLabel" runat="server" Text='<%# Bind("City") %>'></asp:Label><br/>
			    <asp:Label ID="EmailLabel" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Текст" SortExpression="CreationDate">
                        <ItemTemplate>
                            <asp:Label ID="TextLabel" runat="server" Text='<%# Bind("Body") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Состояние">
                        <ItemTemplate>
                            <asp:Label ID="StateLabel" runat="server" Text='<%# Bind("State") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <ItemTemplate>
			    <asp:ImageButton ID="ApproveLine" runat="server" CommandName="ApproveLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/OK16.png" CausesValidation="false" Title="Утвердить" />
                            <asp:ImageButton ID="DeclineLine" runat="server" CommandName="DeclineLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Отклонить" />
			    <asp:ImageButton ID="DeleteLine" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Trash16.png" CausesValidation="false" Title="Удалить" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>


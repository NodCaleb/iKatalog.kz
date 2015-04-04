<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BannerManagement.aspx.cs" Inherits="Admin_DicountManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - скидики и акции</title>
    <link rel="Stylesheet" href="../css/Admin.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CarouselSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand=" select * from CarouselBanners order by RecordDate desc"></asp:SqlDataSource>
    <asp:ScriptManager ID="OrderManagementScriptManager" runat="server"></asp:ScriptManager>
    <h1>Баннер на главной странице</h1>
    <h2>Содержание</h2>
    <div class="validationsummary">
	<asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="BannerValidationGroup" />
    </div>
    <asp:TextBox ID="CatalogueUrlInput" style="width: 300px;" placeholder="ссылка на каталог" runat="server"></asp:TextBox>
    <asp:TextBox ID="ImageUrlImport" style="width: 300px;" placeholder="ссылка на изображение" runat="server"></asp:TextBox>
    <asp:Button ID="AddButton" runat="server" Text="Добавить" onclick="AddButton_Click" />
    <p>Размер изображения должен быть 636 x 321 пикселей (не больше, не меньше)</p>
    <asp:RequiredFieldValidator ID="CatalogueUrlInputValidator" runat="server" ErrorMessage="Не указана ссылка на каталог" ControlToValidate="CatalogueUrlInput" ValidationGroup="BannerValidationGroup"></asp:RequiredFieldValidator>
    <asp:RequiredFieldValidator ID="ImageUrlInputValidator" runat="server" ErrorMessage="Не указана ссылк на изображение" ControlToValidate="ImageUrlImport" ValidationGroup="BannerValidationGroup"></asp:RequiredFieldValidator>
    
        
    <asp:UpdatePanel ID="BannersUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="BannersGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="CarouselSource" 
                EnableModelValidation="True"
                OnRowCommand="Banners_RowCommand"
                >
                <Columns>
                    <asp:TemplateField HeaderText="Картинка" SortExpression="id">
                        <ItemTemplate>
			    <asp:HyperLink ID="BannerLink" NavigateUrl='<%# Eval("CatalogueUrl") %>' runat="server"><asp:Image ID="BannerImage" runat="server" ImageUrl='<%# Eval("ImageUrl") %>' AlternateText="Logo" width="300px" /></asp:HyperLink><br/>
                        </ItemTemplate>
                    </asp:TemplateField>
		    <asp:TemplateField HeaderText="Ссылка" SortExpression="id">
                        <ItemTemplate>
			    <asp:HyperLink ID="CatalogueLink" NavigateUrl='<%# Eval("CatalogueUrl") %>' Text='<%# Eval("CatalogueUrl") %>' runat="server"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Удалить">
                        <ItemTemplate>
                            <asp:ImageButton ID="DeleteLine" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Удалить" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
	    <h2>Демо:</h2>
	    <div class="banner">
		<iframe src="../Carousel01.aspx"></iframe>
	    </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>


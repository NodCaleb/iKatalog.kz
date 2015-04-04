<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="UpsellManagement.aspx.cs" Inherits="Customer_NewOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - горячие предложения</title>
    <link rel="Stylesheet" href="../css/OffersManagement.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="SELECT [Catalogue_id], [CatalogueName] FROM [Catalogues] where [Active] = 1 ORDER BY [CatalogueName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="UpsellOffersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                UO.id,
                UO.Catalogue_id,
	            C.CatalogueName,
	            UO.Article_id,
	            UO.ArticleNameDe,
                UO.ArticleNameRu,
                case UO.PriceOld when 0 then null else UO.PriceOld end as PriceOld,
                UO.PriceNew as PriceNew,
	            UO.CatalogueURL as CatalogueURL,
                UO.ImageURL as ImageURL,
                UO.RecordDate as RecordDate
            from
	            UpsellOffers as UO with (nolock)
	            join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
            order by
                UO.RecordDate desc"
        UpdateCommand="update UpsellOffers set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleNameDe = @ArticleNameDe, ArticleNameRu = @ArticleNameRu, PriceOld = replace(@PriceOld, ',', '.'), PriceNew = replace(@PriceNew, ',', '.'), CatalogueURL = @CatalogueURL, ImageURL = @ImageURL where id = @id">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select top 3
                UO.id,
                UO.Catalogue_id,
	            C.CatalogueName,
	            UO.Article_id,
	            UO.ArticleNameDe,
                UO.ArticleNameRu,
                case UO.PriceOld when 0 then null else UO.PriceOld end as PriceOld,
                UO.PriceNew as PriceNew,
	            UO.CatalogueURL as CatalogueURL,
                UO.ImageURL as ImageURL,
                UO.RecordDate as RecordDate,
                '~/Images/Logos/' + C.ImageLink as LogoURL,
                C.CatalogueName,
                'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=' + convert (nvarchar(5), UO.Catalogue_id) + '&article=' + convert(nvarchar(5), Article_id) + '&name=' + convert(nvarchar(5), ArticleNameDe) + '&price=' + replace(convert(nvarchar(5), PriceNew), '.', ',') + '&URL=' + replace (CatalogueURL, 'http://', '') as OrderURL
            from
	            UpsellOffers as UO with (nolock)
	            join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
            order by
                NEWID()"
        UpdateCommand="update UpsellOffers set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleNameDe = @ArticleNameDe, ArticleNameRu = @ArticleNameRu, PriceOld = replace(@PriceOld, ',', '.'), PriceNew = replace(@PriceNew, ',', '.'), CatalogueURL = @CatalogueURL, ImageURL = @ImageURL where id = @id">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewOrderScriptManager" runat="server">
    </asp:ScriptManager>
    <h2>Горячие предложения</h2>
    <div class="inputfield">
        <asp:DropDownList ID="CatalogueList" runat="server" DataSourceID="CatalogueListSource" DataTextField="CatalogueName" DataValueField="Catalogue_id" OnSelectedIndexChanged="CatalogueList_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
        <p>Каталог:</p>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="Article_idInput" runat="server"></asp:TextBox>
        <p>Артикул:</p>
        <asp:UpdatePanel ID="ArticleValidationUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:RequiredFieldValidator ID="ArticleRequiredValidator" runat="server" ErrorMessage="Не заполнен артикул." Display="None" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="Article_idInput"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="ArticleExpressionValidator" runat="server" ErrorMessage="Артикул должен состоять из цифр (иногда - одна буква в конце)." Display="None" ValidationExpression="[0-9]+[A-Z]?" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="Article_idInput"></asp:RegularExpressionValidator>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="ArticleNameDeInput" runat="server"></asp:TextBox>
        <p>Наименование немецкое:</p>
        <asp:RequiredFieldValidator ID="ArticleNameDeRrequiredValidator" runat="server" ControlToValidate="ArticleNameDeInput" ErrorMessage="Не указано немецкое наименование." ValidationGroup="UpsellOfferValidationGroup" Display="None">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="ArticleNameDeExpressionValidator" runat="server" ControlToValidate="ArticleNameDeInput" Display="None" ErrorMessage="Наименование может содержать только латинские буквы." ValidationGroup="UpsellOfferValidationGroup" ValidationExpression="[A-Za-z0-9]+">*</asp:RegularExpressionValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="ArticleNameRuInput" runat="server"></asp:TextBox>
        <p>Наименование русское:</p>
        <asp:RequiredFieldValidator ID="ArticleNameRuRrequiredValidator" runat="server" ControlToValidate="ArticleNameRuInput" ErrorMessage="Не указано русское наименование." ValidationGroup="UpsellOfferValidationGroup" Display="None">*</asp:RequiredFieldValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="PriceOldInput" runat="server"></asp:TextBox>
        <p>Цена старая:</p>
        <asp:RegularExpressionValidator ID="PriceOldExpressionValidator" runat="server" ControlToValidate="PriceOldInput" Display="None" ErrorMessage="Неверно указана цена (не более двух знаков после запятой, десятичный разделитель - запятая)." ValidationGroup="UpsellOfferValidationGroup" ValidationExpression="\d+(\,\d{1,2})?">*</asp:RegularExpressionValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="PriceNewInput" runat="server"></asp:TextBox>
        <p>Цена новая:</p>
        <asp:RequiredFieldValidator ID="PriceNewRequiredValidator" runat="server" ErrorMessage="Не указана цена." ControlToValidate="PriceNewInput" ValidationGroup="UpsellOfferValidationGroup" Display="None">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="PriceNewExpressionValidator" runat="server" ControlToValidate="PriceNewInput" Display="None" ErrorMessage="Неверно указана цена (не более двух знаков после запятой, десятичный разделитель - запятая)." ValidationGroup="UpsellOfferValidationGroup" ValidationExpression="\d+(\,\d{1,2})?">*</asp:RegularExpressionValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="CatalogueURLInput" runat="server"></asp:TextBox>
        <p>Ссылка на каталог:</p>
        <asp:RegularExpressionValidator ID="CatalogueURLExpressionValidator" runat="server" ErrorMessage="Ссылка может содержать не более 500 символов, если вы нашли длиннее, пожалуйста попробуйте ее сократить." Display="None" ValidationExpression=".{0,500}" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="CatalogueURLInput">*</asp:RegularExpressionValidator>
    </div>
    <div class="inputfield" style="float:none">
        <asp:TextBox ID="ImageURLInput" runat="server"></asp:TextBox>
        <p>Ссылка на картинку:</p>
        <asp:RegularExpressionValidator ID="ImageURLExpressionValidator" runat="server" ErrorMessage="Ссылка может содержать не более 500 символов, если вы нашли длиннее, пожалуйста попробуйте ее сократить." Display="None" ValidationExpression=".{0,500}" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="CatalogueURLInput">*</asp:RegularExpressionValidator>
    </div>
    <div class="summary">
        <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="UpsellOfferValidationGroup" />
    </div>
    <asp:Button ID="AddItemButton" runat="server" Text="Добавить" OnClick="AddItemButton_Click" ValidationGroup="UpsellOfferValidationGroup" />
    <h3>Активные предложения:</h3>
    <asp:UpdatePanel ID="UpsellOffersUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="UpsellOffersGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="UpsellOffersSource" 
                EnableModelValidation="True" 
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="20"
                OnRowcommand="UpsellOffersGridView_RowCommand">
                <Columns>
                    <%--<asp:TemplateField HeaderText="ID" InsertVisible="False" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>--%>
                    <asp:TemplateField HeaderText="Дата создания" SortExpression="RecordDate">
                        <EditItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("RecordDate", "{0:d}") %>'></asp:Label>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("RecordDate", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Каталог" InsertVisible="False" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="CatalogueEditList" runat="server" DataSourceID="CatalogueListSource" DataTextField="CatalogueName" DataValueField="Catalogue_id" SelectedValue='<%# Bind("Catalogue_id") %>'></asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Артикул" InsertVisible="False" SortExpression="Article_id">
                        <ItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>  
                            <asp:TextBox ID="ArticleTextBox" runat="server" Text='<%# Bind("Article_id") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Картинка" InsertVisible="False" SortExpression="ArticleNameDe">
                        <ItemTemplate>
                            <asp:HyperLink ID="CatalogueLink" runat="server" NavigateUrl='<%# Bind("CatalogueURL") %>' Target="_blank"><asp:Image ID="CatalogueLogo" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Картинка" Title="Картинка" style="max-height:38px" /></asp:HyperLink>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="CatalogueURLTextBox" runat="server" Text='<%# Bind("CatalogueURL") %>'></asp:TextBox>
                            <asp:TextBox ID="ImageURLTextBox" runat="server" Text='<%# Bind("ImageURL") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" InsertVisible="False" SortExpression="ArticleNameDe">
                        <ItemTemplate>
                            <asp:Label ID="ArticleNameDeLabel" runat="server" Text='<%# Bind("ArticleNameDe") %>'></asp:Label><br />
                            <asp:Label ID="ArticleNameRuLabel" runat="server" Text='<%# Bind("ArticleNameRu") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="ArticleNameDeTextBox" runat="server" Text='<%# Bind("ArticleNameDe") %>'></asp:TextBox><br />
                            <asp:TextBox ID="ArticleNameRuTextBox" runat="server" Text='<%# Bind("ArticleNameRu") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>                    
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <ItemTemplate>
                            <strike><asp:Label ID="PriceOldLabel" runat="server" Text='<%# Bind("PriceOld", "{0:#,#.00 € <br/>}") %>'></asp:Label></strike>
                            <asp:Label ID="PriceNewLabel" runat="server" Text='<%# Bind("PriceNew", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="PriceOldTextBox" runat="server" Text='<%# Bind("PriceOld", "{0:#,#.00}") %>'></asp:TextBox><br />
                            <asp:TextBox ID="PriceNewTextBox" runat="server" Text='<%# Bind("PriceNew", "{0:#,#.00}") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <ItemTemplate>
                            <asp:ImageButton ID="EditLine" runat="server" CommandName="Edit" ImageUrl="~/Images/Buttons/Edit16.png" CausesValidation="false" Title="Редактировать строку" />
                            <asp:ImageButton ID="DeleteLine" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Trash16.png" CausesValidation="false" Title="Удалить строку" />                            
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:ImageButton ID="UpdateButton" runat="server" CommandName="Update" ImageUrl="~/Images/Buttons/OK16.png" CausesValidation="false" Title="OK" />
                            <asp:ImageButton ID="CancelUpdateButton" runat="server" CommandName="Cancel" ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Отмена" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <SelectedRowStyle BackColor="#FFFF66" />
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpsellOffersUpdateProgress" runat="server" AssociatedUpdatePanelID="UpsellOffersUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="LoadImage1" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


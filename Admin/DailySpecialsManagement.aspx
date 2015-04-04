<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="DailySpecialsManagement.aspx.cs" Inherits="Customer_NewOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - товар дня</title>
    <link rel="Stylesheet" href="../css/OffersManagement.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="SELECT [Catalogue_id], [CatalogueName] FROM [Catalogues] where [Active] = 1 ORDER BY [CatalogueName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DailySpecialsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                DS.id,
	        DS.Article_id,
	        DS.ArticleNameDe,
                DS.ArticleNameRu,
                case DS.PriceOld when 0 then null else DS.PriceOld end as PriceOld,
                DS.PriceNew as PriceNew,
		DS.Sizes as Sizes,
		DS.Colors as Colors,
                DS.ImageURL as ImageURL,
		case when convert(date, RecordDate) = dbo.getlocaldate() then '<b><u>' + convert(varchar(10), RecordDate, 104) + '</u></b>' else convert(varchar(10), RecordDate, 104) end as RecordDateDisplay,
                DS.RecordDate as RecordDate
            from
	        DailySpecials as DS with (nolock)
            order by
                DS.RecordDate desc"
        UpdateCommand="update DailySpecials set RecordDate = @RecordDate, Article_id = @Article_id, ArticleNameDe = @ArticleNameDe, ArticleNameRu = @ArticleNameRu, PriceOld = replace(@PriceOld, ',', '.'), PriceNew = replace(@PriceNew, ',', '.'), Colors = @Colors, Sizes = @Sizes, ImageURL = @ImageURL where id = @id">
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewOrderScriptManager" runat="server">
    </asp:ScriptManager>
    <h2>Товар дня</h2>
    <div class="inputfield">
        <asp:TextBox ID="DateInput" runat="server"></asp:TextBox>
        <p>Дата (ДД.ММ.ГГГГ):</p>
	<asp:RegularExpressionValidator ID="DateExpressionValidator" runat="server" ControlToValidate="DateInput" Display="None" ErrorMessage="Неверный формат даты." ValidationGroup="UpsellOfferValidationGroup" ValidationExpression="\d{2}\.\d{2}\.\d{4}">*</asp:RegularExpressionValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="Article_idInput" runat="server"></asp:TextBox>
        <p>Артикул:</p>
        <asp:UpdatePanel ID="ArticleValidationUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:RequiredFieldValidator ID="ArticleRequiredValidator" runat="server" ErrorMessage="Не заполнен артикул." Display="None" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="Article_idInput"></asp:RequiredFieldValidator>
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
        <asp:TextBox ID="SizesInput" runat="server"></asp:TextBox>
        <p>Доступные размеры:</p>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="ColorsInput" runat="server"></asp:TextBox>
        <p>Доступные цвета:</p>
    </div>
    <div class="inputfield" style="float:none">
        <asp:TextBox ID="ImageURLInput" runat="server"></asp:TextBox>
        <p>Ссылка на картинку:</p>
        <asp:RegularExpressionValidator ID="ImageURLExpressionValidator" runat="server" ErrorMessage="Ссылка может содержать не более 500 символов, если вы нашли длиннее, пожалуйста попробуйте ее сократить." Display="None" ValidationExpression=".{0,500}" ValidationGroup="UpsellOfferValidationGroup" ControlToValidate="ImageURLInput">*</asp:RegularExpressionValidator>
    </div>
    <div class="summary">
        <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="UpsellOfferValidationGroup" />
    </div>
    <asp:Button ID="AddItemButton" runat="server" Text="Добавить" OnClick="AddItemButton_Click" ValidationGroup="UpsellOfferValidationGroup" />
    <h3>Лента предложений:</h3>
    <asp:UpdatePanel ID="DailySpecialsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="DailySpecialsHistoryGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="DailySpecialsSource" 
                EnableModelValidation="True" 
                AllowPaging="True"
                PagerSettings-Mode="NumericFirstLast"
                PageSize="20"
                OnRowcommand="DailySpecialsHistoryGridView_RowCommand">
                <Columns>
                    <%--<asp:TemplateField HeaderText="ID" InsertVisible="False" SortExpression="id">
                        <ItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </EditItemTemplate>
                    </asp:TemplateField>--%>
                    <asp:TemplateField HeaderText="Дата создания" SortExpression="RecordDate">
                        <EditItemTemplate>
			    <asp:TextBox ID="DateTextBox" runat="server" Text='<%# Bind("RecordDate", "{0:d}") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="DateLabel" runat="server" Text='<%# Bind("RecordDateDisplay") %>'></asp:Label>
                        </ItemTemplate>
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
                            <asp:Image ID="ItemImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Картинка" Title="Картинка" style="max-height:38px" />
                        </ItemTemplate>
                        <EditItemTemplate>
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
		    <asp:TemplateField HeaderText="Размеры/Цвета" SortExpression="Sizes">
                        <ItemTemplate>
                            <asp:Label ID="SizesLabel" runat="server" Text='<%# Bind("Sizes") %>'></asp:Label><br />
                            <asp:Label ID="ColorsLabel" runat="server" Text='<%# Bind("Colors") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="SizesTextBox" runat="server" Text='<%# Bind("Sizes") %>'></asp:TextBox><br />
                            <asp:TextBox ID="ColorsTextBox" runat="server" Text='<%# Bind("Colors") %>'></asp:TextBox>
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
    <asp:UpdateProgress ID="UpsellOffersUpdateProgress" runat="server" AssociatedUpdatePanelID="DailySpecialsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="LoadImage1" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="NewOrder.aspx.cs" Inherits="Customer_NewOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - оформление заказа</title>
    <link rel="Stylesheet" href="../css/Orders.css" />
    <link rel="Stylesheet" href="../css/Offers.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
	    SELECT
		[Catalogue_id],
		[CatalogueName],
		'Условия работы по выбранному каталогу:<br/>Минимальная цена артикула — ' + replace (convert(nvarchar(8), MinPrice), '.', ',') + ' €<br/>Стоимость доставки — ' + replace (convert(nvarchar(8), WeightFee), '.', ',') + ' € / кг.' + case NoReturn when 1 then '<br/>Возвраты, отказы и обмены не принимаются.' else '' end as TermsDescription
	    FROM
		[Catalogues]
	    where
		[Active] = 1
	    ORDER BY
		[CatalogueName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="OrderDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                OI.id,
                OI.Catalogue_id,
	            C.CatalogueName,
	            OI.Article_id,
	            OI.ArticleName,
		    LEFT (OI.ArticleName, 15) as ShortName,
	            OI.Size,
	            OI.Colour,
		    LEFT (OI.Colour, 10) as ShortColour,
	            OI.Price,
	            OI.Comment as URL
            from
	            OrderItems as OI with (nolock)
	            join Catalogues as C with (nolock) on C.Catalogue_id = OI.Catalogue_id
            where
	            OI.Customer_id = @Customer_id
                and Order_id = -1"
        UpdateCommand="update OrderItems set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleName = @ArticleName, Size = @Size, Colour = @Colour, Price = replace(@Price, ',', '.') where id = @id">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="UpsellOffersSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
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
                'http://ikatalog.kz/Customer/NewOrder.aspx?catalogue=' + convert (nvarchar(5), UO.Catalogue_id) + '&article=' + convert(nvarchar(25), Article_id) + '&name=' + convert(nvarchar(25), ArticleNameDe) + '&price=' + replace(convert(nvarchar(25), PriceNew), '.', ',') + '&URL=' + replace (CatalogueURL, 'http://', '') as OrderURL
            from
	            UpsellOffers as UO with (nolock)
	            join Catalogues as C with (nolock) on C.Catalogue_id = UO.Catalogue_id
            order by
                NEWID()"
        UpdateCommand="update UpsellOffers set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleNameDe = @ArticleNameDe, ArticleNameRu = @ArticleNameRu, PriceOld = replace(@PriceOld, ',', '.'), PriceNew = replace(@PriceNew, ',', '.'), CatalogueURL = @CatalogueURL, ImageURL = @ImageURL where id = @id">
    </asp:SqlDataSource>
    
    <h2>Новый заказ</h2>
    <p>Здесь вы можете оформить заказ. Если у вас вознинукт затруднения с оформлением заказа, у нас есть <a href="http://ikatalog.kz/StaticPages.aspx?Page=1">инструкция</a>, где все доступно и подробно описано.</p>
    <p>Внимание, размеры на немецких каталогах указаны немецкие! <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">Таблица размеров</a> представлена тут. Просим вас ознакомится с ней или проконсультироваться по телефону.</p>
    <h3>Добавить позицию:</h3>
    <p><asp:Label ID="TermsLabel" runat="server" Text=''></asp:Label></p>
    <div class="inputfield">
        <asp:DropDownList ID="CatalogueList" runat="server" DataSourceID="CatalogueListSource" DataTextField="CatalogueName" DataValueField="Catalogue_id" OnSelectedIndexChanged="CatalogueList_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
        <p>Каталог:</p>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="Article_idInput" runat="server"></asp:TextBox>
        <p>Артикул:</p>
        <asp:UpdatePanel ID="ArticleValidationUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:RequiredFieldValidator ID="ArticleRequiredValidator" runat="server" ErrorMessage="Не заполнен артикул." Display="None" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="ArticleExpressionValidator" runat="server" ErrorMessage="Артикул должен состоять из цифр (иногда - одна буква в конце)." Display="None" ValidationExpression="[0-9]+[A-Z]?" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RegularExpressionValidator>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="ArticleNameInput" runat="server"></asp:TextBox>
        <p>Наименование:</p>
        <asp:RequiredFieldValidator ID="ArticleNameRrequiredValidator" runat="server" ControlToValidate="ArticleNameInput" ErrorMessage="Не указано наименование." ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="PriceInput" runat="server"></asp:TextBox>
        <p>Цена:</p>
        <asp:RequiredFieldValidator ID="PriceRequiredValidator" runat="server" ErrorMessage="Не указана цена." ControlToValidate="PriceInput" ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
        <asp:RegularExpressionValidator ID="PriceExpressionValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Неверно указана цена (не более двух знаков после запятой, десятичный разделитель - запятая)." ValidationGroup="OrderPositionValidationGroup" ValidationExpression="\d+(\,\d{1,2})?">*</asp:RegularExpressionValidator>
        <asp:CustomValidator ID="MinimumPriceValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Цена артикула по данному каталогу должна быть не менее 7 евро." ValidationGroup="OrderPositionValidationGroup">*</asp:CustomValidator>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="SizeInput" runat="server"></asp:TextBox>
        <p>Размер:</p>
        <asp:UpdatePanel ID="SizeValidationUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
		        <asp:RegularExpressionValidator ID="SizeExpressionValidator" runat="server" ErrorMessage="Размер может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="SizeInput">*</asp:RegularExpressionValidator>
		    </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="inputfield">
        <asp:TextBox ID="ColorInput" runat="server"></asp:TextBox>
        <p>Цвет:</p>
        <asp:UpdatePanel ID="ColorValidationUpdatePanel" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
		        <asp:RegularExpressionValidator ID="ColorExpressionValidator" runat="server" ErrorMessage="Цвет может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="ColorInput">*</asp:RegularExpressionValidator>
		    </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="inputfield" style="float:none">
        <asp:TextBox ID="CommentInput" runat="server"></asp:TextBox>
        <p>Ссылка:</p>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Ссылка может содержать не более 500 символов, если вы нашли длиннее, пожалуйста попробуйте ее сократить." Display="None" ValidationExpression=".{0,500}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="CommentInput">*</asp:RegularExpressionValidator>
    </div>
    <div class="summary">
        <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="OrderPositionValidationGroup" />
    </div>
    <asp:Button ID="AddItemButton" runat="server" Text="Добавить" OnClick="AddItemButton_Click" ValidationGroup="OrderPositionValidationGroup" />
    <h3>Ваш заказ:</h3>
    <asp:UpdatePanel ID="OrderDetailsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="OrderDetailsGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="OrderDetailsSource" 
                EnableModelValidation="True" 
                OnRowcommand="OrderDetailsGridView_RowCommand" 
                ondatabound="OrderDetailsGridView_DataBound">
                <Columns>
                    <asp:TemplateField HeaderText="ID" InsertVisible="False" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:Label ID="IDLabel" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                        </EditItemTemplate>
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
                    <asp:TemplateField HeaderText="Наименование" InsertVisible="False" SortExpression="ArticleName">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Bind("URL") %>' Text='<%# Bind("ShortName") %>' Target="_blank">HyperLink</asp:HyperLink>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="ArticleNameTextBox" runat="server" Text='<%# Bind("ArticleName") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Размер" InsertVisible="False" SortExpression="Size">
                        <ItemTemplate>
                            <asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="SizeTextBox" runat="server" Text='<%# Bind("Size") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цвет" InsertVisible="False" SortExpression="Colour">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("ShortColour") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="ColourTextBox" runat="server" Text='<%# Bind("Colour") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="PriceTextBox" runat="server" Text='<%# Bind("Price", "{0:#,#.00}") %>'></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <ItemTemplate>
                            <asp:ImageButton ID="EditLine" runat="server" CommandName="Edit" ImageUrl="~/Images/Buttons/Edit16.png" CausesValidation="false" Title="Редактировать строку" />
                            <asp:ImageButton ID="DuplicateLine" runat="server" CommandName="DuplicateLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Double16.png" CausesValidation="false" Title="Дублировать строку" />
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
            <p><asp:Label ID="EmptyOrderLabel" runat="server" Text="Заказ пуст"></asp:Label></p>
            <asp:Button ID="ConfirmOrderButton" runat="server" Text="Оформить заказ" 
                onclick="ConfirmOrderButton_Click" />
            <asp:Panel ID="UpsellPanel" runat="server">
                <h2>Горячие предложения:</h2>
                <asp:Repeater ID="UpsellOffersRepeater" runat="server" DataSourceID="UpsellOffersSource">
                    <ItemTemplate>
                        <div class="offer">
                            <h3><%# Eval("ArticleNameRu")%></h3>
                            <div>
                                <asp:Image ID="ArticleImage" runat="server" ImageUrl='<%# Eval("ImageURL") %>' AlternateText="Photo" Title='<%# Eval("ArticleNameRu") %>' />
                            </div>
                            <div>
                                <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("LogoURL") %>' AlternateText="Logo" Title='<%# Eval("CatalogueName") %>' />
                                <p><strike><%# Eval("PriceOld", "{0:#,#.00 € <br/>}") %></strike>
                                <b><%# Eval("PriceNew", "{0:#,#.00 €}") %></b></p>
                            </div>
                            <asp:HyperLink ID="ViewLink" runat="server" NavigateUrl='<%# Eval("CatalogueURL") %>' Target="_blank">Открыть</asp:HyperLink>
                            <asp:HyperLink ID="OrderLink" runat="server" NavigateUrl='<%# Eval("OrderURL") %>'>Заказать</asp:HyperLink>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="OrderDetailsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="LoadImage1" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <p><asp:Label ID="TestLabel" runat="server" Text=''></asp:Label></p>
</asp:Content>


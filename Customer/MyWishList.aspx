<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="MyWishList.aspx.cs" Inherits="Customer_MyWishList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Мой список желаний</title>
    <link rel="Stylesheet" href="../css/Orders.css" />
    <link rel="Stylesheet" href="../css/Offers.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CatalogueListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="SELECT [Catalogue_id], [CatalogueName] FROM [Catalogues] where [Active] = 1 ORDER BY [CatalogueName]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="WishesSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
            select
                W.id,
                W.Catalogue_id,
	        C.CatalogueName,
	        W.Article_id,
	        W.ArticleName,
	        W.Size,
	        W.Colour,
	        W.Price,
	        W.Comment,
		W.URL,
		W.Fullfilled
            from
	        Wishes as W with (nolock)
	        join Catalogues as C with (nolock) on C.Catalogue_id = W.Catalogue_id
            where
	        W.Customer_id = @Customer_id
                and isnull (W.Fullfilled, 0) = 0">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="-1" Name="Customer_id" SessionField="Customer" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="NewOrderScriptManager" runat="server">
    </asp:ScriptManager>
    <h2>Ваш список желаний (Wishlist)</h2>
    <asp:Panel ID="Willkommen" runat="server">
	<p>На этой странице вы можете составить свой список желаний и поделиться им с друзьями. Составялется он так же, как <a href="../Infos/OrderMaking.aspx">заказ на сайте</a>. После вы можете поделиться им в соц-сетях или отправить другу ссылку по email.</p>
    </asp:Panel>
    <asp:UpdatePanel ID="WishesUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="WishesGridView" runat="server" GridLines="None"
                AutoGenerateColumns="False"
                DataKeyNames="id"
                DataSourceID="WishesSource" 
                EnableModelValidation="True" 
                OnRowcommand="WishesGridView_RowCommand" 
                ondatabound="WishesGridView_DataBound">
                <Columns>
                    <asp:TemplateField HeaderText="Каталог" InsertVisible="False" SortExpression="CatalogueName">
                        <ItemTemplate>
                            <asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Артикул" InsertVisible="False" SortExpression="Article_id">
                        <ItemTemplate>
                            <asp:Label ID="ArticleLabel" runat="server" Text='<%# Bind("Article_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" InsertVisible="False" SortExpression="ArticleName">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Bind("URL") %>' Text='<%# Bind("ArticleName") %>' Target="_blank">HyperLink</asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Размер" InsertVisible="False" SortExpression="Size">
                        <ItemTemplate>
                            <asp:Label ID="SizeLabel" runat="server" Text='<%# Bind("Size") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цвет" InsertVisible="False" SortExpression="Colour">
                        <ItemTemplate>
                            <asp:Label ID="ColourLabel" runat="server" Text='<%# Bind("Colour") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Цена" SortExpression="Price">
                        <ItemTemplate>
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Bind("Price", "{0:#,#.00 €}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Действия">
                        <ItemTemplate>
                            <asp:ImageButton ID="Fulfill" runat="server" CommandName="FulfillWish" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/OK16.png" CausesValidation="false" Title="Желание исполнено!" />
                            <asp:ImageButton ID="DeleteLine" runat="server" CommandName="DeleteLine" CommandArgument='<%# Bind("id") %>' ImageUrl="~/Images/Buttons/Cancel16.png" CausesValidation="false" Title="Больше не хочу!" />                            
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <SelectedRowStyle BackColor="#FFFF66" />
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Panel ID="SharePanel" runat="server">
	<h3>Поделиться списком с друзьями:</h3>
	<h4>Вы можете поделиться списком через социальные сети:</h4>
	<script type="text/javascript" src="//yandex.st/share/share.js" charset="utf-8"></script>
	<div ID="yasharediv" runat="server" class="yashare-auto-init" data-yashareL10n="ru" data-yashareType="button" data-yashareImage="http://ikatalog.kz/images/list.png" data-yasharedescription="Список того, что я хочу получить в подарок." data-yashareLink="http://ikatalog.kz" data-yashareQuickServices="vkontakte,facebook,twitter,odnoklassniki,moimir"></div>
	<h4>Отправить вот эту ссылку по электронной почте:</h4>
	<asp:Label id="ShareURL" Text="" runat="server"/>
	<h4>Либо укажите имя и email получателя и мы сделаем это сами:</h4>
	<p>Имя:   <asp:TextBox ID="ReceiverNameInput" runat="server"></asp:TextBox></p>
	<p>Email: <asp:TextBox ID="ReceiverEmailInput" runat="server"></asp:TextBox></p>
	<asp:RequiredFieldValidator ID="LoginRequiredFieldValidator" runat="server" ErrorMessage="Введите Имя получателя" ControlToValidate="ReceiverNameInput" Display="None" ValidationGroup="SendListValidationGroup"></asp:RequiredFieldValidator>
	<asp:RequiredFieldValidator ID="EmailRequiredFieldValidator" runat="server" ErrorMessage="Введите Email получателя" ControlToValidate="ReceiverEmailInput" Display="None" ValidationGroup="SendListValidationGroup"></asp:RequiredFieldValidator>
	<asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="ReceiverEmailInput" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="SendListValidationGroup"></asp:RegularExpressionValidator>
	<div class="summary">
	    <asp:ValidationSummary ID="SendListValidationSummary" runat="server" ValidationGroup="SendListValidationGroup" />
	</div>
	<asp:Button ID="SendList" runat="server" Text="Отправить" OnClick="SendListButton_Click" ValidationGroup="SendListValidationGroup" />
	<asp:Label id="DoneLabel" Text="" runat="server"/>
	<hr/>
    </asp:Panel>
    <h3>Добавить желание:</h3>
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
        <asp:RegularExpressionValidator ID="ArticleNameExpressionValidator" runat="server" ControlToValidate="ArticleNameInput" Display="None" ErrorMessage="Наименование может содержать только латинские буквы." ValidationGroup="OrderPositionValidationGroup" ValidationExpression="[A-Za-z0-9]+">*</asp:RegularExpressionValidator>
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
        <asp:TextBox ID="URLInput" runat="server"></asp:TextBox>
        <p>Ссылка:</p>
        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Ссылка может содержать не более 500 символов, если вы нашли длиннее, пожалуйста попробуйте ее сократить." Display="None" ValidationExpression=".{0,500}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="URLInput">*</asp:RegularExpressionValidator>
    </div>
    <div class="summary">
        <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="OrderPositionValidationGroup" />
    </div>
    <asp:Button ID="AddItemButton" runat="server" Text="Добавить" OnClick="AddItemButton_Click" ValidationGroup="OrderPositionValidationGroup" />
    
    <asp:UpdateProgress ID="WishesUpdateProgress" runat="server" AssociatedUpdatePanelID="WishesUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="LoadImage1" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>


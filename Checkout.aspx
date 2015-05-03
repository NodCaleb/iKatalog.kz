<%@ Page Title="" Language="C#" MasterPageFile="~/CheckoutMasterPage.master" AutoEventWireup="true" CodeFile="Checkout.aspx.cs" Inherits="Customer_NewOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - оформление заказа</title>
    <link rel="Stylesheet" href="css/Checkout.css" />
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
    <asp:SqlDataSource ID="CatalogueListSourceOrder" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand="
	    select
		    -1 as Catalogue_id,
		    'Каталог' as CatalogueName,
		    '' as SortName
	    union
	    select
		    Catalogue_id,
		    CatalogueName,
		    CatalogueName as SortName
	    from
		    Catalogues
	    where
		    Active = 1
	    order by
		    SortName">
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
	            isnull(OI.Session_id, '0') = @Session
                and Order_id = -1"
        UpdateCommand="update OrderItems set Catalogue_id = @Catalogue_id, Article_id = @Article_id, ArticleName = @ArticleName, Size = @Size, Colour = @Colour, Price = replace(@Price, ',', '.') where id = @id">
        <SelectParameters>
	    <asp:Parameter Name="Session" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PaymentOptionsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
    SelectCommand="exec DisplayPaymentOptions @amount = @amount">
	<SelectParameters>
	    <asp:Parameter Name="amount" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
    <h1>Оформление заказа</h1>
    <h2>Добавить в корзину:</h2>
	<div class="validationsummary">
	    <asp:ValidationSummary ID="OrderPositionValidationSummary" runat="server" ValidationGroup="OrderPositionValidationGroup" />
	</div>
	
	<asp:DropDownList ID="CatalogueList" runat="server" DataSourceID="CatalogueListSourceOrder" DataTextField="CatalogueName" DataValueField="Catalogue_id" OnSelectedIndexChanged="CatalogueList_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
	<asp:TextBox ID="Article_idInput" runat="server" placeholder="Артикул"></asp:TextBox>
	<asp:TextBox ID="ArticleNameInput" runat="server" placeholder="Название"></asp:TextBox>
	<asp:TextBox ID="PriceInput" runat="server" placeholder="Цена"></asp:TextBox>
	<asp:TextBox ID="SizeInput" runat="server" placeholder="Размер"></asp:TextBox>
	<asp:TextBox ID="ColorInput" runat="server" placeholder="Цвет"></asp:TextBox>
	<asp:TextBox ID="URLInput" style="width: 741px;" runat="server" placeholder="Ссылка на товар"></asp:TextBox>
	<asp:Button ID="AddItemButton" runat="server" Text="В корзину >" OnClick="AddItemButton_Click" ValidationGroup="OrderPositionValidationGroup" style="width:100px; font-size: medium; margin: 0;" />
	<br/><asp:Label ID="TermsLabel" runat="server" Text=''></asp:Label>&nbsp;<asp:HyperLink ID="HelpLink" runat="server" Text='' NavigateUrl='' Target="_blank" />
	
	<asp:CustomValidator ID="CatalogueValidator" runat="server" ControlToValidate="CatalogueList" Display="None" ErrorMessage="Не выбран каталог." ValidationGroup="OrderPositionValidationGroup">*</asp:CustomValidator>
	<asp:RequiredFieldValidator ID="ArticleRequiredValidator" runat="server" ErrorMessage="Не заполнен артикул." Display="None" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RequiredFieldValidator>
	<asp:RegularExpressionValidator ID="ArticleExpressionValidator" runat="server" ErrorMessage="Артикул должен состоять из цифр (иногда - одна буква в конце)." Display="None" ValidationExpression="[0-9]+[A-Z]?" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="Article_idInput"></asp:RegularExpressionValidator>
	<asp:RequiredFieldValidator ID="ArticleNameRrequiredValidator" runat="server" ControlToValidate="ArticleNameInput" ErrorMessage="Не указано наименование." ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
	<asp:RequiredFieldValidator ID="PriceRequiredValidator" runat="server" ErrorMessage="Не указана цена." ControlToValidate="PriceInput" ValidationGroup="OrderPositionValidationGroup" Display="None">*</asp:RequiredFieldValidator>
	<asp:RegularExpressionValidator ID="PriceExpressionValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Неверно указана цена (не более двух знаков после запятой, десятичный разделитель - запятая)." ValidationGroup="OrderPositionValidationGroup" ValidationExpression="\d+(\,\d{1,2})?">*</asp:RegularExpressionValidator>
	<asp:CustomValidator ID="MinimumPriceValidator" runat="server" ControlToValidate="PriceInput" Display="None" ErrorMessage="Цена артикула по данному каталогу должна быть не менее 7 евро." ValidationGroup="OrderPositionValidationGroup">*</asp:CustomValidator>
	<asp:RegularExpressionValidator ID="SizeExpressionValidator" runat="server" ErrorMessage="Размер может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="SizeInput">*</asp:RegularExpressionValidator>
	<asp:RegularExpressionValidator ID="ColorExpressionValidator" runat="server" ErrorMessage="Цвет может содержать не более 20 символов." Display="None" ValidationExpression=".{0,20}" ValidationGroup="OrderPositionValidationGroup" ControlToValidate="ColorInput">*</asp:RegularExpressionValidator>
	<p><asp:HyperLink id="CataloguesLink" NavigateUrl="~/Catalogues.aspx" runat="server" ><<< вернуться к каталогам товаров</asp:HyperLink></p>
    <h2>Корзина:</h2>
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
	    <asp:Panel id="DsicountPanel" runat="server">
		<h3>Купон на скидку:</h3>
		<asp:MultiView ID="CouponView" ActiveViewIndex="0" runat="server">
		    <asp:View ID="EnterCoupon" runat="server">
			<asp:TextBox ID="CouponNumberTextBox" runat="server" placeholder="номер" style="margin-bottom: 5px;"></asp:TextBox> <asp:LinkButton id="UseCoupon" Text="Применить" OnClick="UseCoupon_Click" runat="server"/> <asp:Label id="CheckCouponLabel" Text='' style="color: red;" runat="server"/>
		    </asp:View>
		    <asp:View ID="ViewCoupon" runat="server">
			<asp:Label id="ViewCouponLabel" Text='' runat="server"/><asp:LinkButton id="RemoveCoupon" Text="Удалить" OnClick="RemoveCoupon_Click" runat="server"/>
		    </asp:View>
		</asp:MultiView>
	    </asp:Panel>
	    <asp:Panel id="AuthPanel" runat="server">
		<div class="step">
		    <h3>Авторизация</h3>
		    <table border="0" cellpadding="0" cellspacing="0">
			<tbody>
			    <tr>
				<td style="text-align: left" width="300px">
				    <asp:radiobuttonlist id="AuthList" runat="server" style="direction: ltr" align="left" OnSelectedIndexChanged="AuthListIndexChanged" AutoPostBack="true">
					<asp:ListItem>Новый покупатель</asp:ListItem>
					<asp:ListItem>Уже зарегистрирован</asp:ListItem>
				    </asp:radiobuttonlist>
				</td>
				<td style="text-align: left; vertical-align: top;">
				    <asp:MultiView ID="AuthMultiView" ActiveViewIndex="0" runat="server">
					<asp:View ID="CheckoutWithoutRegistration" runat="server">
					    Укажите, пожалуйста свои контактные данные:<br/>
					    <asp:TextBox ID="FullNameTextBox" runat="server" MaxLength="50" placeholder="полное имя" style="margin-bottom: 5px;"></asp:TextBox>
					    <asp:TextBox ID="EmailTextBox" runat="server" MaxLength="50" placeholder="email" style="margin-bottom: 5px;"></asp:TextBox>
					    <asp:TextBox ID="PhoneTextBox" runat="server" MaxLength="50" placeholder="телефон" style="margin-bottom: 5px;"></asp:TextBox>
					    
					    <asp:RequiredFieldValidator ID="FullNameRequiredValidator" runat="server" ErrorMessage="Не заполнено имя" Display="None" ValidationGroup="ContactDataValidationGroup" ControlToValidate="FullNameTextBox"></asp:RequiredFieldValidator>
					    <asp:RequiredFieldValidator ID="EmailRequiredValidator" runat="server" ErrorMessage="Не заполнен Email" Display="None" ValidationGroup="ContactDataValidationGroup" ControlToValidate="EmailTextBox"></asp:RequiredFieldValidator>
					    <asp:RequiredFieldValidator ID="PhoneRequiredValidator" runat="server" ErrorMessage="Не заполнен телефон" Display="None" ValidationGroup="ContactDataValidationGroup" ControlToValidate="PhoneTextBox"></asp:RequiredFieldValidator>
					    <asp:RegularExpressionValidator ID="EmailRegularExpressionValidator" runat="server" ErrorMessage="Введите корректный адрес электронной почты строчными буквами (маленькими)" ControlToValidate="EmailTextBox" ValidationExpression="^[0-9a-z]+[-\._0-9a-z]*@[0-9a-z]+[-\._^0-9a-z]*[0-9a-z]+[\.]{1}[a-z]{2,6}$" Display="None" ValidationGroup="ContactDataValidationGroup"></asp:RegularExpressionValidator>
					    <asp:CustomValidator ID="EmailUniquenessValidator" runat="server" ErrorMessage="Пользователь с таким адресом электронной почты уже зарегистрирован, пожалуйста авторизуйтесь" ControlToValidate="EmailTextBox" Display="None" ValidationGroup="ContactDataValidationGroup"></asp:CustomValidator>
					</asp:View>
					<asp:View ID="LoginNow" runat="server">
					    <asp:TextBox ID="UserNameTextBox" runat="server" placeholder="логин" style="margin-bottom: 5px;"></asp:TextBox> <asp:Label id="WrongLabel" Text='' runat="server"/><br/>
					    <asp:TextBox ID="PasswordTextBox" runat="server" TextMode="Password" placeholder="пароль" style="margin-bottom: 5px;"></asp:TextBox><br/>
					    <asp:Button ID="LoginButton" runat="server" Text="Войти" onclick="LoginButton_Click" />
					</asp:View>
				    </asp:MultiView>
				</td>
				<td style="color: red;">
				    <asp:ValidationSummary ID="ContactDataValidationSummary" runat="server" ValidationGroup="ContactDataValidationGroup" />
				</td>
			    </tr>
			</tbody>
		    </table>		    
		</div>
	    </asp:Panel>
	    <asp:Panel id="DeliveryAndPaymentPanel" runat="server">
		<div class="step">
		    <h3>Доставка</h3>
		    <table border="0" cellpadding="0" cellspacing="0">
			<tbody>
			    <tr>
				<td style="text-align: left" width="300px">
				    <asp:radiobuttonlist id="DeliveryList" runat="server" style="direction: ltr" align="left" OnSelectedIndexChanged="DeliveryListIndexChanged" AutoPostBack="true">
					<asp:ListItem>Самовывоз</asp:ListItem>
					<asp:ListItem>Курьерская доставка</asp:ListItem>
				    </asp:radiobuttonlist>
				</td>
				<td style="text-align: left; vertical-align: top;">
				    <asp:MultiView ID="DeliveryMultiView" ActiveViewIndex="0" runat="server">
					<asp:View ID="SelfPickUp" runat="server">
					    При поступлении посылки в офис мы вам сообщим и вы сможете ее забрать<br/>Данный способ доставки доступен только для жителей г. Алматы
					</asp:View>
					<asp:View ID="CourierDelivery" runat="server">
					    Введите, пожалуйста адрес:
					    <asp:TextBox ID="AddressTextBox" runat="server" Text='' MaxLength="1000" TextMode="MultiLine" style="height: 37px; width: 500px;"></asp:TextBox>
					</asp:View>
				    </asp:MultiView>
				</td>
			    </tr>
			</tbody>
		    </table>		    
		</div>	    
		<div class="step">
		    <h3>Оплата</h3>
		    <table border="0" cellpadding="0" cellspacing="0">
			<tbody>
			    <tr>
				<td style="text-align: left" width="300px">
				    <asp:radiobuttonlist id="PaymentList" runat="server" style="direction: ltr" align="left" OnSelectedIndexChanged="PaymentListIndexChanged" AutoPostBack="true">
					<asp:ListItem>Наличными</asp:ListItem>
					<asp:ListItem>Qiwi</asp:ListItem>
					<asp:ListItem>Карта VISA/Mastercard на сайте</asp:ListItem>
					<asp:ListItem>Зачисление  на карту KazCom</asp:ListItem>
				    </asp:radiobuttonlist>
				</td>
				<td style="text-align: left; vertical-align: top;">
				    <asp:MultiView ID="PaymentMultiView" ActiveViewIndex="0" runat="server">
					<asp:View ID="Cash" runat="server">
					    Для оплаты наличными пожалуйста связитесь с нашим менеджером по телефону: +7 701 543-62-59<br/>Данный способ оплаты доступен только для жителей г. Алматы
					</asp:View>
					<asp:View ID="QiwiTerminal" runat="server">
					    <asp:Label id="QiwiLabel" Text='' runat="server"/>
					</asp:View>
					<asp:View ID="eComCharge" runat="server">
					    Выберите размер предоплаты: <asp:DropDownList ID="PaymentOptionsList" runat="server" DataSourceID="PaymentOptionsSource" DataTextField="Description" DataValueField="PaymentAmount" AutoPostBack="False"></asp:DropDownList><br/>
					    После подтверждения заказа вы будете перенаправлены на страницу оплаты<br/><span style="color:#B22222;">После оплаты обязательно нажмите кнопку Вернуться в магазин, чтобы мы могли сразу увидеть ваш платеж</span>
					</asp:View>
					<asp:View ID="KazCom" runat="server">
					    Реквизиты для оплаты будут высланы вам на Email после подтверждения заказа
					</asp:View>
				    </asp:MultiView>
				</td>
			    </tr>
			</tbody>
		    </table>		    
		</div>
	    </asp:Panel>
	    
            <asp:Button ID="ConfirmOrderButton" runat="server" Text="Подтвердить заказ" ValidationGroup="ContactDataValidationGroup" CausesValidation="true" onclick="ConfirmOrderButton_Click" />
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
    <!-- Google Code for &#1050;&#1086;&#1088;&#1079;&#1080;&#1085;&#1072; &#1085;&#1072; iKatalog Conversion Page -->
    <script type="text/javascript">
    /* <![CDATA[ */
    var google_conversion_id = 1002578196;
    var google_conversion_language = "en";
    var google_conversion_format = "3";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "obV1CInlqVkQlMKI3gM";
    var google_remarketing_only = false;
    /* ]]> */
    </script>
    <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
    </script>
    <noscript>
    <div style="display:inline;">
    <img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/1002578196/?label=obV1CInlqVkQlMKI3gM&amp;guid=ON&amp;script=0"/>
    </div>
    </noscript>
</asp:Content>


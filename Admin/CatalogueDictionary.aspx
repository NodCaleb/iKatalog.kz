<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CatalogueDictionary.aspx.cs" Inherits="Admin_CatalogueDictionary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iK_Admin - справочник каталогов</title>
    <link rel="Stylesheet" href="../css/Dictionary.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="CataloguesListSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand="select Catalogue_id, CatalogueName from Catalogues order by CatalogueName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="CatalogueDetailsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        DeleteCommand="DELETE FROM [Catalogues] WHERE [Catalogue_id] = @Catalogue_id"
        InsertCommand="INSERT INTO [Catalogues] ([CatalogueName], [Link], [CatalogueDescription], [ImageLink], [Active], [SortOrder], [Men], [Women], [Chilrden], [Shoes], [Chubby], [Toys], [Sport], [Home], [Premium], [Makeup], [Economy], [Jems], [PriceIndex], [NoReturn], [MinPrice], [Weightfee], [ArticleRegularExpression], [ArticleComment], [OrderingRules], [VideoLink], NoFrame) VALUES (@CatalogueName, @Link, @CatalogueDescription, @ImageLink, @Active, @SortOrder, @Men, @Women, @Chilrden, @Shoes, @Chubby, @Toys, @Sport, @Home, @Premium, @Makeup, @Economy, @Jems, @PriceIndex, @NoReturn, @MinPrice, @WeightFee, @ArticleRegularExpression, @ArticleComment, @OrderingRules, @VideoLink, @NoFrame)"
        SelectCommand="select Catalogue_id, CatalogueName, Link, ImageLink, CatalogueDescription, '~/Images/Logos/' +  ImageLink as [ImageView], Active, SortOrder, Men, Women, Chilrden, Shoes, Chubby, Toys, Sport, Home, Premium, Makeup, Economy, Jems, PriceIndex, NoReturn, MinPrice, WeightFee, ArticleRegularExpression, ArticleComment, OrderingRules, VideoLink, NoFrame from Catalogues WHERE ([Catalogue_id] = @Catalogue_id)"
        UpdateCommand="UPDATE [Catalogues] SET [CatalogueName] = @CatalogueName, [Link] = @Link, [CatalogueDescription] = @CatalogueDescription, [ImageLink] = @ImageLink, [Active] = @Active,[SortOrder] = @SortOrder, [Men] = @Men, [Women] = @Women, [Chilrden] = @Chilrden, [Shoes] = @Shoes, [Chubby] = @Chubby, [Toys] = @Toys, [Sport] = @Sport, [Home] = @Home, [Premium] = @Premium, [Makeup] = @Makeup, [Economy] = @Economy, [Jems] = @Jems, [PriceIndex] = @PriceIndex, [NoReturn] = @NoReturn, [MinPrice] = @MinPrice, [WeightFee] = @WeightFee, [ArticleRegularExpression] = @ArticleRegularExpression, [ArticleComment] = @ArticleComment, [OrderingRules] = @OrderingRules, [VideoLink] = @VideoLink, NoFrame = @NoFrame WHERE [Catalogue_id] = @Catalogue_id"
        OnInserted="CatalogueDetailsSource_Inserted">
        <DeleteParameters>
            <asp:Parameter Name="Catalogue_id" Type="Int32" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="CatalogueName" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="CatalogueDescription" Type="String" />
            <asp:Parameter Name="ImageLink" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="SortOrder" Type="Int32" />
            <asp:Parameter Name="Men" Type="Boolean" />
            <asp:Parameter Name="Women" Type="Boolean" />
            <asp:Parameter Name="Chilrden" Type="Boolean" />
            <asp:Parameter Name="Shoes" Type="Boolean" />
            <asp:Parameter Name="Chubby" Type="Boolean" />
            <asp:Parameter Name="Toys" Type="Boolean" />
            <asp:Parameter Name="Sport" Type="Boolean" />
            <asp:Parameter Name="Home" Type="Boolean" />
            <asp:Parameter Name="Premium" Type="Boolean" />
            <asp:Parameter Name="Makeup" Type="Boolean" />
            <asp:Parameter Name="Economy" Type="Boolean" />
            <asp:Parameter Name="Jems" Type="Boolean" />
            <asp:Parameter Name="NoReturn" Type="Boolean" />
            <asp:Parameter Name="PriceIndex" Type="Decimal" />
            <asp:Parameter Name="MinPrice" Type="Decimal" />
            <asp:Parameter Name="WeightFee" Type="Decimal" />
            <asp:Parameter Name="ArticleRegularExpression" Type="String" />
            <asp:Parameter Name="ArticleComment" Type="String" />
            <asp:Parameter Name="OrderingRules" Type="String" />
            <asp:Parameter Name="VideoLink" Type="String" />
            <asp:Parameter Name="NoFrame" Type="Boolean" />
        </InsertParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="CatalogueDropDownList" Name="Catalogue_id" PropertyName="SelectedValue" DefaultValue="0" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="CatalogueName" Type="String" />
            <asp:Parameter Name="Link" Type="String" />
            <asp:Parameter Name="CatalogueDescription" Type="String" />
            <asp:Parameter Name="ImageLink" Type="String" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="Men" Type="Boolean" />
            <asp:Parameter Name="Women" Type="Boolean" />
            <asp:Parameter Name="Chilrden" Type="Boolean" />
            <asp:Parameter Name="Shoes" Type="Boolean" />
            <asp:Parameter Name="Chubby" Type="Boolean" />
            <asp:Parameter Name="Toys" Type="Boolean" />
            <asp:Parameter Name="Sport" Type="Boolean" />
            <asp:Parameter Name="Home" Type="Boolean" />
            <asp:Parameter Name="Premium" Type="Boolean" />
            <asp:Parameter Name="Makeup" Type="Boolean" />
            <asp:Parameter Name="Economy" Type="Boolean" />
            <asp:Parameter Name="Jems" Type="Boolean" />
            <asp:Parameter Name="NoReturn" Type="Boolean" />
            <asp:Parameter Name="PriceIndex" Type="Decimal" />
            <asp:Parameter Name="Catalogue_id" Type="Int32" />
            <asp:Parameter Name="MinPrice" Type="Decimal" />
            <asp:Parameter Name="WeightFee" Type="Decimal" />
            <asp:Parameter Name="ArticleRegularExpression" Type="String" />
            <asp:Parameter Name="ArticleComment" Type="String" />
            <asp:Parameter Name="OrderingRules" Type="String" />
            <asp:Parameter Name="VideoLink" Type="String" />
            <asp:Parameter Name="NoFrame" Type="Boolean" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:ScriptManager ID="CatalogueDictionaryScriptManager" runat="server"></asp:ScriptManager>
    <h2>Каталоги</h2>
    <asp:UpdatePanel ID="CatalogueDetailsUpdatePanel" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="dictionaryheader">
                <asp:DropDownList ID="CatalogueDropDownList" runat="server" DataValueField="Catalogue_id" DataTextField="CatalogueName" DataSourceID="CataloguesListSource" AutoPostBack="True"></asp:DropDownList>
            </div>
            <asp:DetailsView ID="CatalogueDetailsView" runat="server"
                AutoGenerateRows="False"
                DataKeyNames="Catalogue_id" 
                DataSourceID="CatalogueDetailsSource"
                GridLines="None"
                EnableModelValidation="True">
                 <Fields>
                    <asp:TemplateField HeaderText="Логотип">
                        <EditItemTemplate>
                            <asp:TextBox ID="LogoTextBox" runat="server" Text='<%# Bind("ImageLink") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="LogoTextBox" runat="server" Text='<%# Bind("ImageLink") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Image ID="LogoImage" runat="server" ImageUrl='<%# Bind("ImageView") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="ID" SortExpression="CatalogueName">
                        <EditItemTemplate>
                            <asp:Label ID="IDLabel01" runat="server" Text='<%# Bind("Catalogue_id") %>'></asp:Label>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:Label ID="IDLabel01" runat="server" Text='<%# Bind("Catalogue_id") %>'></asp:Label>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="IDLabel01" runat="server" Text='<%# Bind("Catalogue_id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Наименование" SortExpression="CatalogueName">
                        <EditItemTemplate>
                            <asp:TextBox ID="CatalogueNameTextBox" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="CatalogueNameTextBox" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="CatalogueNameLabel" runat="server" Text='<%# Bind("CatalogueName") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="URL" SortExpression="Link">
                        <EditItemTemplate>
                            <asp:TextBox ID="LinkTextBox" runat="server" Text='<%# Bind("Link") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="LinkTextBox" runat="server" Text='<%# Bind("Link") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <a href='<%# Eval("Link") %>'><%# Eval("Link") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Описание" SortExpression="CatalogueDescription">
                        <EditItemTemplate>
                            <asp:TextBox ID="CatalogueDescriptionTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("CatalogueDescription") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="CatalogueDescriptionTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("CatalogueDescription") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:TextBox ID="CatalogueDescriptionTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("CatalogueDescription") %>' ReadOnly="True"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Правила оформления" SortExpression="OrderingRules">
                        <EditItemTemplate>
                            <asp:TextBox ID="OrderingRulesTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("OrderingRules") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="OrderingRulesTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("OrderingRules") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:TextBox ID="OrderingRulesTextBox" runat="server" TextMode="Multiline" Text='<%# Bind("OrderingRules") %>' ReadOnly="True"></asp:TextBox>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Видео-инструкция" SortExpression="VideoLink">
                        <EditItemTemplate>
                            <asp:TextBox ID="VideoLinkTextBox" runat="server" Text='<%# Bind("VideoLink") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="VideoLinkTextBox" runat="server" Text='<%# Bind("VideoLink") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <a href='<%# Eval("VideoLink") %>'><%# Eval("VideoLink") %></a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Активный" SortExpression="Active">
                        <EditItemTemplate>
                            <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Без фрейма" SortExpression="NoFrame">
                        <EditItemTemplate>
                            <asp:CheckBox ID="NoFrameCheckBox" runat="server" Checked='<%# Bind("NoFrame") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="NoFrameCheckBox" runat="server" Checked='<%# Bind("NoFrame") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="NoFrameCheckBox" runat="server" Checked='<%# Bind("NoFrame") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Порядок сортировки" SortExpression="SortOrder">
                        <EditItemTemplate>
                            <asp:TextBox ID="SortOrderTextBox" runat="server" Text='<%# Bind("SortOrder") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="SortOrderTextBox" runat="server" Text='<%# Bind("SortOrder") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="SortOrderLabel" runat="server" Text='<%# Bind("SortOrder") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Мужчинам" SortExpression="Men">
                        <EditItemTemplate>
                            <asp:CheckBox ID="MenCheckBox" runat="server" Checked='<%# Bind("Men") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="MenCheckBox" runat="server" Checked='<%# Bind("Men") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="MenCheckBox" runat="server" Checked='<%# Bind("Men") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Женщинам" SortExpression="Women">
                        <EditItemTemplate>
                            <asp:CheckBox ID="WomenCheckBox" runat="server" Checked='<%# Bind("Women") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="WomenCheckBox" runat="server" Checked='<%# Bind("Women") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="WomenCheckBox" runat="server" Checked='<%# Bind("Women") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Детям" SortExpression="Chilrden">
                        <EditItemTemplate>
                            <asp:CheckBox ID="ChildrenCheckBox" runat="server" Checked='<%# Bind("Chilrden") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="ChildrenCheckBox" runat="server" Checked='<%# Bind("Chilrden") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="ChildrenCheckBox" runat="server" Checked='<%# Bind("Chilrden") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Обувь" SortExpression="Shoes">
                        <EditItemTemplate>
                            <asp:CheckBox ID="ShoesCheckBox" runat="server" Checked='<%# Bind("Shoes") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="ShoesCheckBox" runat="server" Checked='<%# Bind("Shoes") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="ShoesCheckBox" runat="server" Checked='<%# Bind("Shoes") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    
                    <asp:TemplateField HeaderText="Спорт" SortExpression="Sport">
                        <EditItemTemplate>
                            <asp:CheckBox ID="SportCheckBox" runat="server" Checked='<%# Bind("Sport") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="SportCheckBox" runat="server" Checked='<%# Bind("Sport") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="SportCheckBox" runat="server" Checked='<%# Bind("Sport") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Дом" SortExpression="Home">
                        <EditItemTemplate>
                            <asp:CheckBox ID="HomeCheckBox" runat="server" Checked='<%# Bind("Home") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="HomeCheckBox" runat="server" Checked='<%# Bind("Home") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="HomeCheckBox" runat="server" Checked='<%# Bind("Home") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Косметика" SortExpression="Makeup">
                        <EditItemTemplate>
                            <asp:CheckBox ID="MakeupCheckBox" runat="server" Checked='<%# Bind("Makeup") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="MakeupCheckBox" runat="server" Checked='<%# Bind("Makeup") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="MakeupCheckBox" runat="server" Checked='<%# Bind("Makeup") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Ювелирные украшения" SortExpression="Jems">
                        <EditItemTemplate>
                            <asp:CheckBox ID="JemsCheckBox" runat="server" Checked='<%# Bind("Jems") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="JemsCheckBox" runat="server" Checked='<%# Bind("Jems") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="JemsCheckBox" runat="server" Checked='<%# Bind("Jems") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Премиум" SortExpression="Premium">
                        <EditItemTemplate>
                            <asp:CheckBox ID="PremiumCheckBox" runat="server" Checked='<%# Bind("Premium") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="PremiumCheckBox" runat="server" Checked='<%# Bind("Premium") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="PremiumCheckBox" runat="server" Checked='<%# Bind("Premium") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Эконом" SortExpression="Economy">
                        <EditItemTemplate>
                            <asp:CheckBox ID="EconomyCheckBox" runat="server" Checked='<%# Bind("Economy") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="EconomyCheckBox" runat="server" Checked='<%# Bind("Economy") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="EconomyCheckBox" runat="server" Checked='<%# Bind("Economy") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Коэфициент наценки" SortExpression="PriceIndex">
                        <EditItemTemplate>
                            <asp:TextBox ID="PriceIndexTextBox" runat="server" Text='<%# Bind("PriceIndex") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="PriceIndexTextBox" runat="server" Text='<%# Bind("PriceIndex") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="PriceIndexLabel" runat="server" Text='<%# Bind("PriceIndex", "{0:#,#.00}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Без возвратов" SortExpression="NoReturn">
                        <EditItemTemplate>
                            <asp:CheckBox ID="NoreturnCheckBox" runat="server" Checked='<%# Bind("NoReturn") %>' />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:CheckBox ID="NoreturnCheckBox" runat="server" Checked='<%# Bind("NoReturn") %>' />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:CheckBox ID="NoreturnCheckBox" runat="server" Checked='<%# Bind("NoReturn") %>' Enabled="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Минимальная цена артикула" SortExpression="MinPrice">
                        <EditItemTemplate>
                            <asp:TextBox ID="MinPriceTextBox" runat="server" Text='<%# Bind("MinPrice") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="MinPriceTextBox" runat="server" Text='<%# Bind("MinPrice") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="MinPriceLabel" runat="server" Text='<%# Bind("MinPrice", "{0:#,#.00}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Стоимость доставки" SortExpression="WeightFee">
                        <EditItemTemplate>
                            <asp:TextBox ID="WeightFeeTextBox" runat="server" Text='<%# Bind("WeightFee") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="WeightFeeTextBox" runat="server" Text='<%# Bind("WeightFee") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="WeightFeeLabel" runat="server" Text='<%# Bind("WeightFee", "{0:#,#.00}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Формат артикула" SortExpression="ArticleRegularExpression">
                        <EditItemTemplate>
                            <asp:TextBox ID="ArticleRegularExpressionTextBox" runat="server" Text='<%# Bind("ArticleRegularExpression") %>'></asp:TextBox>
                            (<a href="http://goo.gl/96hQq0" target="_blank">?</a>)
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="ArticleRegularExpressionTextBox" runat="server" Text='<%# Bind("ArticleRegularExpression") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="ArticleRegularExpressionLabel" runat="server" Text='<%# Bind("ArticleRegularExpression") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Комментарий к формату артикула" SortExpression="ArticleComment">
                        <EditItemTemplate>
                            <asp:TextBox ID="ArticleCommentTextBox" runat="server" Text='<%# Bind("ArticleComment") %>'></asp:TextBox>
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:TextBox ID="ArticleCommentTextBox" runat="server" Text='<%# Bind("ArticleComment") %>'></asp:TextBox>
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="ArticleCommentLabel" runat="server" Text='<%# Bind("ArticleComment") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ShowHeader="False">
                        <EditItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Update" Title="OK" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </EditItemTemplate>
                        <InsertItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/OK.png" CausesValidation="False" CommandName="Insert" Title="OK" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/Cancel.png" CausesValidation="False" CommandName="Cancel" Title="Отмена" />
                        </InsertItemTemplate>
                        <ItemTemplate>
                            <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Images/Buttons/Edit.png" CausesValidation="False" CommandName="Edit" Title="Редактировать" />
                            <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/Images/Buttons/NewDoc.png" CausesValidation="False" CommandName="New" Title="Создать" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="OrderDetailsUpdateProgress" runat="server" AssociatedUpdatePanelID="CatalogueDetailsUpdatePanel">
        <ProgressTemplate>
            <div class="Warning">
                <asp:Image ID="OrderDetailsLoadImage" runat="server" ImageUrl="~/Images/LoadingProgressCircle.gif" />
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <%--<div class="scrollindex">
        <h3>Наименование</h3>
        <asp:GridView ID="CataloguesGridView" runat="server"
            DataSourceID="CataloguesListSource"
            EnableModelValidation="True"
            AutoGenerateColumns="False"
            GridLines="None"
            DataKeyNames="Catalogue_id">
            <Columns>
                <asp:TemplateField ItemStyle-HorizontalAlign="Left" ShowHeader="False" HeaderText="">
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Select" Text='<% #Bind("CatalogueName") %>'></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <SelectedRowStyle BackColor="#FFFF66" />
        </asp:GridView>
    </div>--%>
</asp:Content>


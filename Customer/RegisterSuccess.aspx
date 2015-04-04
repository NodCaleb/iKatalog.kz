<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesPages.master" AutoEventWireup="true" CodeFile="RegisterSuccess.aspx.cs" Inherits="Customer_Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Ktrade - регистрация</title>
    <link rel="Stylesheet" href="../css/Register.css" />
    <link rel="Stylesheet" href="../css/SideBar.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="background">
        <h1>Регистрация завершена успешно!</h1>
        <p>Благодарим вас за проявленный интерес к нашим услугам, теперь вы можете входить на сайт, при помощи ссылки в правом верхнем углу страницы.</p>
        <asp:Panel id="CredentialsPanel" visible="false" runat="server">
            <p>Ваш логин: <b><asp:Label ID="UserNameLabel" runat="server" Text=""></asp:Label></b>, пароль: <b><asp:Label ID="PasswordLabel" runat="server" Text=""></asp:Label></b>.</p>
            <p>Пароль вы можете поменять в <asp:HyperLink ID="AccountHyperLink" runat="server" NavigateUrl="~/Customer/Account.aspx">личном кабинете</asp:HyperLink>.</p>            
        </asp:Panel>        
        <p>Мы постараемся ответить на вопросы, которые могут у вас возникнуть.</p>
        <h4>Что делать дальше?</h4>
        <p>Если вы уже оформили заказ, необходимо внести предоплату в размере не менее 25% от стоимости заказа, чтобы ваш заказ был отправлен в работу, до того, ваши заказы будут находиться в режиме ожидания. При регулярных заказах рекомендуем оформить договор, чтобы вы смогли получать накопительные бонусы.</p>
        <p>Если вы еще не сделали заказ, рекомендуем ознакомиться со <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active">списком электронных каталогов</a> и <a href="http://ikatalog.kz/UpsellOffers.aspx">горячих предожений</a>.</p>
        <h4>Какие данные нужны для заключения договора?</h4>
        <p>Для оформления договора с нами и регистрации вас в бонусной системе вам необходимо предоставить следующие данные: ФИО, домашний адрес, дата рождения, номер удостоверения личности (или вид на жительство), дата выдачи и кем выдано УДЛ (ВНЖ).</p>
        <h4>Как оплатить?</h4>
        <p>Оплатить можно платежной картой на сайте или&nbsp;же наличными у нас в офисе. На странице <a href="http://ikatalog.kz/StaticPages.aspx?Page=14">Оплата</a> есть подобная информация о способах оплаты.</p>
        <h4>Как заказать?</h4>
        <p>Рекомендуем вам подробно ознакомиться с <a href="http://ikatalog.kz/StaticPages.aspx?Page=1">инструкцией о том, как это делать</a>.</p>
        <h4>Из чего выбирать?!</h4>
        <p>Для начала предлагаем вам ознакомиться со <a href="http://ikatalog.kz/Catalogues.aspx?Tag=active">списком электронных каталогов</a>, по которым вы можете делать заказы on-line, не выходя из дома. Для Вашего удобства каталоги размещены по категориям. Также вы можете посмотреть текущие <a href="http://ikatalog.kz/UpsellOffers.aspx">горячие предложения</a>.</p>
        <h4>Какой размер выбирать?!</h4>
        <p>Для определения вашего размера на сайте в разделе Информация размещены <a href="http://ikatalog.kz/StaticPages.aspx?Page=10">таблицы соответствия и таблицы размеров одежды и обуви</a>.</p>
        <h4>Есть ли накрутка на цену в каталоге?</h4>
        <p>При заказе из некоторых каталогов взимается дополнительный сбор. Это указано под логотипом каталога, например: +18%. Если ничего не указано &mdash; вы получаете товар по цене каталога + доставка.</p>
        <h4>Какова стоимость доставки?</h4>
        <p>Стоимость доставки до нашего офиса в Алматы составляет 5 &euro; / килограмм, также мы можем сделать для вас курьерскую доставку в пределах Алматы или в другие города, подробнее &mdash; в разделе <a href="http://ikatalog.kz/StaticPages.aspx?Page=15">Доставка</a>.</p>
        <h4>Можно ли вернуть заказанный товар?</h4>
        <p>Некоторые из он-лайн магазинов, к сожалению, работают без возвратов (MyToys, YOOX, ZARA и др.). Это так же обозначено специальным значком рядом с логотипом каталога. При заказе c остальных каталогов можно вернуть заказанный товар, оплатив при этом стоимость доставки.</p>
        <hr />
        <p>С уважением, Галина<br />
        Директор <a href="http://ikatalog.kz/">iKatalog.kz</a><br />
        Skype: ikatalog<br />
        Тел.: +7 701 543 62 59<br />
        мкн Аксай 5<br />
        <a href="http://ikatalog.kz/Contacts.aspx">Схема проезда</a></p>
    </div>
    <!-- Google Code for &#1056;&#1077;&#1075;&#1080;&#1089;&#1090;&#1088;&#1072;&#1094;&#1080;&#1103; &#1085;&#1072; iKatalog Conversion Page -->
    <script type="text/javascript">
    /* <![CDATA[ */
    var google_conversion_id = 1002578196;
    var google_conversion_language = "en";
    var google_conversion_format = "3";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "4a-KCKSA3lcQlMKI3gM";
    var google_remarketing_only = false;
    /* ]]> */
    </script>
    <script type="text/javascript" src="//www.googleadservices.com/pagead/conversion.js">
    </script>
    <noscript>
    <div style="display:inline;">
    <img height="1" width="1" style="border-style:none;" alt="" src="//www.googleadservices.com/pagead/conversion/1002578196/?label=4a-KCKSA3lcQlMKI3gM&amp;guid=ON&amp;script=0"/>
    </div>
    </noscript>
</asp:Content>


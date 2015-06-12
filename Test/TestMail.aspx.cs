using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data.Common;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using System.Configuration;

public partial class Test_TestGeneral : System.Web.UI.Page
{
    public ClientScriptManager CSM;
    
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string RegisterRequestString = "insert into AskMeRequests (Name, Email, Phone, Request) values (@Name, @Email, @Phone, @Request)";
    SqlCommand RegisterRequest = new SqlCommand(RegisterRequestString, iKConnection);
    static string GetUserAliasString = "select Alias, ContractNumber from UserView where UserName = @UserName";
    static SqlCommand GetUserAlias = new SqlCommand(GetUserAliasString, iKConnection);

    private static string CreateSalt(int size)
    {
        //Generate a cryptographic random number.
        RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
        byte[] buff = new byte[size];
        rng.GetBytes(buff);

        // Return a Base64 string representation of the random number.
        return Convert.ToBase64String(buff);
    }    
    protected void Page_Load(object sender, EventArgs e)
    {
	CSM = Page.ClientScript;
	if (iKConnection.State.ToString() == "Closed") iKConnection.Open();

        
    }
    protected void Button_Click(object sender, EventArgs e)
    {
	TestLabel.Text = "";
	string Login = LoginInput.Text;
	string Password = PasswordInput.Text;
	string Email = EmailInput.Text;
	string FirstName = FirstNameInput.Text;
	string LastName = LastNameInput.Text;
	string Phone = PhoneInput.Text;
	string Address = AddressInput.Text;

    SmtpClient TEPSMTP = new SmtpClient();

    TEPSMTP.Host = "smtp.ikatalog.kz";
    TEPSMTP.Port = 25;
    //TEPSMTP.EnableSsl = true;
    TEPSMTP.Timeout = 10000;
    TEPSMTP.DeliveryMethod = SmtpDeliveryMethod.Network;
    TEPSMTP.UseDefaultCredentials = true;
    TEPSMTP.Credentials = new System.Net.NetworkCredential("admin@ikatalog.kz", "3SUxRU5UT5mq");

    MailAddress TEP = new MailAddress("admin@ikatalog.kz", "Личный кабинет Теполэнергопроф");
    MailAddress Office = new MailAddress("nod.caleb@gmail.com", "Офис");

    MailMessage FeedBackMessage = new MailMessage();
    FeedBackMessage.From = TEP;
    FeedBackMessage.To.Add(Office);
    //FeedBackMessage.ReplyTo = Office;
    FeedBackMessage.IsBodyHtml = true;
    FeedBackMessage.BodyEncoding = System.Text.Encoding.UTF8;
    FeedBackMessage.Subject = "Отзыв в личном кабинете";
    FeedBackMessage.Body = "<p>Содержание отзыва:</p><p><em>" + AddressInput.Text + "</em></p>";

    TEPSMTP.Send(FeedBackMessage);


	//SendNotifcations(Login, Password, Email, FirstName, LastName, Phone, Address);


	
	TestLabel.Text = "Типа отправили...";
    }
    protected void SendNotifcations(string Login, string Password, string Email, string FirstName, string LastName, string Phone, string Address)
    {
        SmtpClient KtradeSMTP = new SmtpClient();

        MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
        MailAddress Sale = new MailAddress(Email, "Отдел продаж");
        MailAddress Office = new MailAddress(Email, "Офис");
        MailAddress Customer = new MailAddress(Email, FirstName + " " + LastName);

        //string Alias = "N/A";
	
	if (GetUserAlias.Parameters.Count != 0) GetUserAlias.Parameters.Clear();

        GetUserAlias.Parameters.AddWithValue("UserName", Login);
		
	SqlDataReader AliasReader = GetUserAlias.ExecuteReader();
        AliasReader.Read();

        string Alias = AliasReader["Alias"].ToString();
	string ContractNumber = AliasReader["ContractNumber"].ToString();
		
	AliasReader.Close();

        //Сообщение для продавца
        MailMessage NotifySeller = new MailMessage();
        NotifySeller.From = Admin;
        //NotifySeller.To.Add(Sale);
        NotifySeller.To.Add(Office);
        //NotifySeller.To.Add(Admin); //Для тестирования
        NotifySeller.IsBodyHtml = true;
        NotifySeller.BodyEncoding = System.Text.Encoding.UTF8;
        NotifySeller.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifySeller.Subject = "Новый пользователь на сайте: " + FirstName + " " + LastName;
        NotifySeller.Body = "";
        NotifySeller.Body += "<h3>У нас на сайте завелся новый пользователь:</h3>";
        NotifySeller.Body += "<table border=\"0\" style=\"border-style:none\" cellspacing=\"0\" cellpadding=\"5px\"> ";
        NotifySeller.Body += "<tr> <td> Имя </td> <td> " + FirstName + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Фамилия </td> <td> " + LastName + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Логин </td> <td> " + Login + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Пароль </td> <td> " + Password + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Email </td> <td> " + Email + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Псевдоним </td> <td> " + Alias + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Телефон </td> <td> " + Phone + " </td> </tr> ";
        NotifySeller.Body += "<tr> <td> Адрес </td> <td> " + Address + " </td> </tr> ";
	NotifySeller.Body += "<tr> <td> Договор № </td> <td>" + ContractNumber + "</td> </tr> ";
        NotifySeller.Body += "</trable>";

        //Сообщение для покупателя
        MailMessage NotifyCustomer = new MailMessage();
        NotifyCustomer.From = Admin;
        NotifyCustomer.To.Add(Customer);
        NotifyCustomer.ReplyTo = Office;
        //NotifyCustomer.To.Add(Admin); //Для тестирования
        NotifyCustomer.IsBodyHtml = true;
        NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.Subject = "Подтверждение регистрации на iKatalog.kz";
        NotifyCustomer.Body = "";
        NotifyCustomer.Body = "<p>Здравствуйте, " + FirstName + " " + LastName + ", ";
        NotifyCustomer.Body += "ваша регистрация на <a href=\"http://ikatalog.kz\">iKatalog</a> подтверждена. </p>";
        NotifyCustomer.Body += "<p>Имя пользователя для входа в систему: " + Login + "<br />";
        NotifyCustomer.Body += "Пароль для входа в систему: " + Password + "<br />";
	NotifyCustomer.Body += "Номер договора для оплаты через терминалы Qiwi: " + ContractNumber + "</p>";
        //NotifyCustomer.Body += "<p><b><small>Пожалуйста, не отвечайте на это письмо, робот читать не умеет!</small></b></p><p><small>Чтобы связаться с нами, пишите на <a href=\"mailto:sale@ikatalog.kz\">sale@ikatalog.kz</a>.</small></p>";

        //И еще одно для покупателя
        MailMessage ThankCustomer = new MailMessage();

        ThankCustomer.From = Admin;
        ThankCustomer.To.Add(Customer);
        ThankCustomer.ReplyTo = Sale;
        ThankCustomer.IsBodyHtml = true;
        ThankCustomer.BodyEncoding = System.Text.Encoding.UTF8;
        ThankCustomer.SubjectEncoding = System.Text.Encoding.UTF8;

        //TestMessage.Sender = MailSender;
        //TestMessage.To.Add(MailReceiver);
        ThankCustomer.Subject = "Благодарим за регистрацию!";
        ThankCustomer.Body = "<h4>Здравствуйте, " + FirstName + "</h4><html><head>	<title></title></head><body><p>Благодарим вас за проявленный интерес к нашим услугам!</p><p>В этом письме мы постораемся ответить на вопросы, которые могут у вас возникнуть.</p><h4>Что делать дальше?</h4><p>Если вы уже оформили заказ, необходимо внести предоплату в размере не менее 25% от стоимости заказа, чтобы ваш заказ был отправлен в работу, до того, ваши заказы будут находиться в режиме ожидания. При регулярных заказах рекомендуем оформить договор, чтобы вы смогли получать накомительные бонусы.</p><p>Если вы еще не сделили заказ, рекомендуем ознакомиться со <a href=\"http://ikatalog.kz/Catalogues.aspx?Tag=active\">списком электронных каталогов</a> и <a href=\"http://ikatalog.kz/UpsellOffers.aspx\">горячих предожений</a>, также вы можете <a href=\"http://ikatalog.kz/Customer/OrdersPry.aspx\">посмотреть, что заказывают другие</a>.</p><h4>Какие данные нужны для заключения договора?</h4><p>Для оформления договора с нами и регистрации вас в бонусной системе вам необходимо предоставить следующие данные: ФИО, домашний адрес, дата рождения, номер удостоверения личности (или вид на жительство), дата выдачи и кем выдано УДЛ (ВНЖ).</p><h4>Как оплатить?</h4><p>Оплатить можно платежной картой на сайте или&nbsp;же наличными у нас в офисе. На странице <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=14\">Оплата</a> есть подобная информация о способах оплаты.</p><h4>Как заказать?</h4><p>Рекомендуем вам подробно ознакомиться с <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=1\">инструкцией о том, как это делать</a>.</p><h4>Из чего выбирать?!</h4><p>Для начала предлагаем вам ознакомиться со <a href=\"http://ikatalog.kz/Catalogues.aspx?Tag=active\">списком электронных каталогов</a>, по которым вы можете делать заказы on-line, не выходя из дома. Для Вашего удобства каталоги размещены по категориям. Также вы можете посмотреть текущие <a href=\"http://ikatalog.kz/UpsellOffers.aspx\">горячие предложения</a>, и&nbsp;<a href=\"http://ikatalog.kz/Customer/OrdersPry.aspx\">что заказывают другие</a>.</p><h4>Какой размер выбирать?!</h4><p>Для определения вашего размера на сайте в разделе Информация размещены <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=10\">таблицы соответствия и таблицы размеров одежды и обуви</a>.</p><h4>Есть ли накрутка на цену в каталоге?</h4><p>При заказе из некоторых каталогов взимается дополнительный сбор. Это указано под логотипом каталога, например: +18%. Если ничего не указано &mdash; вы получаете товар по цене каталога + доставка.</p><h4>Какова стоимость доставки?</h4><p>Стоимость доставки до нашего офиса в Алматы составляет 5 &euro; / килограмм, также мы можем сделать для вас курьерскую доставку в пределах Алматы или в другие города, подробнее &mdash; в разделе <a href=\"http://ikatalog.kz/StaticPages.aspx?Page=15\">Доставка</a>.</p><h4>Можно ли вернуть заказанный товар?</h4><p>Некоторые из он-лайн магазинов, к сожалению, работают без возвратов (MyToys, YOOX, ZARA и др.). Это так же обозначено специальным значком рядом с логотипом каталога. При заказе c остальных каталогов можно вернуть заказанный товар, оплатив при этом стоимость доставки.</p><hr /><p>С уважением, Галина<br />Руководитель проекта <a href=\"http://ikatalog.kz/\">iKatalog.kz</a><br />Skype: ikatalog<br />Тел.: +7 701 543 62 59<br />мкн Аксай 5<br /><a href=\"http://ikatalog.kz/Contacts.aspx\">Схема проезда</a></p></body></html>";

        KtradeSMTP.Send(NotifySeller);
        KtradeSMTP.Send(NotifyCustomer);
        KtradeSMTP.Send(ThankCustomer);

        NotifyCustomer.Dispose();
        NotifySeller.Dispose();
        ThankCustomer.Dispose();
    }
}
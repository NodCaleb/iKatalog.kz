using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;
using System.IO;
using System.Text;
using iKGlobal;

public partial class Customer_NewOrder : System.Web.UI.Page
{
    static GlobalClass iClass = new GlobalClass();
    
    public ClientScriptManager CSM;
    static string iKConnectionString = ConfigurationManager.ConnectionStrings["iKConnectionString"].ConnectionString;
    static SqlConnection iKConnection = new SqlConnection(iKConnectionString);
    static string DeleteitemString = "delete from OrderItems where id = @Line_id";
    static string ArrangeOrderString = "ArrangeOrderBySession";
    static string DuplicateItemString = "DuplicateItem";
    static string AddItemString = "insert into OrderItems (Order_id, Catalogue_id, Article_id, ArticleName, Price, Size, Colour, Comment, LineStatus, KtradeStatus_id, Customer_id, Session_id) values (-1, @Catalogue_id, @Article_id, @ArticleName, @Price, @Size, @Colour, @Comment, 10, 1, @Customer_id, @Session_id)";
    static string OrderHeaderString = "select CustomerName, CustomerMail, ContractNumber from OrderList where Order_id = @Order_id";
    static string OrderTableString = "select CatalogueName, Article_id, ArticleName, Comment, Size, Colour, Price from OrderDetailsView where Order_id = @Order_id";
    static string OrderExportString = "select [Klient], [PVU-Card Nr.], [Katalog], [Art.Nr.], [Cena], [Nazwanie], [Razmer], [Zwet], [Primechanie] from KtradeExportView where Order_id = @Order_id";
    static string CatalogueInfoString = "select ArticleRegularExpression, ArticleComment, replace (convert(nvarchar(8), MinPrice), '.', ',') as MinPrice, WeightFee, 'Условия работы по каталогу ' + CatalogueName + ':<br/>Минимальная цена артикула — ' + replace (convert(nvarchar(8), MinPrice), '.', ',') + ' €<br/>Стоимость доставки — ' + replace (convert(nvarchar(8), WeightFee), '.', ',') + ' € / кг.' + case NoReturn when 1 then '<br/>Возврат, обмен и отказ не предусмотрен.' else '' end as TermsDescription from Catalogues where Catalogue_id = @Catalogue_id";
    static string OrderAmmountBasketString = "select REPLACE(CONVERT (nvarchar(10), ROUND (SUM (OI.Price * C.PriceIndex), 2)), '.', ',') + ' €' + case @DiscountIndex when '1' then '' else ',<b> с учетом скидки в ' + replace (convert(nvarchar(10), (1 - convert(money, @DiscountIndex)) * 100), '.00', '') + '% — ' + REPLACE(CONVERT (nvarchar(10), ROUND (SUM (OI.Price * C.PriceIndex) * convert(money, @DiscountIndex), 2)), '.', ',') + ' €</b>' end  as Ammount from OrderItems as OI join Catalogues as C on C.Catalogue_id = OI.Catalogue_id where OI.Session_id = @Session_id and Order_id = -1";
    static string PureCartValueString = "select ROUND (SUM (OI.Price * C.PriceIndex) * convert(money, @DiscountIndex), 2) as Ammount from OrderItems as OI join Catalogues as C on C.Catalogue_id = OI.Catalogue_id where OI.Session_id = @Session_id and Order_id = -1";
    static string OrderAmmountPaymentString = "select convert (varchar(10),OrderAmmountIndexed) as OrderAmmount from OrderList where order_id = @Order_id";
    static string OrderAmmountMailString = "select OrderAmmountMail as OrderAmmount from OrderList where order_id = @Order_id";
    static string SaveMetaDataString = "insert into OrdersMetaData (Order_id, CustomerFullName, CustomerEmail, CustomerPhone, DeliveryAddress, DeliveryMethod, PaymentMethod) values (@Order_id, @CustomerFullName, @CustomerEmail, @CustomerPhone, @DeliveryAddress, @DeliveryMethod, @PaymentMethod)";
    static string GetUserNameString ="select C.FirstName + ' ' + C.LastName as FullName, M.Email from Customers as C join aspnet_Membership as M on C.User_id = M.UserID where C.Customer_id = @Customer_id";
    static string ValidateCouponString = "select dbo.VerifyCoupon (@Number, @Customer_id) as Result";
    static string GetCouponDescriptionString = "select Number + ' (' + left (convert (nvarchar(10), (DiscountValue - 1) * 100), len(convert (nvarchar(10), (DiscountValue - 1) * 100)) - 3) + '%)' as CouponDescription from DiscountCoupons where id = @Coupon_id";
    static string RegisterCouponString = "update DiscountCoupons set Order_id = isnull(Order_id , @Order_id) where id = @Coupon_id";
    static string GetDiscountValueString = "select convert (nvarchar(5), DiscountValue) as DiscountValue from DiscountCoupons where id = @Coupon_id";
    static string TermsDescriptionString = "select * from CatalogueTermsDescription where Catalogue_id = @Catalogue_id";
    
    SqlCommand AddItem = new SqlCommand(AddItemString, iKConnection);
    SqlCommand DeleteItem = new SqlCommand(DeleteitemString, iKConnection);
    SqlCommand ArrangeOrder = new SqlCommand(ArrangeOrderString, iKConnection);
    SqlCommand DuplicateItem = new SqlCommand(DuplicateItemString, iKConnection);
    SqlCommand OrderHeader = new SqlCommand(OrderHeaderString, iKConnection);
    SqlCommand OrderTable = new SqlCommand(OrderTableString, iKConnection);
    SqlCommand OrderExport = new SqlCommand(OrderExportString, iKConnection);
    SqlCommand CatalogueInfo = new SqlCommand(CatalogueInfoString, iKConnection);
    SqlCommand OrderAmmountBasket = new SqlCommand(OrderAmmountBasketString, iKConnection);
    SqlCommand PureCartValue = new SqlCommand(PureCartValueString, iKConnection);
    SqlCommand OrderAmmountPayment = new SqlCommand(OrderAmmountPaymentString, iKConnection);
    SqlCommand OrderAmmountMail = new SqlCommand(OrderAmmountMailString, iKConnection);
    SqlCommand SaveMetaData = new SqlCommand(SaveMetaDataString, iKConnection);
    SqlCommand GetUserData = new SqlCommand(GetUserNameString, iKConnection);
    SqlCommand ValidateCouponCommand = new SqlCommand(ValidateCouponString, iKConnection);
    SqlCommand GetCouponDescription = new SqlCommand(GetCouponDescriptionString, iKConnection);
    SqlCommand RegisterCouponCommand = new SqlCommand(RegisterCouponString, iKConnection);
    SqlCommand GetDiscountValue = new SqlCommand(GetDiscountValueString, iKConnection);
    SqlCommand TermsDescription = new SqlCommand(TermsDescriptionString, iKConnection);
    
    static decimal MinPrice;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (iKConnection.State.ToString() == "Closed") iKConnection.Open();
        CSM = Page.ClientScript;
	
	Page.MetaDescription = "Оформить заказ на сайте ikatalog.kz вы можете на странице оформления нового заказа, вам нужно лишь знать каталог, из которого вы делаете заказа, артикул товара, цену, цвет и размер вещи.";
	OrderDetailsSource.SelectParameters["Session"].DefaultValue = HttpContext.Current.Session.SessionID.ToString();
	CheckVisibility();
	CheckConfirmationPosibility();
	CheckAuth();
	SetPaymentOptions();
    }
    protected override void Render(HtmlTextWriter writer)
    {
        CSM.RegisterForEventValidation(OrderDetailsGridView.UniqueID.ToString());        
        base.Render(writer);
    }
    protected void OrderDetailsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteLine")
        {
            DeleteItem.Parameters.AddWithValue("Line_id", e.CommandArgument.ToString());
            DeleteItem.ExecuteNonQuery();
            OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
        }
        if (e.CommandName == "DuplicateLine")
        {
            if (DuplicateItem.Parameters.Count != 0) DuplicateItem.Parameters.Clear();
            DuplicateItem.CommandType = CommandType.StoredProcedure;
            SqlParameter Line_id = new SqlParameter("@Line_id", SqlDbType.Int);
            Line_id.Value = e.CommandArgument.ToString();
            Line_id.Direction = ParameterDirection.Input;
            DuplicateItem.Parameters.Add(Line_id);

            //DuplicateItem.Parameters.AddWithValue("id", e.CommandArgument.ToString());
            DuplicateItem.ExecuteNonQuery();
            OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
        }
    }
    protected void OrderDetailsGridView_DataBound(object sender, EventArgs e)
    {
        if (OrderDetailsGridView.Rows.Count == 0)
        {
            ConfirmOrderButton.Visible = false;
	    EmptyOrderLabel.Text = "Корзина пуста";
	    AuthPanel.Visible = false;
	    DeliveryAndPaymentPanel.Visible = false;
	    //CataloguesLink.Visible = true;
        }
        else
        {
            ConfirmOrderButton.Visible = true;
	    CheckAuth();
	    DeliveryAndPaymentPanel.Visible = true;
	    //CataloguesLink.Visible = false;
	    SetPaymentOptions();
	    EmptyOrderLabel.Text = "Общая сумма заказа с учетом наценок каталогов, но без доставки: " + GetBasketAmmount();
        }
    }
    protected void ConfirmOrderButton_Click(object sender, EventArgs e)
    {
	//Вот эти данные нужны и для регистрации нового пользака и для оформления заказа
	string Name;
	string Email;
	string Phone = "";
	string Address = "Самовывоз";
	
	if (Membership.GetUser() != null)
	{
	    GetUserData.Parameters.Clear();
	    GetUserData.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
	    
	    SqlDataReader UserNameReader = GetUserData.ExecuteReader();
	    UserNameReader.Read();
	    
	    Name = UserNameReader["FullName"].ToString();
	    Email = UserNameReader["Email"].ToString();
	}
	else
	{
	    Name = FullNameTextBox.Text;
	    Email = EmailTextBox.Text;
	    Phone = PhoneTextBox.Text;
	}
	
	bool newCustomer = false;
		
	if (AuthList.SelectedIndex == 0 && Membership.GetUser() == null)
	{
	    if (iClass.CheckEmailExistence(Email))
	    {
		EmailUniquenessValidator.IsValid = false;
		//iClass.CreateLog("Email exist", "Checkout");
	    }
	    else
	    {
		EmailUniquenessValidator.IsValid = true;
		//iClass.CreateLog("Email doesn't exist", "Checkout");
	    }
	    
	    if (Page.IsValid)
	    {   
		//Здесь и далее в качестве имени пользователя используется email
		if (iClass.RegisterCustomerLite(Email, Name, Phone))
		{
		    iClass.SendRegisterNotifcations(Email, Name, Phone);
		    newCustomer = true;
		}
		else
		{
		    Response.Redirect("~/Customer/RegisterFail.aspx");
		}
	    }
	    else
	    {
		return;
	    }
	}
	
	if (ArrangeOrder.Parameters.Count != 0) ArrangeOrder.Parameters.Clear();
	ArrangeOrder.CommandType = CommandType.StoredProcedure;
	
	SqlParameter Customer = new SqlParameter("@Customer_id", SqlDbType.Int);
	//if (Membership.GetUser() != null) Customer.Value = Session["Customer"].ToString();
	if (Membership.GetUser() != null) Customer.Value = iClass.getCustomerIdForUser(Membership.GetUser().ProviderUserKey.ToString());
	else Customer.Value = iClass.GetCustomerIDByLogin(Email);
	Customer.Direction = ParameterDirection.Input;
	ArrangeOrder.Parameters.Add(Customer);
	
	SqlParameter SessionID = new SqlParameter("@Session_id", SqlDbType.NVarChar);
	SessionID.Value = HttpContext.Current.Session.SessionID.ToString();
	SessionID.Direction = ParameterDirection.Input;
	ArrangeOrder.Parameters.Add(SessionID);
	
	SqlParameter Order = new SqlParameter("@Order_id", SqlDbType.Int);
	Order.Direction = ParameterDirection.Output;
	ArrangeOrder.Parameters.Add(Order);
	
	iClass.CreateLog("Order is ready to be arranged for Customer: " + Customer.Value.ToString() + ", on session: " + SessionID.Value.ToString(), "Checkout.txt");

	ArrangeOrder.ExecuteNonQuery();
	
	iClass.CreateLog("Order #: " + Order.Value.ToString() + " has been arranged", "Checkout.txt");
	
	if (DeliveryList.SelectedIndex == 1) Address = AddressTextBox.Text;
	
	SaveOrderMetaData (Order.Value.ToString(), Name, Email, Phone, Address, DeliveryList.SelectedIndex, PaymentList.SelectedIndex);
	
	if (Session["Coupon"] != null)
	{
	    RegisterCoupon(Session["Coupon"].ToString(), Order.Value.ToString());
	    Session["Coupon"] = null;
	}
	
	SendNotifications(Order.Value.ToString(), Address, PaymentList.SelectedIndex);
	
	float amount = iClass.GetCumulatedOrders(Session["Customer"].ToString());
	
	if (iClass.GetCumulatedOrders(Session["Customer"].ToString()) >= 200)
	{
	    int CustomerForCoupon;
	    try
	    {
		CustomerForCoupon = Int32.Parse(Session["Customer"].ToString());
		string couponNumber = iClass.CraftCoupon(CustomerForCoupon, 0.95f, 7);
		iClass.SendCouponIssueNotifcations(couponNumber);
	    }
	    catch
	    {
		iClass.CreateLog("Не выдался купон вот этому покупателю:" + Session["Customer"].ToString(), "Checkout.txt");
	    }
	    
	}

	//if (PaymentList.SelectedIndex == 2) Response.Redirect("~/Customer/PaymentCardAutomated.aspx?ammount=" + GetOrderAmmountPayment(Order.Value.ToString()));
	if (PaymentList.SelectedIndex == 2) Response.Redirect("~/Customer/PaymentCardAutomated.aspx?ammount=" + PaymentOptionsList.SelectedValue.ToString() + "&order=" + Order.Value.ToString());
	else if (newCustomer)
	{
		
		FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(Email.ToString(), true, 30);
		string encTicket = FormsAuthentication.Encrypt(ticket);

		Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));

		Response.Redirect("~/OrderThanks.aspx?customer=" + Email.ToString());
	}
	else Response.Redirect("~/OrderThanks.aspx");
    }
    public void SendNotifications(string Order_id, string Address, int PaymentMethod)
    {
        OrderTable.Parameters.AddWithValue("Order_id", Order_id);
        OrderHeader.Parameters.AddWithValue("Order_id", Order_id);

        SqlDataReader HeaderReader = OrderHeader.ExecuteReader();

        HeaderReader.Read();
		
	string ContractNumber = HeaderReader["ContractNumber"].ToString();
	string customerMail = HeaderReader["CustomerMail"].ToString();
	string customerName = HeaderReader["CustomerName"].ToString();
	
	HeaderReader.Close();

        SmtpClient KtradeSMTP = new SmtpClient();
    
	//Адреса mail
        MailAddress Admin = new MailAddress("admin@ikatalog.kz", "iKatalog"); //Отправитель сообщения
        MailAddress Sale = new MailAddress("eg@ikatalog.kz", "Отдел продаж");
        MailAddress Office = new MailAddress("es@ikatalog.kz", "Сергей");
        MailAddress Customer = new MailAddress(customerMail, customerName);
	
        //Сообщение для продавца
	MailMessage NotifySeller = new MailMessage();
        NotifySeller.From = Admin;
        NotifySeller.To.Add(Sale);
        NotifySeller.To.Add(Office);
        NotifySeller.To.Add("admin@iKatalog.kz"); //Для тестирования
        NotifySeller.IsBodyHtml = true;
        NotifySeller.BodyEncoding = System.Text.Encoding.UTF8;
        NotifySeller.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifySeller.Subject = iClass.GetMailSubject(5); //"Заказ № " + Order_id + ", покупатель: " + HeaderReader["CustomerName"];
	NotifySeller.Body = iClass.GetMailBody(5);
	
        //Сообщение для покупателя
	MailMessage NotifyCustomer = new MailMessage();
        NotifyCustomer.From = Admin;
        NotifyCustomer.To.Add(Customer);
	NotifyCustomer.To.Add(Office);
        NotifyCustomer.ReplyTo = Office;
        //NotifyCustomer.To.Add("admin@iKatalog.kz"); //Для тестирования
        NotifyCustomer.IsBodyHtml = true;
        NotifyCustomer.BodyEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.SubjectEncoding = System.Text.Encoding.UTF8;
        NotifyCustomer.Subject = iClass.GetMailSubject(6); //"Ваш заказ №" + Order_id.ToString();
	NotifyCustomer.Body = iClass.GetMailBody(6);

        //Таблица с данными заказа в тело сообщений
        string orderTable = "<table border=\"1\" style=\"border-style:solid\" cellspacing=\"0\"> <tr> <th> Каталог </th> <th> Артикул </th> <th> Наименование </th> <th> Цена </th> <th> Размер </th> <th> Цвет </th> </tr>";

        SqlDataReader TableReader = OrderTable.ExecuteReader();

        while (TableReader.Read())
        {
            orderTable += "<tr> <td> " + TableReader["CatalogueName"] + " </td> <td> " + TableReader["Article_id"] + " </td> <td> <a href=\"" + TableReader["Comment"] + "\">" + TableReader["ArticleName"] + "</a> </td> <td> " + TableReader["Price"] + " </td> <td> " + TableReader["Size"] + " </td> <td> " + TableReader["Colour"] + " </td> </tr>";
        }
	
	TableReader.Close();
	
	orderTable += "</table>";
	
	//Заменяем шаблоны в сообщениях на конкретные данные
	
	NotifySeller.Subject = NotifySeller.Subject.Replace("%USER_NAME%", customerName).Replace("%ORDER_NUMBER%", Order_id);
	NotifyCustomer.Subject = NotifyCustomer.Subject.Replace("%ORDER_NUMBER%", Order_id);
	
	NotifySeller.Body = NotifySeller.Body.Replace("%ORDER_CONTENT_TABLE%", orderTable).Replace("%ORDER_AMMOUNT%", GetOrderAmmountMail(Order_id)).Replace("%DELIVERY_ADDRESS%", Address);
	NotifyCustomer.Body = NotifyCustomer.Body.Replace("%ORDER_CONTENT_TABLE%", orderTable).Replace("%ORDER_AMMOUNT%", GetOrderAmmountMail(Order_id)).Replace("%DELIVERY_ADDRESS%", Address).Replace("%USER_NAME%", customerName);
	

        if (PaymentMethod == 0)
	{
	    NotifySeller.Body = NotifySeller.Body.Replace("%PAYMENT_METHOD%", "наличными.");
	    NotifyCustomer.Body = NotifyCustomer.Body.Replace("%PAYMENT_INSTRUCTIONS%", "Вы выбрали оплату наличными, для этого свяжитесь, пожалуйста, с менеджером по телефону: +7 701 543-62-59.");
	}
	else if (PaymentMethod == 1)
	{
	    NotifySeller.Body = NotifySeller.Body.Replace("%PAYMENT_METHOD%", "терминал Qiwi.");
	    NotifyCustomer.Body = NotifyCustomer.Body.Replace("%PAYMENT_INSTRUCTIONS%", "Вы можете оплатить ваш заказ через терминалы Qiwi, по номеру договора: " + ContractNumber + ".");
	}
	else if (PaymentMethod == 2)
	{
	    NotifySeller.Body = NotifySeller.Body.Replace("%PAYMENT_METHOD%", "eComCharge.");
	    NotifyCustomer.Body = NotifyCustomer.Body.Replace("%PAYMENT_INSTRUCTIONS%", "Вы можете оплатить ваш заказ непосредственно <a href='http://ikatalog.kz/Customer/PaymentCardAutomated.aspx?ammount=" + GetOrderAmmountPayment(Order_id) + "&order=" + Order_id + "'>на сайте ikatalog.kz на странице оплаты</a>.");
	}
	else if (PaymentMethod == 3)
	{
	    NotifySeller.Body = NotifySeller.Body.Replace("%PAYMENT_METHOD%", "перечислением на карту KazCom.");
	    NotifyCustomer.Body = NotifyCustomer.Body.Replace("%PAYMENT_INSTRUCTIONS%", "Реквизиты для оплаты:</p><p>4003 0327 8462 5107<br/>Еремин Сергей Анатольевич<br/>Казкоммерцбанк<br/>ИИН 760817300158.");
	}
	
	//Отправляем
        KtradeSMTP.Send(NotifySeller);
        KtradeSMTP.Send(NotifyCustomer);
	
	NotifySeller.Dispose();
	NotifyCustomer.Dispose();
    }
    public string GetBasketAmmount ()
    {
	string DiscountIndex;
	if (Session["Coupon"] != null)
	{
	    GetDiscountValue.Parameters.Clear();
	    GetDiscountValue.Parameters.AddWithValue("@Coupon_id", Session["Coupon"].ToString());
	    SqlDataReader GetDiscountReader = GetDiscountValue.ExecuteReader();
	    GetDiscountReader.Read();
	    DiscountIndex = GetDiscountReader["DiscountValue"].ToString();
	    GetDiscountReader.Close();
	}
	else DiscountIndex = "1";
		
	OrderAmmountBasket.Parameters.Clear();
	OrderAmmountBasket.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	OrderAmmountBasket.Parameters.AddWithValue("DiscountIndex", DiscountIndex);
	SqlDataReader OrderAmmountReader = OrderAmmountBasket.ExecuteReader();
	OrderAmmountReader.Read();
	string Ammount = OrderAmmountReader["Ammount"].ToString();
	OrderAmmountReader.Close();
	return Ammount;
    }
    public string GetPureCartValue ()
    {
	string DiscountIndex;
	if (Session["Coupon"] != null)
	{
	    GetDiscountValue.Parameters.Clear();
	    GetDiscountValue.Parameters.AddWithValue("@Coupon_id", Session["Coupon"].ToString());
	    DiscountIndex = GetDiscountValue.ExecuteScalar().ToString();
	}
	else DiscountIndex = "1";
		
	PureCartValue.Parameters.Clear();
	PureCartValue.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	PureCartValue.Parameters.AddWithValue("DiscountIndex", DiscountIndex);
	return PureCartValue.ExecuteScalar().ToString();
    }
    void SetPaymentOptions()
    {
	PaymentOptionsSource.SelectParameters["amount"].DefaultValue = GetPureCartValue().Replace(",",".");
	//PaymentOptionsSource.SelectParameters["amount"].DefaultValue = "10.4";
	//iClass.CreateLog(GetPureCartValue(), "Checkout");
    }
    public string GetOrderAmmountPayment (string Order_id)
    {
	OrderAmmountPayment.Parameters.Clear();
	OrderAmmountPayment.Parameters.AddWithValue("Order_id", Order_id.ToString());
	SqlDataReader OrderAmmountReader = OrderAmmountPayment.ExecuteReader();
	OrderAmmountReader.Read();
	string Ammount = OrderAmmountReader["OrderAmmount"].ToString();
	OrderAmmountReader.Close();
	return Ammount;
    }
    public string GetOrderAmmountMail (string Order_id)
    {
	OrderAmmountMail.Parameters.Clear();
	OrderAmmountMail.Parameters.AddWithValue("Order_id", Order_id.ToString());
	string Ammount = OrderAmmountMail.ExecuteScalar().ToString();
	OrderAmmountMail.Parameters.Clear();
	return Ammount;
    }
    protected void AuthListIndexChanged(object sender, EventArgs e)
    {
	AuthMultiView.Visible = true;
	AuthMultiView.ActiveViewIndex = AuthList.SelectedIndex;
	CheckConfirmationPosibility();
    }
    protected void DeliveryListIndexChanged(object sender, EventArgs e)
    {
	DeliveryMultiView.Visible = true;
	DeliveryMultiView.ActiveViewIndex = DeliveryList.SelectedIndex;
	CheckConfirmationPosibility();
	FillLastDeliveryAddress();
    }
    protected void PaymentListIndexChanged(object sender, EventArgs e)
    {
	PaymentMultiView.Visible = true;
	PaymentMultiView.ActiveViewIndex = PaymentList.SelectedIndex;
	CheckConfirmationPosibility();
	if (PaymentList.SelectedIndex == 1)
	{
	    //if (Membership.GetUser() != null) QiwiLabel.Text = "Для оплаты через терминалы Qiwi используйте ваш номер договора: " + GetContractNumber();
	    //else QiwiLabel.Text = "Для оплаты через терминалы Qiwi необходима регистрация на сайте";
	    QiwiLabel.Text = "Оплата через терминалы Qiwi временно не работает, приносим свои извинения";
	}
    }
    protected void CheckConfirmationPosibility()
    {
	ConfirmOrderButton.Enabled = ShouldButtonBeEnabled();
    }
    protected bool ShouldButtonBeEnabled()
    {
	if (AuthList.SelectedIndex == 1 && Membership.GetUser() == null) return false;
	if (DeliveryList.SelectedIndex == -1) return false;
	if (PaymentList.SelectedIndex == -1) return false;
	//if (PaymentList.SelectedIndex == 1 && Membership.GetUser() == null) return false;
	if (PaymentList.SelectedIndex == 1) return false; //Пока Qiwi не работатет
	return true;
    }
    protected void CheckVisibility()
    {
	if (AuthList.SelectedIndex == -1) AuthMultiView.Visible = false;
	else AuthMultiView.Visible = true;
	if (DeliveryList.SelectedIndex == -1) DeliveryMultiView.Visible = false;
	else DeliveryMultiView.Visible = true;
	if (PaymentList.SelectedIndex == -1) PaymentMultiView.Visible = false;
	else PaymentMultiView.Visible = true;
    }
    protected void CheckAuth()
    {
	if (Membership.GetUser() != null)
	{
	    AuthPanel.Visible = false;
	    DsicountPanel.Visible = true;
	    CheckDiscount();
	}
	else
	{
	    AuthPanel.Visible = true;
	    DsicountPanel.Visible = false;
	}
    }
    protected string GetContractNumber()
    {
	string Customer = Session["Customer"].ToString();
	string Prefix = "000000";
	return Prefix.Substring(0, 6 - Customer.Length) + Customer;
    }
    protected void RegisterButton_Click(object sender, EventArgs e)
    {
	Response.Redirect("~/Customer/Register.aspx?ReturnUrl=http://ikatalog.kz/Checkout.aspx");
    }
    protected void LoginButton_Click(object sender, EventArgs e)
    {
	if (Membership.ValidateUser(UserNameTextBox.Text, PasswordTextBox.Text))
        {
            FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(UserNameTextBox.Text, true, 30);
	    string encTicket = FormsAuthentication.Encrypt(ticket);
	    Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
	    Response.Redirect(Request.RawUrl);
        }
        else
	{
	    WrongLabel.Text = "Неверный логин или пароль.";
	}
    }
    protected void SaveOrderMetaData (string Order_id, string CustomerFullName, string CustomerEmail, string CustomerPhone, string DeliveryAddress, int DeliveryMethod, int PaymentMethod)
    {
	SaveMetaData.Parameters.Clear();
	SaveMetaData.Parameters.AddWithValue("Order_id", Order_id);
	SaveMetaData.Parameters.AddWithValue("CustomerFullName", CustomerFullName);
	SaveMetaData.Parameters.AddWithValue("CustomerEmail", CustomerEmail);
	SaveMetaData.Parameters.AddWithValue("CustomerPhone", CustomerPhone);
	SaveMetaData.Parameters.AddWithValue("DeliveryAddress", DeliveryAddress);
	SaveMetaData.Parameters.AddWithValue("DeliveryMethod", DeliveryMethod);
	SaveMetaData.Parameters.AddWithValue("PaymentMethod", PaymentMethod);
	SaveMetaData.ExecuteNonQuery();
    }
    protected bool ValidateContactData()
    {
	Page.Validate("ContactDataValidationSummary");
	return Page.IsValid;
    }
    protected void CheckDiscount()
    {
	if (Session["Coupon"] != null)
	{
	    CouponView.ActiveViewIndex = 1;
	    
	    GetCouponDescription.Parameters.Clear();
	    GetCouponDescription.Parameters.AddWithValue("Coupon_id", Session["Coupon"].ToString());
	    SqlDataReader CouponDescriptionReader = GetCouponDescription.ExecuteReader();
	    CouponDescriptionReader.Read();
	    ViewCouponLabel.Text = CouponDescriptionReader["CouponDescription"].ToString();
	    CouponDescriptionReader.Close();
	}
	else CouponView.ActiveViewIndex = 0;
    }
    protected void UseCoupon_Click(object sender, EventArgs e)
    {
	int Coupon = ValidateCoupon(CouponNumberTextBox.Text);
	
	switch (Coupon)
	{
	    case -1: CheckCouponLabel.Text = "Купон не найден, возможно — неверный номер"; break;
	    case -2: CheckCouponLabel.Text = "Это не ваш купон (он именной)"; break;
	    case -3: CheckCouponLabel.Text = "Купон уже использован"; break;
	    case -4: CheckCouponLabel.Text = "Купон просрочен"; break;
	    case -5: CheckCouponLabel.Text = "Произошла неведомая ошибка"; break;
	    default: ApplyCoupon(Coupon); break;
	}
    }
    protected void RemoveCoupon_Click(object sender, EventArgs e)
    {
	Session["Coupon"] = null;
	CouponNumberTextBox.Text = "";
	CheckCouponLabel.Text = "";
	CheckDiscount();
	OrderDetailsGridView.DataBind();
	OrderDetailsUpdatePanel.Update();
    }
    protected int ValidateCoupon(string CouponNumber)
    {
	ValidateCouponCommand.Parameters.Clear();
	ValidateCouponCommand.Parameters.AddWithValue("Number", CouponNumber);
	ValidateCouponCommand.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
	SqlDataReader CouponReader = ValidateCouponCommand.ExecuteReader();
	CouponReader.Read();
	
	int Result;
	
	try
	{
	    Result = Int16.Parse(CouponReader["Result"].ToString());
	}
	catch
	{
	    Result = -5;
	}
	
	CouponReader.Close();
	
	return Result;
    }
    protected void ApplyCoupon(int Coupon)
    {
	Session["Coupon"] = Coupon;
	CheckDiscount();
	OrderDetailsGridView.DataBind();
	OrderDetailsUpdatePanel.Update();
    }
    protected void RegisterCoupon (string Coupon, string Order)
    {
	RegisterCouponCommand.Parameters.Clear();
	RegisterCouponCommand.Parameters.AddWithValue("Order_id", Order);
	RegisterCouponCommand.Parameters.AddWithValue("Coupon_id", Coupon);
	RegisterCouponCommand.ExecuteNonQuery();
	RegisterCouponCommand.Parameters.Clear();
    }
    protected void CatalogueList_SelectedIndexChanged(object sender, EventArgs e)
    {
	
	TermsDescription.Parameters.Clear();
	TermsDescription.Parameters.AddWithValue("Catalogue_id", CatalogueList.SelectedValue.ToString());
	
	SqlDataReader TermsReader = TermsDescription.ExecuteReader();
	TermsReader.Read();
	
	if (TermsReader.HasRows)
	{
	    TermsLabel.Text = TermsReader["TermsDescription"].ToString();
	    MinimumPriceValidator.ErrorMessage = "Цена артикула по данному каталогу должна быть не менее "+ TermsReader["MinPrice"].ToString().Substring(0,4) +" €";
	    ArticleExpressionValidator.ValidationExpression = TermsReader["ArticleRegularExpression"].ToString();
	    ArticleExpressionValidator.ErrorMessage = TermsReader["ArticleComment"].ToString();
	    MinPrice = Decimal.Parse(TermsReader["MinPrice"].ToString());
	    HelpLink.NavigateUrl = TermsReader["HelpURL"].ToString();
	    HelpLink.Text = "Как заказать?";
	}
	
	TermsReader.Close();
    }
    protected void AddItemButton_Click(object sender, EventArgs e)
    {
	if (Decimal.Parse(PriceInput.Text) < MinPrice)
        {
            MinimumPriceValidator.IsValid = false;
        }
        else
        {
            MinimumPriceValidator.IsValid = true;
        }
	
	if (CatalogueList.SelectedValue.ToString() == "-1")
	{
	    CatalogueValidator.IsValid = false;
	}
	else
	{
	    CatalogueValidator.IsValid = true;
	}
        
        if (Page.IsValid)
        {
	    if (AddItem.Parameters.Count != 0) AddItem.Parameters.Clear();
	    AddItem.Parameters.AddWithValue("Catalogue_id", CatalogueList.SelectedValue.ToString());
	    AddItem.Parameters.AddWithValue("Article_id", Article_idInput.Text);
	    AddItem.Parameters.AddWithValue("ArticleName", ArticleNameInput.Text);
	    AddItem.Parameters.AddWithValue("Price", Decimal.Parse(PriceInput.Text));
	    AddItem.Parameters.AddWithValue("Size", SizeInput.Text);
	    AddItem.Parameters.AddWithValue("Colour", ColorInput.Text);
	    if (Session["Customer"]!=null)
	    {
		AddItem.Parameters.AddWithValue("Customer_id", Session["Customer"].ToString());
	    }
	    else
	    {
		AddItem.Parameters.AddWithValue("Customer_id", -1);
	    }
	    AddItem.Parameters.AddWithValue("Comment", URLInput.Text);
	    AddItem.Parameters.AddWithValue("Session_id", HttpContext.Current.Session.SessionID.ToString());
	    
	    AddItem.ExecuteNonQuery();
	    AddItem.Parameters.Clear();
	    
	    Article_idInput.Text = "";
	    ArticleNameInput.Text = "";
	    PriceInput.Text = "";
	    SizeInput.Text = "";
	    ColorInput.Text = "";
	    
	    OrderDetailsGridView.DataBind();
            OrderDetailsUpdatePanel.Update();
	}
    }
    void FillLastDeliveryAddress()
    {
	if (DeliveryList.SelectedIndex == 1 && Membership.GetUser() != null) AddressTextBox.Text = GetLastDeliveryAddress(Session["Customer"].ToString());
    }
    string GetLastDeliveryAddress(string Customer_id)
    {
	string GetLastAddressString = "select top 1 OMD.DeliveryAddress from OrdersMetaData as OMD join Orders as O on O.id = OMD.Order_id where O.Customer_id = @customer and OMD.DeliveryMethod = 1 order by OMD.ID desc";
	SqlCommand GetLastAddress = new SqlCommand(GetLastAddressString, iKConnection);
	
	GetLastAddress.Parameters.Clear();
	GetLastAddress.Parameters.AddWithValue("customer", Customer_id);
	
	if (GetLastAddress.ExecuteScalar() != null)
	{
	    return GetLastAddress.ExecuteScalar().ToString();
	}
	else
	{
	    return "";
	}
    }
}
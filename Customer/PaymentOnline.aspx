<%@ Page Title="" Language="C#" MasterPageFile="~/Customer/SideModulesAccount.master" AutoEventWireup="true" CodeFile="PaymentOnline.aspx.cs" Inherits="Admin_OrderManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">


    <script type="text/javascript">
        function ClientValidate(source, arguments) {
            var amount = document.getElementById('<%= AmmountInput.ClientID %>');
            if (!isNaN(amount.value.replace('.', ',')) || !isNaN(amount.value.replace(',', '.'))) {
                arguments.IsValid = true;
            } else {
                arguments.IsValid = false;
            }
    }
    </script>
    <title>iKatalog - оплата online</title>
    <link rel="Stylesheet" href="../css/Infos.css" />
    <link rel="Stylesheet" href="../css/Admin.css" />
    <style>
        td > input[type="submit"] {
            --height: 80px;
            width: 100px;
            font-size: large;
            font-weight: bold;
            color: Green;
            margin: 5px 5px 5px 5px;
        }

        td {
            vertical-align: middle;
        }

        div.tableholder {
            --width:500px;
        }

        td > input[type="radio"] {
            --position:relative;
            --top:-10px;
            --margin: 0px 5px 0px 5px;
        }

        span.description {
            position: relative;
            top: -10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h2>Оплата online:</h2>
    <!-- iframe frameborder="0" scrolling="no" width="700px" height="600px" src="PaymentForm.aspx"></iframe -->
    <p>Для того, чтобы провести оплату через сайт, пожалуйста выберите один из способов оплаты, укажите сумму и нажмите кнопку "Оплатить".</p>
    <div class="tableholder">
        <table>
            <caption>Способы оплаты</caption>
        </table>
        <table>
            <tr>
                <td style="direction: ltr; text-align: left">
                    <asp:radiobuttonlist id="MethodsList" runat="server" style="direction: ltr" align="left">
                        <asp:ListItem>
					        Платежная карта: VISA, Mastercard
                        </asp:ListItem>
                    </asp:radiobuttonlist>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td colspan="2">Сумма в евро:
					<asp:textbox id="AmmountInput" style="font-size: 16px; width: 70px;" runat="server"></asp:textbox>
                    <asp:button id="ZPaymentButton" runat="server" text="Оплатить" onclick="ZPaymentButton_Click" />
                </td>
            </tr>
        </table>
        <span style="color: red; font-weight: bold;">
            <asp:requiredfieldvalidator id="AmmountRequiredValidator" runat="server" errormessage="Сумму укажите, пожалуйста." controltovalidate="AmmountInput"><br/>Сумму укажите, пожалуйста.</asp:requiredfieldvalidator>
        </span>
        <span style="color: red; font-weight: bold;">
            <asp:customvalidator id="CustomValidator" controltovalidate="AmmountInput" runat="server" clientvalidationfunction="ClientValidate" errormessage="Сумма должна быть числом.">Сумма должна быть числом.</asp:CompareValidator></span>
        </asp:CustomValidator> 
    </div>
</asp:Content>


$(document).ready(function () {
    $("a#showcataloguesdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#cataloguesdisplay").show("fast");
        $("div#show1").hide("fast");
        $("div#hide1").show("fast");
        --$(this).hide("fast");
    });
    $("a#hidecataloguesdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#cataloguesdisplay").hide("fast");
        $("div#show1").show("fast");
        $("div#hide1").hide("fast");
        --$(this).hide("fast");
    });
    $("a#showpricedisplay").click(function (event)
    {
        event.preventDefault();
        $("div#pricedisplay").show("fast");
        $("div#show2").hide("fast");
        $("div#hide2").show("fast");
    });
    $("a#hidepricedisplay").click(function (event)
    {
        event.preventDefault();
        $("div#pricedisplay").hide("fast");
        $("div#show2").show("fast");
        $("div#hide2").hide("fast");
    });
    $("a#showpaymentdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#paymentdisplay").show("fast");
        $("div#show3").hide("fast");
        $("div#hide3").show("fast");
    });
    $("a#hidepaymentdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#paymentdisplay").hide("fast");
        $("div#show3").show("fast");
        $("div#hide3").hide("fast");
    });
    $("a#showorderdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#orderdisplay").show("fast");
        $("div#show4").hide("fast");
        $("div#hide4").show("fast");
    });
    $("a#hideorderdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#orderdisplay").hide("fast");
        $("div#show4").show("fast");
        $("div#hide4").hide("fast");
    });
    $("a#showofferdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#offerdisplay").show("fast");
        $("div#show5").hide("fast");
        $("div#hide5").show("fast");
    });
    $("a#hideofferdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#offerdisplay").hide("fast");
        $("div#show5").show("fast");
        $("div#hide5").hide("fast");
    });
    $("a#showregdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#regdisplay").show("fast");
        $("div#show0").hide("fast");
        $("div#hide0").show("fast");
    });
    $("a#hideregdisplay").click(function (event)
    {
        event.preventDefault();
        $("div#regdisplay").hide("fast");
        $("div#show0").show("fast");
        $("div#hide0").hide("fast");
    });
});
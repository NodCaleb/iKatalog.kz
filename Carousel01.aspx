<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Carousel01.aspx.cs" Inherits="CatalogueView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <title>Carousel</title>
    <link rel="Stylesheet" href="css/Carousel.css" />
	<script src="js/jquery-1.7.js"></script>
	<script src="js/jquery.carousel.min.js"></script>
    <script>
		 $(document).ready(function(){
			$("a#aaa").click(function(event){
			 event.preventDefault();
			 $("img#im01").show("slow");
		   });
		 });
    </script>
	<script type="text/javascript">
		$(function(){
			$("div.foo").carousel({nextBtn:false, prevBtn:false, autoSlide: true, autoSlideInterval: 5000, animSpeed: "slow", effect:"scroll"});
		});
	</script>
</head>
<body>    
    <form id="CarouselForm" runat="server">
	<asp:SqlDataSource ID="CarouselSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>" SelectCommand=" select CatalogueUrl, ImageUrl from CarouselBanners order by RecordDate desc"></asp:SqlDataSource>
	<asp:Repeater ID="CarouselRepeater" runat="server" DataSourceID="CarouselSource">
	    <HeaderTemplate>
		<div class="foo">
		<div> 
	    </HeaderTemplate>
	    <ItemTemplate>
		<div>
		    <a href='<%# Eval("CatalogueUrl") %>' target="_blank">
			<img src='<%# Eval("ImageUrl") %>' />
		    </a>
		</div>
	    </ItemTemplate>
	    <FooterTemplate>
		</div>
		</div>
	    </FooterTemplate>
	</asp:Repeater>
	<!-- div class="foo">
	    <div>
		<div>
		    <a href="https://www.otto.de/damenmode/kategorien/schmuck/">
			<img src="http://i1321.photobucket.com/albums/u551/Eugene_Rozhkov/valentineschmuck_zpsftgjrhfb.png" />
		    </a>
		</div>
		<div>
		    <a href="http://www.schwab.de/">
			<img src="http://i1321.photobucket.com/albums/u551/Eugene_Rozhkov/schwab75_zpsteoyvtuw.png" />
		    </a>
		</div>
		<div>
		    <a href="http://www.albamoda.de/sale/damenmode-reduziert/sh8376077.html?lmPromo=la,2,hk,HP-06-live-15,fl,sh8376077">
			<img src="http://i1321.photobucket.com/albums/u551/Eugene_Rozhkov/alba30_zps9mguvuke.png" />
		    </a>
		</div>
		<div>
		    <a href="http://www.peterhahn.de/reduzierte-damen-jacken-maentel">
			<img src="http://i1321.photobucket.com/albums/u551/Eugene_Rozhkov/peterhann60_zpso6tqberb.png" />
		    </a>
		</div>
		<div>
		    <a href="http://www.kik.de/wasche-bademode/neuheiten/damen.html?et_cid=30&et_lid=56&et_sub=3_4_KW05_Damenw%C3%A4scheLP">
			<img src="http://i1321.photobucket.com/albums/u551/Eugene_Rozhkov/kik_panties_zpspr0mqmzr.png" />
		    </a>
		</div>
	    </div>
	</div -->
    </form>
</body>
</html>

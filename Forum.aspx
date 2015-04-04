<%@ Page Title="" Language="C#" MasterPageFile="~/iKMasterPage.master" AutoEventWireup="true" CodeFile="Forum.aspx.cs" Inherits="Forum" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>iKatalog - форум</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script language="JavaScript"> 
    <!--
        function resizeIFrame(id) {
            document.getElementById(id).height = "100px";
            var newheight;
            if (document.getElementById) {
                newheight = document.getElementById(id).contentWindow.document.body.scrollHeight;
            }
            document.getElementById(id).height = (newheight) + "px";
        } 
    //--> 
    </script>
    <iframe id="yaf" frameborder="0" scrolling="no" width="100%" height="100px" src="yaf/PureForum.aspx" onload="resizeIFrame('yaf')"></iframe>
</asp:Content>


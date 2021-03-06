<%@ Control Language="C#" AutoEventWireup="true"
	Inherits="YAF.Controls.EditUsersInfo" Codebehind="EditUsersInfo.ascx.cs" %>
<table class="content" width="100%" cellspacing="1" cellpadding="0">
	<tr>
		<td class="header1" colspan="2">
			User Details
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>Username:</b>
			<br />
			Cannot be modified.
		</td>
		<td class="post">
			<asp:TextBox Style="width: 300px" ID="Name" runat="server" Enabled="false" />
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>E-mail:</b>
		</td>
		<td class="post">
			<asp:TextBox Style="width: 300px" ID="Email" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>Rank:</b>
		</td>
		<td class="post">
			<asp:DropDownList ID="RankID" runat="server" />
		</td>
	</tr>
	<tr runat="server" id="IsHostAdminRow">
		<td class="postheader">
			<b>Host Admin:</b>
			<br />
			Gives user access to modify "Host Settings" section.
		</td>
		<td class="post">
			<asp:CheckBox runat="server" ID="IsHostAdminX" />
		</td>
	</tr>
	<tr runat="server" id="IsCaptchaExcludedRow">
		<td class="postheader">
			<b>Exclude from CAPTCHA:</b><br />
			CAPTCHA is disabled for this user specifically.
		</td>
		<td class="post">
			<asp:CheckBox runat="server" ID="IsCaptchaExcluded" />
		</td>
	</tr>
	<tr runat="server" id="IsExcludedFromActiveUsersRow">
		<td class="postheader">
			<b>Exclude from Active Users:</b><br />
			User is not shown in Active User lists.
		</td>
		<td class="post">
			<asp:CheckBox runat="server" ID="IsExcludedFromActiveUsers" />
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>Is Approved:</b>
		</td>
		<td class="post">
			<asp:CheckBox runat="server" ID="IsApproved" />
		</td>
	</tr>
	<!-- Easy to enable it if there is major issues (i.e. Guest being deleted). -->
	<tr runat="server" id="IsGuestRow" visible="false">
		<td class="postheader">
			<b>Is Guest:</b>
		</td>
		<td class="post">
			<asp:CheckBox runat="server" ID="IsGuestX" />
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>Joined:</b>
		</td>
		<td class="post">
			<asp:TextBox ID="Joined" runat="server" Enabled="False" />
		</td>
	</tr>
	<tr>
		<td class="postheader">
			<b>Last Visit:</b>
		</td>
		<td class="post">
			<asp:TextBox ID="LastVisit" runat="server" Enabled="False" />
		</td>
	</tr>
	<tr>
		<td class="postfooter" colspan="2" align="center">
			<asp:Button ID="Save" runat="server" Text="Save" CssClass="pbutton" OnClick="Save_Click" />
		</td>
	</tr>
</table>

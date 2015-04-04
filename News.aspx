<%@ Page Title="" Language="C#" MasterPageFile="~/SideModulesNews.master" AutoEventWireup="true" CodeFile="News.aspx.cs" Inherits="News" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="Stylesheet" href="css/News.css" />
    <%--<title>iKatalog - новости портала</title>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:SqlDataSource ID="NewsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
        SelectCommand=" with OrderedNews as 
			(
				SELECT
					ROW_NUMBER() over (ORDER BY [CreationDate] DESC) as RowNumber,
					N.id as id,
					[Header],
					[Body],
					[CreationDate],
					'vk_like'+convert(nvarchar(5), N.id) as [vk_id],
					'http://Ikatalog.kz/News.aspx?Article='+convert(nvarchar(5), N.id) as [URL]
				FROM
					[News] as N
					left join NewsTags as NT on NT.News_id = N.id
				where
					Published = 1
					and N.id = case when isnull (@Article, -1) = -1 then N.id else @Article end
					and isnull (NT.Tag_id, -1) = case when @Tag_id = -1 then isnull (NT.Tag_id, -1) else @Tag_id end 
				group by
					N.id,
					[Header],
					[Body],
					[CreationDate],
					'vk_like'+convert(nvarchar(5), N.id),
					'http://Ikatalog.kz/News.aspx?Article='+convert(nvarchar(5), N.id)
				)
			select
				id,
				[Header],
				[Body],
				[CreationDate],
				[URL],
				[vk_id]
			from
				OrderedNews
			where
				RowNumber between @Skip + 1 and @Skip + 5">
        <SelectParameters>
            <asp:Parameter Name="Skip" DefaultValue="0" />
            <asp:Parameter Name="Article" DefaultValue="-1" />
	    <asp:Parameter Name="Tag_id" DefaultValue="-1" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="NewsTeaserSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
    SelectCommand="with OrderedTeasers as 
	(
	SELECT
	ROW_NUMBER() over (ORDER BY [CreationDate] DESC) as RowNumber,
	[Header], '~/News.aspx?Article='+convert(nvarchar(5), N.id) as [URL], [CreationDate], [Teaser]
	FROM
	    [News] as N
	    left join NewsTags as NT on NT.News_id = N.id
	where
	    Published = 1
	    and isnull (NT.Tag_id, -1) = case when @Tag_id = -1 then isnull (NT.Tag_id, -1) else @Tag_id end
	group by [CreationDate], [Header], [Teaser], N.id
	)
	select
		RowNumber,
		[Header],
		[Teaser],
		[CreationDate],
		[URL]
	from
		OrderedTeasers
	where
		RowNumber between @Skip + 1 and @Skip + 10">
	<SelectParameters>
            <asp:Parameter Name="Skip" DefaultValue="0" />
	    <asp:Parameter Name="Tag_id" DefaultValue="-1" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="NewsPaginationSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
    SelectCommand="exec NewsPaginationList @skip = @skip, @tag = @tag">
	<SelectParameters>
            <asp:Parameter Name="skip" DefaultValue="0" />
	    <asp:Parameter Name="tag" DefaultValue="-1" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <asp:Panel id="FullViewPanel" visible="false" runat="server">
	<asp:Repeater ID="NewsRepeater" runat="server" DataSourceID="NewsSource">
	    <ItemTemplate>
		<div class="newsblock">
		    <h2><asp:Label ID="NewsHeaderLabel" runat="server" Text='<%# Eval("Header") %>'></asp:Label></h2>
		    <h5><asp:Label ID="NewsDateLabel" runat="server" Text='<%# Eval("CreationDate", "{0:d}") %>'></asp:Label></h5>
		    <asp:Label ID="NewsBodyLabel" runat="server" Text='<%# Eval("Body") %>'></asp:Label>
		    <asp:HiddenField ID="NewsId" Value ='<%# Eval("id") %>'  runat="server" />
		    <asp:SqlDataSource ID="TagsSource" runat="server" ConnectionString="<%$ ConnectionStrings:iKConnectionString %>"
			SelectCommand="	select
						    Tag_id,
						    Tag,
						    'http:\\ikatalog.kz\News.aspx?Tag=' + convert (nvarchar(10), Tag_id) as TagURL
					    from
						    NewsTags as NT
						    join Tags as T on T.id = NT.Tag_id
					    where
						    News_id = @News_id">
			<SelectParameters>
			    <asp:ControlParameter ControlID="NewsId" Name="News_id" PropertyName="Value" DefaultValue="-1" Type="Int32" />
			</SelectParameters>
		    </asp:SqlDataSource>
			<p>Рубрики:
			    <asp:Repeater ID="TagsRepeater" runat="server" DataSourceID="TagsSource">
				<ItemTemplate>
				    <asp:HyperLink ID="TagLink" runat="server" NavigateUrl='<%# Eval("TagURL") %>'>
					<asp:Label ID="TagLabel" runat="server" Text='<%# Eval("Tag") %>'></asp:Label>
				    </asp:HyperLink>
				</ItemTemplate>
			    </asp:Repeater>
			</p>
				    <div class="SM">
					    <div class="fb-like" data-href='<%# Eval("URL") %>' data-send="true" data-layout="button_count" data-width="450" data-show-faces="true" data-font="verdana"></div>
				    </div>
				    <div class="SM">
					    <div id='<%# Eval("vk_id") %>'></div>
					    <script type="text/javascript">
						    VK.Widgets.Like('<%# Eval("vk_id") %>', { type: "button", verb: 1, height: 20, pageUrl:'<%# Eval("URL") %>' });
					    </script>
				    </div>
				    <div class="SM">
					    <a target="_blank" class="mrc__plugin_uber_like_button" href="http://connect.mail.ru/share?share_url=<%# Eval("URL") %>" data-mrc-config="{'type' : 'button', 'caption-mm' : '1', 'caption-ok' : '1', 'counter' : 'true', 'text' : 'true', 'width' : '100%'}">Нравится</a>
					    <script src="http://cdn.connect.mail.ru/js/loader.js" type="text/javascript" charset="UTF-8"></script>
				    </div>
		</div>            
	    </ItemTemplate>
	</asp:Repeater>
	<div class="newsblock">
	    <div class="previous">
		<asp:HyperLink ID="PreviouseLink" runat="server">позже ></asp:HyperLink>
	    </div>
	    <div class="next">
		<asp:HyperLink ID="NextLink" runat="server">< раньше</asp:HyperLink>
	    </div>
	</div>
    </asp:Panel>
    <asp:Panel id="TeaserViewPanel" runat="server">
	<div class="teaserblock">
	    <h2><asp:Label ID="TagLabel" runat="server" Text='Новости портала'></asp:Label></h2>
	    <asp:Repeater ID="NewsTeaserRepeater" runat="server" DataSourceID="NewsTeaserSource">
		<ItemTemplate>
		    <h3><asp:HyperLink ID="HyperLink1" NavigateUrl='<%# Eval("URL") %>' runat="server"><%# Eval("Header") %></asp:HyperLink></h3>
		    <h5><asp:Label ID="NewsTeaserDateLabel" runat="server" Text='<%# Eval("CreationDate", "{0:d}") %>'></asp:Label></h5>
		    <p><%# Eval("Teaser") %><asp:HyperLink ID="HyperLink2" NavigateUrl='<%# Eval("URL") %>' runat="server">&gt;&gt;&gt;</asp:HyperLink></p>					
		</ItemTemplate>
	    </asp:Repeater>
	    <div class="paginator">
		<center>
		    <asp:Repeater ID="NewsPaginationRepeater" runat="server" DataSourceID="NewsPaginationSource">
			<ItemTemplate>
			    <%# Eval("HTML") %>				
			</ItemTemplate>
		    </asp:Repeater>
		</center>
	    </div>
	</div>
    </asp:Panel>
    
</asp:Content>
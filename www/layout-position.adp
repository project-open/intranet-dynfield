<%
  # /packages/intranet-dynfield/www/layout-position.adp
  # $Workfile: layout-position.adp $ $Revision$ $Date$
%>
<master src="master">
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>
<property name="left_navbar">@left_navbar_html;literal@</property>

<h1>@page_url@ Layout for @object_type@</h1>

<p>
<listtemplate name="attrib_list"></listtemplate>
</p>

<if @page.layout_type@ eq "relative">
<p>
#intranet-dynfield.Hint_Remember_that_yo#
</p>
</if>

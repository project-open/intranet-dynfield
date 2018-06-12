<master src="master">
<property name="doc(title)">@page_title;literal@</property>
<property name="context">@context_bar;literal@</property>
<property name="left_navbar">@left_navbar_html;literal@</property>


<form action=widgets-delete method=post>

<table class="list">

  <tr class="list-header">
    <th class="list-narrow">#intranet-dynfield.Del#</th>
    <th class="list-narrow">#intranet-dynfield.Name# /<br>
       #intranet-dynfield.Pretty_Name#</th>
<!--    <th class="list-narrow">#intranet-dynfield.Storage_Type#</th> -->
    <th class="list-narrow">#intranet-dynfield.ACS_Datatype# /<br>#intranet-dynfield.SQL_Datatype#</th>
    <th class="list-narrow">#intranet-dynfield.OACS_Widget# /<br>
        <%= [lang::message::lookup "" intranet-dynfield.Deref_Function "Deref Function"] %></th>
    <th class="list-narrow">#intranet-dynfield.Parameters#</th>
  </tr>

  <multiple name=widgets>
  <if @widgets.rownum@ odd>
    <tr class="list-odd">
  </if> <else>
    <tr class="list-even">
  </else>
  
    <td class="list-narrow">
	<input type="checkbox" name="widget_id.@widgets.widget_id@">
    </td>
    <td class="list-narrow">
      <a href="widget-new?widget_id=@widgets.widget_id@">
	@widgets.widget_name@
      </a> /<br>
	@widgets.pretty_name@
    </td>
<!--    <td class="list-narrow">@widgets.storage_type@</td> -->
    <td class="list-narrow">
	@widgets.acs_datatype@ /<br>@widgets.sql_datatype@
    </td>
    <td class="list-narrow">
	@widgets.widget@ /<br>
	@widgets.deref_plpgsql_function@
    </td>
    <td class="list-narrow">
	@widgets.parameters@
    </td>

  </tr>
  </multiple>
</table>

<table width="100%">
  <tr>
    <td colspan="99" align="right">
      <input type="submit" value="Delete Selected Widgets">
    </td>
  </tr>
</table>

</form>


<ul>
<li><A href="widget-new">#intranet-dynfield.Create_a_new_Widget#</a>
</ul>


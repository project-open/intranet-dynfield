<master src="/packages/intranet-core/www/admin/master">
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>
<property name="navbar_list">@navbar;literal@</property>
<property name="admin_navbar_label">dynfield_admin</property>
<property name="left_navbar">@left_navbar;noquote@</property>

<if @focus@ not nil><property name="focus">@focus;literal@</property></if>

<slave>


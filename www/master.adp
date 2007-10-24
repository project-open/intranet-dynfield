<!-- this is a copy of intranet/www/admin/master.adp -->

<%= [im_header $title] %>
<%= [im_navbar "admin"] %>
<% if {![info exists admin_navbar_label]} { set admin_navbar_label "dynfield_admin" } %>
<div id="slave">
   <div id="slave_content">
      <%= [im_admin_navbar $admin_navbar_label] %>
      <div id="admin-content">
         <!--/intranet-dynfield/www/master.adp before slave -->
         <slave>
         <!--/intranet-dynfield/www/master.adp after slave -->
      </div>
   </div>
</div>
<%= [im_footer] %>

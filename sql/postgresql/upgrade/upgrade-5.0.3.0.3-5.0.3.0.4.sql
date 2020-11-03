-- upgrade-upgrade-5.0.3.0.3-5.0.3.0.4.sql
SELECT acs_log__debug('/packages/intranet-dynfield/sql/postgresql/upgrade/upgrade-5.0.3.0.3-5.0.3.0.4.sql','');




-- Add javascript calendar buton on date widget
UPDATE im_dynfield_widgets 
SET parameters = '{format "YYYY-MM-DD"} {after_html {
<input type="button" id=''${attribute_name}_calendar'' style="height:20px; width:20px; background: url(''/resources/acs-templating/calendar.gif'');"> 
<script type="text/javascript" nonce="[im_csp_nonce]">
window.addEventListener(''load'', function() { 
     document.getElementById(''${attribute_name}_calendar'').addEventListener(''click'', function() { showCalendarWithDateWidget(''${attribute_name}'', ''y-m-d''); });
});
</script>
}}' 
WHERE widget_name = 'date';



-- Add javascript calendar buton on date widget
UPDATE im_dynfield_widgets 
SET parameters = '{format "YYYY-MM-DD HH24:MI"} {after_html {
<input type="button" id=''${attribute_name}_calendar'' style="height:20px; width:20px; background: url(''/resources/acs-templating/calendar.gif'');"> 
<script type="text/javascript" nonce="[im_csp_nonce]">
window.addEventListener(''load'', function() { 
     document.getElementById(''${attribute_name}_calendar'').addEventListener(''click'', function() { showCalendarWithDateWidget(''${attribute_name}'', ''y-m-d''); });
});
</script>
}}' 
WHERE widget_name = 'timestamp';


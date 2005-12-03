ad_library {

    Additional Widgets for use with the intranet-dynfield
    extensible architecture

    @author Frank Bergmann frank.bergmann@project-open.com
    @creation-date 2005-01-25
    @cvs-id $Id$
}


ad_proc -public template::widget::generic_sql { element_reference tag_attributes } {
    Generic SQL Select Widget

    @param select A SQL select statement returning a list of key-value
                  pairs that serve to define the values of a select
                  widget. A single select is suitable to display some
                  200 values. Please use a different widget if you
                  have to display more then these values.
} {
    upvar $element_reference element

#   Show all availabe variables in the variable frame
#   ad_return_complaint 1 "<pre>\n'$element(custom)'\n[array names element]\n</pre>"

    if { [info exists element(custom)] } {
    	set params $element(custom)
    } else {
	return "Generic SQL Widget: Error: Didn't find 'custom' parameter.<br>Please use a Parameter such as: <tt>{custom {sql {select party_id, email from parties}}} </tt>"
    }

    set sql_pos [lsearch $params sql]
    if { $sql_pos >= 0 } {
    	set sql_statement [lindex $params [expr $sql_pos + 1]]
    } else {
	return "Generic SQL Widget: Error: Didn't find 'sql' parameter"
    }

    array set attributes $tag_attributes
    #set attributes(multiple) {}

    set key_value_list [list]
    if {[catch {set key_value_list [db_list_of_lists sql_statement $sql_statement]} errmsg]} {
	return "Generic SQL Widget: Error executing SQL statment <pre>'$sql_statement'</pre>: <br>
	<pre>$errmsg</pre>"
    }
    set sql_html ""
    set default_value $element(value)
    if { "edit" != $element(mode) } {
    	foreach sql $key_value_list {
		set key [lindex $sql 0]
		set value [lindex $sql 1]
		if {$key == $default_value} {
			append sql_html "$value
			<input type=\"hidden\" name=\"$element(name)\" id=\"$element(name)\" value=\"$key\">"
		}
    	}
    } else {
    	set sql_html "<select name=\"$element(name)\" id=\"$element(name)\" "
    		foreach name [array names attributes] {
			if { [string equal $attributes($name) {}] } {
				append sql_html " $name"
			} else {
				append sql_html " $name=\"$attributes($name)\""
			}
		}
		set i 0
		while {$i < [llength $element(html)]} {
			append sql_html " [lindex $element(html) $i]=\"[lindex $element(html) [expr $i + 1]]\""
			incr i 2
    		}
    	append sql_html " >\n"
    	if {[exists_and_not_null element(optional)] && $element(optional)} {
		append sql_html "<option value=\"\"> [_ intranet-dynfield.no_value]</option>"
    	}
    	foreach sql $key_value_list {
		set key [lindex $sql 0]
		set value [lindex $sql 1]
		if {$key != $default_value} {
    	    		append sql_html "<option value=\"$key\">$value</option>"
        	} else {
        		append sql_html "<option value=\"$key\" selected=\"selected\">$value</option>"
        	}
    	}
    	append sql_html "\n</select>\n"
    }

    return $sql_html
}

# packages/intranet-dynfield/tcl/intranet-dynfield-procs.tcl
ad_library {

  Support procs for the intranet-dynfield package

  @author Matthew Geddert openacs@geddert.com
  @author Juanjo Ruiz juanjoruizx@yahoo.es
  @creation-date 2004-09-28

  @vss $Workfile: intranet-dynfield-procs.tcl $ $Revision$ $Date$

}



ad_proc im_dynfield::widget_options_not_cached_procs {} {
    Pulls out all procedures following a patters.
    This procedure must be define BEFORE the 
    namespace eval * commands below.
} {
    set widgets [::info commands "::template::widget::*"]
    return $widgets
}


namespace eval im_dynfield:: {}
namespace eval im_dynfield::util {}



ad_proc -public im_dynfield::left_navbar {
} {
    Return a HTML component with the list of DynField pages.
} {
    set user_id [ad_conn user_id]
    set locale [lang::user::locale -user_id $user_id]
    set result [im_navbar_write_tree \
                        -user_id $user_id \
                        -locale $locale \
                        -label "dynfield_admin" \
                        -maxlevel 3 \
                        -ignore_disabled_p 1 \
		    ]
    return "<ul>\n$result\n</ul>\n"
}



ad_proc im_dynfield::type_categories_for_object_type {
    -object_type:required
} {
    set sql "
                select
                        c.category_id,
			c.category
                from
                        im_categories c,
			acs_object_types ot
                where
                        (c.enabled_p = 't' OR c.enabled_p is NULL)
                        and c.category_type = ot.type_category_type
			and ot.object_type = :object_type
		order by
			lower(c.category)
    "
    return [db_list_of_lists cats $sql]
}



ad_proc -public im_dynfield::type_category_for_object_type {
    -object_type:required
} {
    Get the category for the type_id of a given object_type
} {
    return [db_string ocat "select type_category_type from acs_object_types where object_type = :object_type" -default ""]
}


ad_proc -public im_dynfield::status_category_for_object_type {
    -object_type:required
} {
    Get the category for the status_id of a given object_type
} {
    return [db_string ocat "select status_category_type from acs_object_types where object_type = :object_type" -default ""]
}


ad_proc -public im_dynfield::datatype_options {
} {
    Return the default list of datatypes cached
} {
    return [util_memoize [list im_dynfield::datatype_options_not_cached]]
}


ad_proc -public im_dynfield::datatype_options_not_cached {
} {
    Return the default list of datatypes not cached
} {
    set datatype_options [list]

    if {[apm_package_installed_p acs-templating]} {
        #acs-templating package
        append datatype_options [list \
				     [list "Boolean" boolean] \
				     [list "Checkbox Text" checkbox_text] \
				     [list "Currency" currency] \
				     [list "Date" date] \
				     [list "Email" email] \
				     [list "File" file] \
				     [list "Filename" filename] \
				     [list "Float" float] \
				     [list "Integer" integer] \
				     [list "Keyword" keyword] \
				     [list "Natural Number" naturalnum] \
				     [list "Party Search" party_search] \
				     [list "Radio Text" radio_text] \
				     [list "Rich Text" richtext] \
				     [list "Richtext or File" richtext_or_file] \
				     [list "Search" search] \
				     [list "Select Text" select_text] \
				     [list "String" string] \
				     [list "Text" text] \
				     [list "URL" url] \
				     [list "URL Element" url_element] \
				     ]
    }

    if {[apm_package_installed_p category]} {
        #categories package
        lappend datatype_options [list "Category" category]
    }

    if {[apm_package_installed_p intranet-dynfield]} {
        #intranet-dynfield package
        lappend datatype_options [list "Mobile Number" mobile_number]
        lappend datatype_options [list "Recurrence" recurrence]
        lappend datatype_options [list "Telecom Number" telecom_number]
    }

    return $datatype_options
}


ad_proc -public im_dynfield::widget_options {
} {
    Return the default list of widgets cached
} {
    return [util_memoize [list im_dynfield::widget_options_not_cached]]
}


ad_proc -public im_dynfield::widget_options_not_cached {
} {
    set widget_options [list]

    #check also for package version?
    #apm_version_id_from_package_key

    if {[apm_package_installed_p acs-templating]} {
        #acs-templating package
        append widget_options [list \
				   [list "ampmFragment" ampmFragment] \
				   [list "Attachment" attachment] \
				   [list "Block" block] \
				   [list "Button" button] \
				   [list "Checkbox" checkbox] \
				   [list "Checkbox Text" checkbox_text] \
				   [list "Comment" comment] \
				   [list "Cost Center Tree" im_cost_center_tree] \
				   [list "Currency" im_currencies] \
				   [list "Date" date] \
				   [list "Date Fragment" dateFragment] \
				   [list "File" file] \
				   [list "Hidden" hidden] \
				   [list "Inform" inform] \
				   [list "Input Type" input type] \
				   [list "Menu Widget Name" menu widget_name] \
				   [list "Month Fragment" monthFragment] \
				   [list "Multiselect" multiselect] \
				   [list "Numeric Range" numericrange] \
				   [list "Party Search" party_search] \
				   [list "Password" password] \
				   [list "Radio" radio] \
				   [list "Radio" radio_text] \
				   [list "Rich Text" richtext] \
				   [list "Richtext or File" richtext_or_file] \
				   [list "Search" search] \
				   [list "Select" select] \
				   [list "Select Text" select_text] \
				   [list "Submit" submit] \
				   [list "Tab" tab] \
				   [list "Text" text] \
				   [list "Textarea" textarea] \
				   [list "Text Date" textdate] \
				   ]
    }

    if {[apm_package_installed_p intranet-dynfield]} {
        #intranet-dynfield package
        lappend widget_options [list "Calculated SQL" calculated_sql]
	lappend widget_options [list "Dynfield Hidden" dynfield_hidden]
	lappend widget_options [list "Generic SQL" generic_sql]
	lappend widget_options [list "Generic TCL" generic_tcl]
	lappend widget_options [list "Mobile Number" mobile_number]
	lappend widget_options [list "Recurrence" recurrence]
	lappend widget_options [list "Telecom Number" telecom_number]
    }

    if {[apm_package_installed_p category]} {
        #categories package
	lappend widget_options [list "Category" category]
	lappend widget_options [list "OpenACS Category" category_tree]

    }

    if {[apm_package_installed_p intranet-core]} {
        #intranet-core package
	lappend widget_options [list "P/O Category" im_category_tree]
	lappend widget_options [list "\]po\[ Checkbox" im_checkbox]
    }

    if {[apm_package_installed_p acs-lang]} {
        #acs-lang package
	lappend widget_options [list "Select Locales" select_locales]
    }

    # Extract the list of widgets into a simple list for searching
    set widget_list [list]
    foreach o $widget_options {
	set o_base [lindex $o 1]
	lappend widget_list $o_base
    }

    # Search for all template::widget::* procs to check for custom functions
    set widgets [im_dynfield::widget_options_not_cached_procs]
    foreach widget $widgets {
	set widget_fn [string range $widget 20 end]
	if {[lsearch $widget_list $widget_fn] < 0} {
	    lappend widget_options [list $widget $widget_fn]
	}
    }

    return $widget_options
}


ad_proc -public im_dynfield::search_sql_criteria_from_form {
    -form_id:required
    -object_type:required
    { -exclude_attributes ""}
} {
    This procedure generates a subquery SQL clause
    "(select object_id from ...)" that can be used
    by a main query clause either as a "where <*>_id in ..."
    or via a join in order to limit the number of object_ids
    to the ones that fit to the filter criteria.

    @param form_id: search form id
    @return:	An array consisting of:
		where: A SQL phrase and
		bind_vars: a key-value paired list carrying the bind
			vars for the SQL phrase
} {
    # Get the list of all elements in the form
    set form_elements [template::form::get_elements $form_id]

    # Add two dummy elements in order to avoid syntax error
    lappend exclude_attributes "none"
    lappend exclude_attributes "none"

    # Get the main table for the data type
    db_1row main_table "
	select	table_name as main_table_name,
		id_column as main_id_column
	from	acs_object_types
	where	object_type = :object_type
    "

    set attributes_sql "
	select
		a.attribute_id,
		a.table_name as attribute_table_name,
		a.attribute_name,
		at.pretty_name,
		a.datatype,
		case when a.min_n_values = 0 then 'f' else 't' end as required_p,
		a.default_value,
		t.table_name as object_type_table_name,
		t.id_column as object_type_id_column_bad,
		ott.id_column as object_type_id_column,
		at.table_name as attribute_table,
		at.object_type as attr_object_type,
		dw.widget
	from
		acs_object_type_attributes a,
		im_dynfield_attributes aa,
		im_dynfield_widgets dw,
		acs_attributes at,
		acs_object_types t,
		acs_object_type_tables ott
	where
		a.object_type = :object_type
		and t.object_type = a.ancestor_type
		and a.attribute_id = aa.acs_attribute_id
		and a.attribute_id = at.attribute_id
		and aa.widget_name = dw.widget_name
		and ott.object_type = at.object_type
		and ott.table_name = at.table_name
		and a.attribute_name not in ('[join $exclude_attributes "','"]')
	order by
		attribute_id
    "

# fraber 2018-08-22:
# Now allowing to check for hard_coded fields like project_nr etc.
# -- and (aa.also_hard_coded_p is NULL or aa.also_hard_coded_p = 'f')
# This should not cause any trouble, because at the end we'll check
# for the attributes coming from the filter.

    set ext_table_sql "
	select distinct
		attribute_table_name as ext_table_name,
		object_type_id_column as ext_id_column
	from
		($attributes_sql) s
    "
    set ext_tables [list]
    set ext_table_join_where ""
    db_foreach ext_tables $ext_table_sql {
	if {$ext_table_name eq ""} { continue }
	if {$ext_table_name == $main_table_name} { continue }

	lappend ext_tables $ext_table_name
	append ext_table_join_where "\tand $main_table_name.$main_id_column = $ext_table_name.$ext_id_column\n"
    }

    set bind_vars [ns_set create]
    set criteria [list]
    db_foreach attributes $attributes_sql {

	# Check whether the attribute is part of the form
	if {[lsearch $form_elements $attribute_name] >= 0} {
	    set value [template::element::get_value $form_id $attribute_name]
	    ns_log Notice "search_sql_criteria_from_form: attribute_name=$attribute_name, tcl_widget=$widget, value='$value'"
	    if {"" == $value || 0 == $value} {
		ns_log Notice "search_sql_criteria_from_form: Skipping"
		continue
	    }
	    if {"{} {} {} {} {} {} {DD MONTH YYYY}" == $value} { continue }
	    ns_set put $bind_vars $attribute_name $value

	    # Special logic for each of the TCL widgets
	    switch $widget {
		text - textarea - richtext {
		    # Create a "like" search
		    # lappend criteria "$attribute_table_name.$attribute_name like '%:$attribute_name%'"
		    # lappend criteria "lower($attribute_table_name.$attribute_name) like '%\[string tolower \[string map {' {} \] {} \[ {} \$ {}} \[im_opt_val -limit_to nohtml $attribute_name\]\]\]%'"

		    lappend criteria "lower($attribute_table_name.$attribute_name) like '%'||:${attribute_name}||'%'"

		}
		date {
		    # Not supported yet
		    # We actually neeed to create two search fields, 
		    # one for start and one for end...
		    continue
		}
                checkbox {
                        # Frank: Here we would need a three-way select for
                        #        "true", "false" and "no filter". No idea
                        #        yet how to do that.
                        # Klaus: Not sure what you mean. If "no filter" than $value <> 't', right?
                        #        Following lines have been added to make checkbox work
		    if { "t" == $value } {
                                lappend criteria "($attribute_table_name.$attribute_name = '1' OR $attribute_table_name.$attribute_name = 't')"
		    }
		}
		im_category_tree {
		    lappend criteria "$attribute_table_name.$attribute_name in (select * from im_sub_categories(:$attribute_name))"
		}
		im_cost_center_tree {
		    set sub_cc_sql "
			select	sub_cc.cost_center_id
			from	im_cost_centers cc,
				im_cost_centers sub_cc
			where	cc.cost_center_id = :$attribute_name and
				substring(sub_cc.cost_center_code for length(cc.cost_center_code)) = cc.cost_center_code
		    "
		    lappend criteria "$attribute_table_name.$attribute_name in ($sub_cc_sql)"
		}
		default {
		    lappend criteria "$attribute_table_name.$attribute_name = :$attribute_name"
		}
	    }
	}
    }

    set where_clause [join $criteria " and\n            "]
    if { $where_clause ne "" } {
	set where_clause " and $where_clause"
    }

    set sql "
	(select
		$main_id_column as object_id
	from	
		[join [concat [list $main_table_name] $ext_tables] ",\n\t"]
	where	1 = 1 $ext_table_join_where
		$where_clause
	)
    "

    # Skip empty where clause
    if {"" == $where_clause} {
	set sql "" 
    }

    set extra(where) $sql
    set extra(bind_vars) [util_ns_set_to_list -set $bind_vars]
    ns_set free $bind_vars

    return [array get extra]
}


ad_proc -public im_dynfield::create_clone_update_sql {
    -object_type:required
    -object_id:required
} {
    Returns an SQL update statement that can be executed in
    the context of an object clone() procedure in order to
    update dynfields from variables in memory, pulled out
    of the DB by a statement such as "select p.* from im_projects...".
} {
    # Get the main table for the data type
    db_1row main_table "
	select
		table_name as main_table_name,
		id_column as main_id_column
	from
		acs_object_types
	where
		object_type = :object_type
    "

    set attributes_sql "
	select
		a.attribute_id,
		a.table_name as attribute_table_name,
		a.attribute_name,
		at.pretty_name,
		a.datatype,
		case when a.min_n_values = 0 then 'f' else 't' end as required_p,
		a.default_value,
		t.table_name as object_type_table_name,
		t.id_column as object_type_id_column,
		at.table_name as attribute_table,
		at.object_type as attr_object_type
	from
		acs_object_type_attributes a,
		im_dynfield_attributes aa,
		acs_attributes at,
		acs_object_types t
	where
		a.object_type = :object_type
		and t.object_type = a.ancestor_type
		and a.attribute_id = aa.acs_attribute_id
		and a.attribute_id = at.attribute_id
	order by
		attribute_id
    "

    set sql "update $main_table_name set\n"
    set komma_required 0
    db_foreach attributes $attributes_sql {
	if {$komma_required} { append sql "," }
	append sql "\t$attribute_name = :$attribute_name\n"
	set komma_required 1
    }

    append sql "where $main_id_column = $object_id\n"

    return $sql
}



ad_proc -public im_dynfield::set_form_values_from_http {
    -form_id:required
} {
    Set the values of a form based on the values from "ns_conn form".
    This procedure is usefule when using an ad_form as a "filter"
    selector in P/O index ("report") pages, to pass the URL
    parameters to the form.
    @param form_id:
		search form id
    @return:
		nothing

} {
    set form_elements [template::form::get_elements $form_id]
    set form_vars [ns_conn form]
    
    if {"" == $form_vars} { 
	# There are no variables from HTTP - so there
	# are not values to be set...
	return "" 
    }

    foreach element $form_elements {
	# Only set the values for variables that are found in the
	# HTTP variable frame to avoid ambiguities
	set pos [ns_set find $form_vars $element]
	if {$pos >= 0} {
	   set value [im_opt_val -limit_to nohtml $element]
	   template::element::set_value $form_id $element $value
	}
    }
}


ad_proc -public im_dynfield::set_local_form_vars_from_http {
    -form_id:required
} {
    Set local variables to the values passed on in HTTP,
    so that we don't need to add all of them into the ad header.
    @param form_id: search form id
    @return:	Form_vars that are also in the HTTP are set to the
		calling variable frame
} {
    set form_elements [template::form::get_elements $form_id]
    set form_vars [ns_conn form]
    
    if {"" == $form_vars} { 
	# There are no variables from HTTP - so there
	# are not values to be set...
	return "" 
    }

    foreach element $form_elements {
	# Only set the values for variables that are found in the
	# HTTP variable frame to avoid ambiguities
	set pos [ns_set find $form_vars $element]
	if {$pos >= 0} {
	   set value [im_opt_val -limit_to nohtml $element]

	   # Write the values to the calling stack frame
	   upvar $element $element
	   set $element $value
	}
	append debug " $element"
    }
}


ad_proc -public im_dynfield::attribute_store {
    {-include_also_hard_coded_p 0 }
    {-object_type ""}
    -object_id:required
    -form_id:required
    {-user_id ""}
} {
    Store intranet-dynfield attributes.
    Basicly, the procedure copies all values of the form into
    local variables and then builds an update statement to update
    the object's main table with the local variables.

    Doesn't support "extension tables" yet (storing attributes in
    tables different from the main object's table).
} {
    # -------------------------------------------------
    # Defaults and setup
    # -------------------------------------------------

    if {"" == $user_id} { set user_id [ad_conn user_id] }
    set current_user_id $user_id
    im_security_alert_check_alphanum -location "im_dynfield::attribute_store: object_type" -value $object_type

    # Get object_type main table and column id
    # fraber 111004: Also get other object fields. These are now obsolete in the arglist...
    db_1row get_main_table "
	select	ot.table_name as main_table,
		ot.id_column as main_table_id_column,
		o.object_type,
		im_biz_object__get_type_id(o.object_id) as object_subtype_id
	from	acs_object_types ot,
		acs_objects o
	where 	o.object_id = :object_id and
		o.object_type = ot.object_type
    "

    if { "user" == $object_type } {
        set object_type "person"
	set object_subtype_id [im_user_subtypes $object_id]
    }

    set object_id_org $object_id
    set object_type_org $object_type

    # Get the list of all variables of the form
    template::form get_values $form_id

    # -------------------------------------------------
    # Pull out display mode per attribute
    # -------------------------------------------------

    # Get display mode per attribute and object_type_id

    set sql "
       select	m.attribute_id,
                m.object_type_id as ot,
                m.display_mode as dm,
		m.help_text as ht
        from	im_dynfield_type_attribute_map m,
                im_dynfield_attributes a,
                acs_attributes aa
        where	m.attribute_id = a.attribute_id
                and a.acs_attribute_id = aa.attribute_id
                and aa.object_type = :object_type
    "

    db_foreach attribute_table_map $sql {
	set key "$attribute_id.$ot"
	set display_mode_hash($key) [string tolower $dm]
    }

    # -------------------------------------------------
    # Create the update SQL statement
    # -------------------------------------------------

    set attribute_sql "
	select	da.attribute_id as dynfield_attribute_id,
		*
	from	im_dynfield_attributes da,
		acs_attributes aa,
		im_dynfield_widgets dw
	where
		da.acs_attribute_id = aa.attribute_id
		and aa.object_type = :object_type_org
		and da.widget_name = dw.widget_name
		and 't' = acs_permission__permission_p(da.attribute_id, :current_user_id, 'write')
		and (also_hard_coded_p is NULL or also_hard_coded_p != 't' or 1 = :include_also_hard_coded_p)
	order by aa.attribute_name
    "

    array set update_lines {}
    db_foreach attributes $attribute_sql {

	# Skip attributes that do not exists in (the partial) form.
	if {![template::element::exists $form_id $attribute_name]} { 
	    continue 
	}

	# Empty table name? Ugly, but that's the main table then...
	if {$table_name eq ""} { set table_name $main_table }

        # object_subtype_id can be a list, so go through the list
        # and take the highest one (none - display - edit).
	set display_mode "undefined"
        foreach subtype_id $object_subtype_id {
            set key "$dynfield_attribute_id.$subtype_id"
	    ns_log Notice "im_dynfield::attribute_store: key: $key"
            if {[info exists display_mode_hash($key)]} {
		ns_log Notice "im_dynfield::attribute_store: display_mode_hash(key): $display_mode_hash($key)"
                switch $display_mode_hash($key) {
                    edit { set display_mode "edit" }
                    display { if {"edit" != $display_mode} { set display_mode "display" } }
                    none { if {"edit" != $display_mode && "display" != $display_mode} { set display_mode "display" } }
                }
            }
        }

	if {"edit" != $display_mode} { 
	    ns_log Notice "im_dynfield::attribute_store: Skipping writing attribute $object_type.$attribute_name because display_mode='$display_mode'"
	    continue 
	}

	# Is this a multi-value field?
	set multiple_p [template::element::get_property $form_id $attribute_name multiple_p]
	if {$multiple_p eq ""} { set multiple_p 0 }	
	if {$storage_type_id == [im_dynfield_storage_type_id_multimap]} { set multiple_p 1 }

	if {!$multiple_p} {

	    # Special treatment for certain types of widgets
	    set widget_element [template::element::get_property $form_id $attribute_name widget]

	    ns_log Notice "im_dynfield::attribute_store: attribute=$object_type.$attribute_name, widget_element=$widget_element"

	    switch $widget_element {
		date {
		    set ulines [list]
		    if {[info exists update_lines($table_name)]} { set ulines $update_lines($table_name) }
		    lappend ulines "\n\t\t\t$attribute_name = [template::util::date::get_property sql_timestamp [set $attribute_name]]"
		    set update_lines($table_name) $ulines
		}
		default {
		    set ulines [list]
		    if {[info exists update_lines($table_name)]} { set ulines $update_lines($table_name) }
		    lappend ulines "\n\t\t\t$attribute_name = :$attribute_name"
		    set update_lines($table_name) $ulines
		}
	    }

	} else {

	    # Multi-value field. This must be a field with widget multi-select...
	    db_transaction {
		db_dml del_previous_values "
			delete from im_dynfield_attr_multi_value
			where object_id = :object_id_org 
			and attribute_id = :attribute_id
		"
		foreach val [template::element::get_values $form_id $attribute_name] {
		    db_dml create_multi_value "
			insert into im_dynfield_attr_multi_value (attribute_id,object_id,value) 
			values (:attribute_id,:object_id_org,:val)"
		}
	    }
	}
    }

    foreach table_name [array names update_lines] {

	# Get the index column for the table_name
	set table_index_column [util_memoize [list db_string icol "
		select	id_column 
		from	acs_object_type_tables
		where	table_name = '$table_name'
			and object_type = '$object_type_org'
	" -default ""]]

	# Get the update lines for each table
	set ulines $update_lines($table_name)

	# Execute the update statement, assuming that all
	# variables will be available as local variables.
	if {[llength $ulines] > 0} {
	    set sql "
		update $table_name set[join $ulines ","]
		where $table_index_column = :object_id_org
	    "
	    db_dml update_object $sql
	}
	
    }
}


# ------------------------------------------------------------------
# DynFields per Subtype
# ------------------------------------------------------------------

ad_proc -public im_dynfield::dynfields_per_object_subtype {
    { -parent_category_id "" }
    -object_type:required
} {
    Returns the list of dynfield_attributes for each subtype
} {
    return [util_memoize [list im_dynfield::dynfields_per_object_subtype_helper -parent_category_id $parent_category_id -object_type $object_type]]
}

ad_proc -public im_dynfield::dynfields_per_object_subtype_helper {
    { -parent_category_id "" }
    -object_type:required
} {
    Returns the list of dynfield_attributes that are common to all 
    object subtypes
} {
    set type_category [im_dynfield::type_category_for_object_type -object_type $object_type]

    set mapping_sql "
	select distinct
		cat.category_id as type_id,
		m.attribute_id
	from	
		(select	category_id
		 from	im_categories
		 where	category_type = :type_category
		 	and enabled_p = 't'
		) cat
		LEFT OUTER JOIN (
			select	*
			from	im_dynfield_type_attribute_map
			where	display_mode in ('edit','display')
		) m on (cat.category_id = m.object_type_id)
    "
    if {"" ne $parent_category_id} {
	append mapping_sql "\t\tand cat.category_id in ([join [im_sub_categories $parent_category_id] ","])"
    }

    db_foreach dynfield_mapping $mapping_sql {
        if {0 eq $attribute_id || "" eq $attribute_id} { continue }
        if {0 eq $type_id || "" eq $type_id} { continue }
    	set attribs [list]
	if {[info exists attrib_hash($type_id)]} { set attribs $attrib_hash($type_id) }
	lappend attribs $attribute_id
	set attrib_hash($type_id) $attribs
    }
    return [array get attrib_hash]
}


ad_proc -public im_dynfield::subtype_have_same_attributes_p {
    { -parent_category_id "" }
    -object_type:required
} {
    Returns "1" if all object subtypes have the same list of dynfields.
    This routine is useful if we want to know if we have to redirect
    to the big-object-type-select page to select an object's subtype.
} {
    array set attrib_hash [im_dynfield::dynfields_per_object_subtype -parent_category_id $parent_category_id -object_type $object_type]
    set first_array_name [lindex [array names attrib_hash] 0]

    if {"" == $first_array_name} { 
	# No attributes at all, so yes, they're all the same...
	return 1 
    }

    set first_array_name_attribs $attrib_hash($first_array_name)

    set same_p 1
    foreach name [array names attrib_hash] {
	set attribs $attrib_hash($name)
	if {$attribs != $first_array_name_attribs} { set same_p 0 }
    }
    return $same_p
}






ad_proc -public im_dynfield::widget_request {
    -widget
    -request 
    -attribute_name 
    -pretty_name 
    -value 
    -optional_p 
    -form_name 
    -attribute_id 
    -html_options
    { -display_mode "edit" }
} {
    Corresponds to ::ams::widget::${widget} functions to answer to "request".
} {
    set value [ams::util::text_value -value $value]
    if { [llength $html_options] == 0 } { set html_options [list] }

    db_1row widget_params "select widget as acs_widget, acs_datatype,parameters as custom_parameters from im_dynfield_widgets where widget_name = :widget"

    switch $request {

        ad_form_widget  {

	        set help_text [attribute::help_text -attribute_id $attribute_id] 

	        set element [list]
	        if { [string is true $optional_p] } {
		        lappend element ${attribute_name}:${acs_datatype}(${acs_widget}),optional 
	        } else {
		        lappend element ${attribute_name}:text(text)
	        }

	        lappend element [list label ${pretty_name}]
	        lappend element [list html $html_options]
	        lappend element [list mode $display_mode]
	        lappend element [list custom $custom_parameters]
	        lappend element [list help_text $help_text]

	        switch $widget {
		        checkbox - radio - select - multiselect - im_category_tree - category_tree {
		            if {$debug} { ns_log Notice "im_dynfield::widget_request: select-widgets: with options" }
		            set option_list ""
		            set options_pos [lsearch $parameter_list "options"]
		            if {$options_pos >= 0} {
			            set option_list [lindex $parameter_list $options_pos+1]
		            }
		    
		            if { $required_p == "f" && $widget ne "checkbox" } {
			            set option_list [linsert $option_list -1 [list " [_ intranet-dynfield.no_value] " ""]]
		            }

		            # Drop-down widgets need an options list
		            lappend element [list options $option_list]
		        }
	        }
	        return $element
	    }
        template_form_widget  {
	        if { [string is true $optional_p] } {
		        ::template::element::create ${form_name} ${attribute_name} \
		        -label ${pretty_name} \
		        -datatype text \
		        -widget text \
		        -optional \
		        -html $html_options
	        } else {
		        ::template::element::create ${form_name} ${attribute_name} \
		        -label ${pretty_name} \
		        -datatype text \
		        -widget text \
		        -html $html_options
	        }
	    }
        form_set_value {
	        ::template::element::set_value ${form_name} ${attribute_name} $value
	    }
        form_save_value {
	        set value [::template::element::get_value ${form_name} ${attribute_name}]
	        return [ams::util::text_save -text $value -text_format "text/plain"]
	    }
        value_text {

#	    set status [template::util::aim::status -username $value]
#
            # getting the status can take too long. so we return it for html views
            # but do not return it for text. This is in part because text exports 
            # are often used for csv export and the like.
	        return $value
	    }
        value_html {

#	    switch $status {
#		"online"  {set status_html "<img src=\"/resources/ams/aim_online.gif\" alt\"online\" />"}
#		"offline" {set status_html "<img src=\"/resources/ams/aim_offline.gif\" alt=\"offline\" />"}
#		default   {set status_html "Not A Valid ID"}
#	    }
	        return "$value [template::util::aim::status_img -username $value]"
	    }
        csv_value {
	        # not yet implemented
	    }
        csv_headers {
	        # not yet implemented
	    }
        csv_save {
	        # not yet implemented
	    }
	    widget_datatypes {
	        return [list "string"]
	    }
	    widget_name {
	        return $widget
            #	    return [_ "intranet-dynfield.AIM"]
	    }
	    value_method {
	        set acs_widget [db_string widget_type "select widget from im_dynfield_widgets where widget_name = :widget" -default ""]
	        switch $acs_widget {
		        checkbox - multiselect - category_tree - im_category_tree - radio - select - generic_sql - im_cost_center_tree {
		            return "ams_value__options"
		        }
		        date {
		            return "ams_value__time"
		        }
		        default {
		            return "ams_value__text"
		        }
	        }
	    }
    }
}


ad_proc -public im_dynfield::elements {
    -list_ids:required
    {-privilege "read"}
    {-user_id ""}
} {
    This returns a list of lists with the attribute information
    It checks for permission on the dynfield
    
    @param list_ids Lists for which to get the elements
    @param orderby_clause Clause for odering the lists.

    @return list of lists where each attribute is made of <ol>
    <li>attribute_id
    <li>required_p  
    <li>section_heading
    <li>attribute_name 
    <li>pretty_name    
    <li>widget         
    <li>html_options</ol>
} {
    if {$user_id eq ""} {
        set user_id [ad_conn user_id]
    }
    set attributes [list]
    set list_ids [template::util::tcl_to_sql_list $list_ids]
    db_foreach select_elements " " {
        if {[im_object_permission -object_id $dynfield_attribute_id -user_id $user_id -privilege $privilege]} {
            lappend attributes [list $dynfield_attribute_id $attribute_id $section_heading $attribute_name \
                $pretty_name $attribute_id $sort_order $widget $required_p]
        }
    }
    return $attributes
}

ad_proc -public im_dynfield::append_attributes_to_form {
    {-object_subtype_id "" }
    -object_type:required
    -form_id:required
    {-object_id ""}
    {-search_p "0"}
    {-form_display_mode "edit" }
    {-advanced_filter_p 0}
    {-include_also_hard_coded_p 0 }
    {-exclude_attributes {} }
    {-page_url "default" }
    {-debug 0}
} {
    Append intranet-dynfield attributes for object_type to an existing form.<p>
    @option object_type The object_type attributes you want to add to the form
    @option object_subtype_id Specifies the "subtype" of the objects (i.e. project_type_id)
    @option advanced_filter_p Tells us that the dynfields are used for an 
            "advanced filter" as oposed to a data form. Text fields dont make
            much sense here, so we'll skip them.

    @param include_also_hard_coded_p Should we include fields that are also hard
            coded in ]po[ screens?

    @param page_url
		Serves to identify the page layout.

    @return Returns the number of added fields

    The code consists of two main parts:
    <ul>
    <li>Adding the the attributes to the forum and
    <li>Extracting the values of the attributes from a number of storage tables.
    </ul>
} {
    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: object_type=$object_type, object_id=$object_id" }
    set user_id [ad_conn user_id]
    set return_url [im_url_with_query]

    # Does the specified layout page exist? Otherwise use "default".
    set page_url_exists_p [db_string exists "
	select	count(*)
	from	im_dynfield_layout_pages
	where	object_type = :object_type and page_url = :page_url
    "]
    if {!$page_url_exists_p} { set page_url "default" }
    set form_page_url $page_url

    # Add a hidden "object_type" field to the form
    if {![template::element::exists $form_id "object_type"]} {
	if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: creating object_type=$object_type" }
    	template::element create $form_id "object_type" \
    			    -datatype text \
    			    -widget hidden \
    			    -value  $object_type
    }

    # add a hidden object_id field to the form
    if {([info exists object_id] && $object_id ne "")} {
    	if {![template::element::exists $form_id "object_id"]} {
	    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: creating object_id=$object_id" }
	    template::element create $form_id "object_id" \
		-datatype integer \
		-widget hidden \
		-value  $object_id
    	}
    }

    # Get display mode per attribute and object_type_id
    set sql "
       select	m.attribute_id,
                m.object_type_id as ot,
                m.display_mode as dm,
		m.help_text as ht,
		m.section_heading as sh
        from
                im_dynfield_type_attribute_map m,
                im_dynfield_attributes a,
                acs_attributes aa
        where
                m.attribute_id = a.attribute_id
                and a.acs_attribute_id = aa.attribute_id
                and aa.object_type = :object_type
    "

    if {!$include_also_hard_coded_p} { append sql "\t\tand also_hard_coded_p = 'f'\n" }

    # Default: Set all field to form's display mode
    set default_display_mode $form_display_mode

    db_foreach attribute_table_map $sql {
	set key "$attribute_id.$ot"
	set display_mode_hash($key) $dm
	set help_text($attribute_id) $ht
	set section_heading($attribute_id) $sh

	# Now we've got atleast one display mode configured:
	# Set the default to "none", so that no field is shown
	# except for the configured fields.
	set default_display_mode "none"

	if {$debug} { ns_log Notice "append_attributes_to_form: display_mode($key) <= $dm" }
    }

    # Disable the mechanism if the object_type_id hasn't been specified
    # (compatibility mode)
    if {"" == $object_subtype_id} { set default_display_mode "edit" }

    db_1row object_type_info "
        select
                t.table_name as object_type_table_name,
                t.id_column as object_type_id_column
        from
                acs_object_types t
        where
                t.object_type = :object_type
    "

    set extra_wheres [list "1=1"]

    # ------------------------------------------------------
    # In "Advanced Filter" mode the form is used to display
    # a list of filters for the /index.tcl page. In these
    # filters a special logic applies:
    # textarea: Doesn't make sense
    if {$advanced_filter_p} {
	if {"default" == $page_url} {
		# By default only show filters for drop-down type
		# of fields
		lappend extra_wheres "aw.widget in (
			'select', 'generic_sql', 
			'im_category_tree', 'im_cost_center_tree',
			'checkbox'
		)"
	} else {
		# The user has specified a specific "page_url"
		# in order to specify a custom layout of the filters.
		# Now exclude only Textarea fields. They are long and ugly...
		lappend extra_wheres "aw.widget not in (
			'textarea', 		-- Too long...
			'date',			-- We need start and end date for ranges
			'checkbox'		-- We would need a three-way select here
		)"		
	}
    }
    set extra_where [join $extra_wheres "\n\t\tand "]


    # We need to exclude also_hard_coded_p fields for most forms
    # since a lot of meta-fields were added for the REST interface. 
    # Otherwise object creation will fail for most objects.
    set also_hard_coded_p_sql ""
    if {!$include_also_hard_coded_p} { 
	set also_hard_coded_p_sql "and (also_hard_coded_p is NULL or also_hard_coded_p = 'f')" 
    } 

    set attributes_sql "
	select *
	from (
		select
			dl.*,
			coalesce(dl.pos_y, 10000 + a.attribute_id) as pos_y_coalesce,
			a.attribute_id,
			aa.attribute_id as dynfield_attribute_id,
			a.table_name as attribute_table_name,
			tt.id_column as attribute_id_column,
			a.attribute_name,
			a.pretty_name,
			a.datatype, 
			case when a.min_n_values = 0 then 'f' else 't' end as required_p, 
			a.default_value, 
			aw.widget,
			aw.parameters,
			aw.storage_type_id,
			im_category_from_id(aw.storage_type_id) as storage_type
		from
			im_dynfield_attributes aa
			LEFT OUTER JOIN	(
				select	* 
				from	im_dynfield_layout 
				where	page_url = :form_page_url
			) dl ON (aa.attribute_id = dl.attribute_id),
			im_dynfield_widgets aw,
			acs_attributes a 
			left outer join 
				acs_object_type_tables tt 
				on (tt.object_type = :object_type and tt.table_name = a.table_name)
		where 
			a.object_type = :object_type
			and a.attribute_id = aa.acs_attribute_id
			and aa.widget_name = aw.widget_name
			and aa.attribute_id in (select distinct attribute_id from im_dynfield_type_attribute_map)
			and a.attribute_name not in ('[join $exclude_attributes "', '"]')
			and $extra_where
			$also_hard_coded_p_sql
		) t
	order by
		pos_y_coalesce
    "
#    ad_return_complaint 1 [im_ad_hoc_query -format html $attributes_sql]

    set field_cnt 0
    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: Now looping through attributes and evaluate show mode" }
    db_foreach attributes $attributes_sql {

	if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: ***** Evaluating attribute name: $attribute_name" }

	# Check if the elements as disabled in the layout page
	if {$page_url_exists_p && "" == $page_url} { 
	    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: Skipping - no page URL found" }
	    continue 
	}

	# Check if the current user has the right to read and write on the dynfield
	set read_p [im_object_permission \
			-object_id $dynfield_attribute_id \
			-user_id $user_id \
			-privilege "read" \
	]
	set write_p [im_object_permission \
			-object_id $dynfield_attribute_id \
			-user_id $user_id \
			-privilege "write" \
	]
	if {!$read_p} { 
	    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: Skipping, not readable" }
	    continue 
	}

	set display_mode $default_display_mode
	if {$advanced_filter_p} {
	    # In filter mode the user also needs to be able to "write"
	    # the field, otherwise he won't be able to enter values...
	    if {!$write_p} { 
		if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: Skipping, 'Advanced Filter Mode' requires write permissions." }
		continue 
	    }
	}

	# object_subtype_id can be a list, so go through the list
	# and take the highest one (none - display - edit).
	foreach subtype_id $object_subtype_id {
	    set key "$dynfield_attribute_id.$subtype_id"
	    if {[info exists display_mode_hash($key)]} { 
		switch $display_mode_hash($key) {
		    edit { set display_mode "edit" }
		    display { if {$display_mode eq "none"} { set display_mode "display" } }
		}
	    }
	}

	if {$debug} { ns_log Notice "append_attributes_to_form2: name=$attribute_name, display_mode=$display_mode" }

	if {"edit" == $display_mode && "display" == $form_display_mode}  {
            set display_mode $form_display_mode
        }
	if {"edit" == $display_mode && !$write_p}  {
            set display_mode "display"
        }

	if {$debug} { ns_log Notice "append_attributes_to_form3: name=$attribute_name, display_mode=$display_mode" }

	if {"none" == $display_mode} { 
	    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: Skipping, display_mode = 'none'" }
	    continue 
	}

	# Don't show a read-only mode in an "edit" form
	# Doesn't work yet, because the field is expected later
#	if {"display" == $display_mode && "edit" == $form_display_mode}  {
#	    continue
#        }

	# Resize the size and parameters of some widgets for the filter form
	if {$advanced_filter_p} {
	    switch $widget {
		text {
		    # Adapt the size of the textbox to filters
		    set parameters [list [list html [list size 16]]]
		}
	    }
	}

	if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: attribute_name=$attribute_name, datatype=$datatype, widget=$widget, storage_type_id=$storage_type_id" }

	# set optional all attributes if search mode
	if {$search_p} { set required_p "f" }

	# Show "wrench" for administrators
	set admin_p [im_is_user_site_wide_or_intranet_admin [ad_conn user_id]]
	set admin_html ""
	if {$admin_p} {
	    set admin_help ""
	    set dynfield_admin_url [export_vars -base "/intranet-dynfield/attribute-new" {{attribute_id $dynfield_attribute_id} return_url}]
	    set admin_html "<a href='$dynfield_admin_url'>[im_gif -translate_p 0 wrench $admin_help]</a>"
	}
    
	# Help
        if {[info exists help_text($dynfield_attribute_id)]} {
            set help_message $help_text($dynfield_attribute_id)
        } else {
            set help_message ""
        }

        if {[info exists section_heading($dynfield_attribute_id)]} {
            set section_head $section_heading($dynfield_attribute_id)
        } else {
            set section_head ""
        }

	im_dynfield::append_attribute_to_form \
	    -attribute_name $attribute_name \
	    -widget $widget \
	    -form_id $form_id \
	    -datatype $datatype \
	    -display_mode $display_mode \
	    -parameters $parameters \
	    -required_p $required_p \
	    -pretty_name $pretty_name \
	    -help_text $help_message \
	    -section_heading $section_head \
	    -admin_html $admin_html

	# fraber 110405: doesn't work.
	# Doesn't save form values when editing
	#     upvar $attribute_name x
	#     if {[info exists x]} {
	#         template::element::set_value $form_id $attribute_name $x
	#     }

	incr field_cnt

    }	

    # That's all until here IF this is a new object. Otherwise, we'll need 
    # to retreive the object's values from several tables and from the multi-fields...
    #
    if { ![template::form is_request $form_id] } { return }
    if { ![info exists object_id]} { return }


    # Same loop as before...
    db_foreach attributes $attributes_sql {

	# Check if the elements is disabled in the layout page
	if {$page_url_exists_p && "" == $page_url} { continue }

	# Check if the current user has the right to read the dynfield
	if {![im_object_permission -object_id $dynfield_attribute_id -user_id $user_id]} { continue }
	
	# Default display mode
	set display_mode $default_display_mode

	# object_subtype_id can be a list, so go through the list
	# and take the highest one (none - display - edit).
	foreach subtype_id $object_subtype_id {
	    set key "$dynfield_attribute_id.$subtype_id"
	    if {[info exists display_mode_hash($key)]} { 
		switch $display_mode_hash($key) {
		    edit { set display_mode "edit" }
		    display { if {$display_mode eq "none"} { set display_mode "display" } }
		}
	    }
	}

	# Don't show "none" fields...
	if {"none" == $display_mode} { continue }

	switch $storage_type {
	    multimap {
		# "MultiMaps" (select with multiple values) are stored in a separate
		# "im_dynfield_attr_multi_value", because we can't store it like the
		# other attributes directly inside the object's table.
		if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: multipmap storage" }
		template::element set_properties $form_id $attribute_name "multiple_p" "1"
		set value_list [db_list get_multiple_values "
			select	value 
			from	im_dynfield_attr_multi_value
			where	attribute_id = :dynfield_attribute_id
				and object_id = :object_id
		"]
		template::element::set_values $form_id $attribute_name $value_list
	    }
	    value - default {

		# ToDo: slow. This piece issues N SQL statements, instead of constructing
		# a single SQL and issuing it once. Causes performance problems at BaselKB
		# for example.
		set value [db_string get_single_value "
		    select	$attribute_name
		    from	$attribute_table_name
		    where	$attribute_id_column = :object_id
		" -default ""]

                switch $widget {
                    date {
                        set date [template::util::date::create]
                        set value [template::util::date::set_property ansi $date $value]
                    }
                    default { }
                }

		# Don't overwrite values with default value if the value is there already
                if {$value ne ""} {
                    if {$debug} { ns_log Notice "im_dynfield::append_attributes_to_form: default storage: name=$attribute_name, value=$value" }
                    template::element::set_value $form_id $attribute_name $value
                }

	    }

	}
    }

    # Callback to allow external functions to modify the values in the form

    if {[catch {
	callback ${object_type}_form_fill \
	    -form_id $form_id \
	    -object_type $object_type \
	    -object_id $object_id \
	    -type_id $object_subtype_id \
	    -page_url $page_url \
	    -advanced_filter_p $advanced_filter_p \
	    -include_also_hard_coded_p $include_also_hard_coded_p
    } err_msg]} {
	ad_return_complaint 1 "<b>Error with callback '${object_type}_form_fill'</b>:<br>
		Please check your callback code and make sure that your object type '$object_type'
		is part of the list 'object_types' in ~/packages/intranet-core/tcl/intranet-core-init.tcl"
	ad_script_abort
    }
    
    return $field_cnt
}




ad_proc -public im_dynfield::append_attribute_to_form {
    -widget:required
    -form_id:required
    -datatype:required
    -display_mode:required
    -parameters:required
    -required_p:required
    -attribute_name:required
    -pretty_name:required
    -help_text:required
    {-section_heading ""}
    {-admin_html "" }
    {-debug 0}
} {
    Append a single attribute to a form
} {
    # Might translate the datatype into one for which we have a
    # validator (e.g. a string datatype would change into text).
    set translated_datatype [attribute::translate_datatype $datatype]
    if {$datatype eq "number"} {
        set translated_datatype "float"
    } elseif {$datatype eq "date"} {
        set translated_datatype "date"
    }

    set custom_parameters ""
    set html_parameters ""
    set after_html_parameters ""
    set format_parameters ""
    set option_parameters ""
    foreach parameter_list $parameters {
        # Find out if there is a "custom" parameter and extract its value
        # "Custom" is the parameter to pass-on widget parameters from the
        # DynField Maintenance page to certain form Widgets.
        # Example: "custom {sql {select ...}}" in the "generic_sql" widget.

        set custom_pos [lsearch $parameter_list "custom"]
        if {$custom_pos >= 0} {
            set custom_parameters [lindex $parameter_list $custom_pos+1]
        }

        set html_pos [lsearch $parameter_list "html"]
        if {$html_pos >= 0} {
            set html_parameters [lindex $parameter_list $html_pos+1]
        }

        set format_pos [lsearch $parameter_list "format"]
        if {$format_pos >= 0} {
            set format_parameters [lindex $parameter_list $format_pos+1]
        }

        set after_html_pos [lsearch $parameter_list "after_html"]
        if {$after_html_pos >= 0} {
            set after_html_parameters [subst [lindex $parameter_list $after_html_pos+1]]
        }

	set options_pos [lsearch $parameter_list "options"]
	if {$options_pos >= 0} {
	    set option_parameters [lindex $parameter_list $options_pos+1]
	}
    }

    # Localization - use the intranet-core L10n space for translation.
    set package_key "intranet-core"
    set pretty_name_key "$package_key.[lang::util::suggest_key $pretty_name]"
    set pretty_name [lang::message::lookup "" $pretty_name_key $pretty_name]

    # Show help text as part of a help GIF
    if {$help_text ne ""} {
        set after_html [im_gif -translate_p 0 help $help_text]
    } else {
        set after_html ""
    }

    append after_html $admin_html

    if {$debug} { ns_log Notice "im_dynfield::append_attribute_to_form: form_id=$form_id, attribute_name=$attribute_name, widget=$widget" }

    if {"" != $section_heading} {
	template::form::section -legendtext $section_heading $form_id $section_heading
    }

    # ToDo: Can we unify this switch?
    # Is there a problem to pass an "options" parameter to a date widget?
    switch $widget {
        checkbox - radio - select - multiselect - im_category_tree - category_tree {
	    # These widgets need an additional -options parameter
            if { $required_p == "f" && $widget ne "checkbox" } {
                set option_parameters [linsert $option_parameters -1 [list " [_ intranet-dynfield.no_value] " ""]]
            }
            if {![template::element::exists $form_id "$attribute_name"]} {
                template::element create $form_id "$attribute_name" \
                    -datatype "text" [ad_decode $required_p "f" "-optional" ""] \
                    -widget $widget \
                    -label "$pretty_name" \
                    -options $option_parameters \
                    -custom $custom_parameters \
                    -html $html_parameters \
                    -after_html "$after_html $after_html_parameters" \
                    -mode $display_mode
            }
        }
        date {
            if {![template::element::exists $form_id "$attribute_name"]} {
                template::element create $form_id "$attribute_name" \
                    -datatype $translated_datatype [ad_decode $required_p f "-optional" ""] \
                    -widget $widget \
                    -label $pretty_name \
                    -html $html_parameters \
                    -custom $custom_parameters\
                    -after_html "$after_html $after_html_parameters" \
                    -mode $display_mode \
		    -format $format_parameters
            }
        }
        default {
            if {![template::element::exists $form_id "$attribute_name"]} {
                template::element create $form_id "$attribute_name" \
                    -datatype $translated_datatype [ad_decode $required_p f "-optional" ""] \
                    -widget $widget \
                    -label $pretty_name \
                    -html $html_parameters \
                    -custom $custom_parameters\
                    -after_html "$after_html $after_html_parameters" \
                    -mode $display_mode
            }
        }
    }
}


ad_proc -public im_dynfield::append_attributes_to_im_view {
    -object_type:required
    {-include_also_hard_coded_p 0 }
    {-table_prefix "" }
} {
    Returns a list with three elements:

    Element 0: A list of PrettyNames, suitable to be appended to the
    "column_headers" list of a project-open im_view type of ListPage
    (such as ProjectListPage, CompanyListPage, ...)

    Element 1: A list of "display_tcl" expressions suitable to be appended 
    to the "column_vars" list of a project-open im_view ListPage.

    Element 2: A list of select expressions suitable to be included
    in a SQL select statement

    ToDo: Element 1 currently only contains works for columns of 
    storage type "table_column" and will only show the table value
    itself, instead of a value, depending on the "display" mode of
    the corresponding widet.

    table_prefix is a trick when your're trying to aggregate values
    of a joined object, such as the "im_company" in the case of
    im_invoices.
} {
    set current_user_id [ad_conn user_id]

    set also_hard_coded_p_sql ""
    if {!$include_also_hard_coded_p} { 
	set also_hard_coded_p_sql "and (also_hard_coded_p is NULL or also_hard_coded_p = 'f')" 
    } 

    set attributes_sql "
	select	a.*,
		aa.attribute_id as dynfield_attribute_id,
		tt.id_column as attribute_id_column,
		t.table_name as object_type_table_name,
		t.id_column as object_type_id_column,
		aw.widget,
		aw.parameters,
		aw.storage_type_id,
		aw.deref_plpgsql_function,
		im_category_from_id(aw.storage_type_id) as storage_type,
		coalesce(dl.pos_y, 9999) as layout_sort_order
	from
		im_dynfield_attributes aa
		LEFT OUTER JOIN (
			select	*
			from	im_dynfield_layout
			where	page_url = 'default'
		) dl ON (dl.attribute_id = aa.attribute_id),
		im_dynfield_widgets aw,
		acs_object_types t,
		acs_attributes a
		left outer join
			acs_object_type_tables tt
			on (tt.object_type = :object_type and tt.table_name = a.table_name)
	where
		t.object_type = :object_type
		and a.object_type = t.object_type
		and a.attribute_id = aa.acs_attribute_id
		and aa.widget_name = aw.widget_name
		and im_object_permission_p(aa.attribute_id, :current_user_id, 'read') = 't'
		$also_hard_coded_p_sql
	order by
		layout_sort_order
    "

    set column_headers [list]
    set column_vars [list]
    set column_select [list]
    db_foreach dynfield_attributes $attributes_sql {

	# Apply the dereferencing function in order to convert catgory_ids into text etc.
        set deref "$table_prefix$attribute_name"
        if {"" != $deref_plpgsql_function} {
            set deref "${deref_plpgsql_function}($deref)"
        }

        lappend column_headers $pretty_name
        lappend column_vars "\$${attribute_name}_deref"
        lappend column_select "$deref as ${attribute_name}_deref,"
    }

    return [list $column_headers $column_vars $column_select]
}


ad_proc -public im_dynfield::package_id {} {

    TODO: Get the INTRANET-DYNFIELD package ID, not the connection package_id
    Get the package_id of the intranet-dynfield instance

    @return package_id
} {
    return [apm_package_id_from_key "intranet-dynfield"]
}


# ------------------------------------------------------------------
# Compose the Pl/SQL call to create a new object
# ------------------------------------------------------------------

namespace eval im_dynfield::plsql {}

ad_proc -public im_dynfield::plsql::new_object_create_call {
    -object_type:required
} {
    Returns the Pl/SQL call to create a new object of type object_type.
    The call expects that all relevant variables are available in the
    calling variable frame.
    The call returns the object_id of the new object.
    Example:
    im_report__new(null, 
} {
    set plsql_function "${object_type}__new"
    set vars [db_list vars "
	select	':'||lower(arg_name) as arg_name
	from	acs_function_args
	where	function = upper(:plsql_function)
	order by arg_seq
    "]
    return "${plsql_function}([join $vars ","])"
}


ad_proc -public im_dynfield::plsql::required_variables {
    -object_type:required
} {
    Returns the list of variables that need to be present in order to
    execute the new_object_create_call Pl/SQL call successfully.
} {
    set plsql_function "${object_type}__new"
    set index_column [im_dynfield::plsql::index_column -object_type $object_type]

    return [db_list required_vars "
	select	lower(arg_name) as arg_name
	from	acs_function_args
	where	function = upper(:plsql_function)
		and lower(arg_name) != :index_column
    "]
}

ad_proc -public im_dynfield::plsql::index_column {
    -object_type:required
} {
    Returns the index column for the object's main table
} {
    return [db_string oindex_column "select id_column from acs_object_types where object_type = :object_type" -default ""]
}


ad_proc -public im_dynfield::util::missing_attributes_from_table {
    -table_name:required
} {
    Returns a list of list of column names from the table which 
    are not in acs_attributes. This helps to insert elements into acs_attributes
    if they are not there.
    
    I did not write an automated procedure to insert them into acs_attributes 
    or im_dynfield_attributes as too much information is misssing for doing this
    in a computed fashion. Best to read the outcome of this procedure and then write the
    statements for im_dynfield::add manually. 
} {
    return [db_list_of_lists missing_attributes {
              SELECT
                  a.attname as "Column",
                  pg_catalog.format_type(a.atttypid, a.atttypmod) as "Datatype"
              FROM
                  pg_catalog.pg_attribute a
              WHERE
                  a.attnum > 0
                  AND NOT a.attisdropped
                  AND a.attrelid = (
                      SELECT c.oid
                      FROM pg_catalog.pg_class c
                          LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
                      WHERE c.relname = :table_name
                          AND pg_catalog.pg_table_is_visible(c.oid)
                  )
                  and attname not in (select attribute_name from acs_attributes aa, acs_object_types ot where aa.object_type = ot.object_type and ot.table_name = :table_name)
    }]
}


ad_proc -public im_dynfield::attribute_validate {
    {-object_type ""}
    -object_id:required
    -form_id:required
    {-user_id ""}
} {
    Validates intranet-dynfield attributes and ensures a clean 
    error handling. In some cases the object is already created  
    when im_dynfield::attribute_store is called. Therfore we 
    need a separate function to be called before the object 
    is created. 
} {
    # -------------------------------------------------
    # Defaults and setup
    # -------------------------------------------------

    if {"" == $user_id} { set user_id [ad_conn user_id] }
    set current_user_id $user_id

    if { "user" == $object_type } {
        set object_type "person"
    }

    # Get the list of all variables of the form
    template::form get_values $form_id

    set attribute_sql "
        select  da.attribute_id as dynfield_attribute_id,
                aa.pretty_name	as pretty_name_err,
		*
        from    im_dynfield_attributes da,
                acs_attributes aa,
                im_dynfield_widgets dw
        where
                da.acs_attribute_id = aa.attribute_id
                and aa.object_type = :object_type
                and da.widget_name = dw.widget_name
                and 't' = acs_permission__permission_p(da.attribute_id, :current_user_id, 'write')
                and (also_hard_coded_p is NULL or also_hard_coded_p != 't')
        order by aa.attribute_name
    "

    db_foreach attributes $attribute_sql {
        # Skip attributes that do not exists in (the partial) form.
        if {![template::element::exists $form_id $attribute_name]} {
            continue
        }
        # Type validation	
	if { "" != [template::element::get_values $form_id $attribute_name] } {
	        switch $widget_name {
        	    numeric {
                    	    if { ![string is double -strict [template::element::get_values $form_id $attribute_name]] } {
	                       ad_return_complaint 1 [lang::message::lookup "" intranet-dynfield.ErrNotNumeric "Numeric value expected for field \"$pretty_name_err\""]
			    }
		    }
               }
	}

    }
}



# ------------------------------------------------------------
# Find out all fields per object type
# -------------------------------------------------------

ad_proc im_dynfield::object_attributes_for_select {
     -object_type:required
} {
    Returns a list {key1 value1 key2 value2 ...} of attributes
    and pretty_names for object.
    The result is meant to be appended to the select list of
    a report with custom fields
} {
    set dynfield_sql "
        select
                aa.attribute_name,
                aa.pretty_name,
                ot.pretty_name as object_type_pretty_name,
                w.deref_plpgsql_function
        from
                acs_attributes aa
                RIGHT OUTER JOIN
                        im_dynfield_attributes fa
                        ON (aa.attribute_id = fa.acs_attribute_id)
                LEFT OUTER JOIN
                        (select * from im_dynfield_layout where page_url = '') la
                        ON (fa.attribute_id = la.attribute_id)
                LEFT OUTER JOIN
                        user_tab_columns c
                        ON (c.table_name = upper(aa.table_name) and c.column_name = upper(aa.attribute_name)),
                im_dynfield_widgets w,
                acs_object_types ot
        where
                aa.object_type = :object_type
                and fa.widget_name = w.widget_name
                and aa.object_type = ot.object_type
        order by
                la.pos_y, la.pos_x, aa.attribute_name
    "

    set field_options [list]
    db_foreach dynfield_fields $dynfield_sql {
        lappend field_options "${attribute_name}_deref"
        lappend field_options "$object_type_pretty_name - $pretty_name"
    }

    return $field_options
}



ad_proc im_dynfield::object_attributes_derefs {
    -object_type:required
    {-prefix ""}
} {
    Returns a list list of dereferentiation "SELECT" statements.
} {
    set dynfield_sql "
        select
                aa.attribute_name,
                aa.pretty_name,
                ot.pretty_name as object_type_pretty_name,
                w.deref_plpgsql_function
        from
                acs_attributes aa
                RIGHT OUTER JOIN
                        im_dynfield_attributes fa
                        ON (aa.attribute_id = fa.acs_attribute_id)
                LEFT OUTER JOIN
                        (select * from im_dynfield_layout where page_url = '') la
                        ON (fa.attribute_id = la.attribute_id)
                LEFT OUTER JOIN
                        user_tab_columns c
                        ON (c.table_name = upper(aa.table_name) and c.column_name = upper(aa.attribute_name)),
                im_dynfield_widgets w,
                acs_object_types ot
        where
                aa.object_type = :object_type
                and fa.widget_name = w.widget_name
                and aa.object_type = ot.object_type
        order by
                la.pos_y, la.pos_x, aa.attribute_name
    "

    set deref_list [list]
    db_foreach dynfield_fields $dynfield_sql {
        lappend deref_list "${deref_plpgsql_function}($prefix$attribute_name) as ${attribute_name}_deref"
    }
    return $deref_list
}



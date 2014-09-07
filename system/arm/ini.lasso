<?lassoscript

	var('arm_data' = map)
	$arm_data->insert('preferences' = map)
	$arm_data->insert('language' = map)
	$arm_data->insert('view_areas' = map)
	// $arm_data->insert('addon_root' = string)

	library_once( include_path + 'sourcefile.lasso' )
	library_once( include_path + 'arm_pref.lasso' )
	library_once( include_path + 'arm_lang.lasso' )
	library_once( include_path + 'arm_addon.lasso' )
	library_once( include_path + 'arm_model.lasso' )
	library_once( include_path + 'arm_view.lasso' )
	library_once( include_path + 'arm_controller.lasso' )
	library_once( include_path + 'arm.lasso' )

?>
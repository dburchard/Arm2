<?lassoscript

	var('arm_data' = MAP)
	$arm_data->insert( 'registry' = VOID )
	$arm_data->insert( 'preferences' = MAP )
	$arm_data->insert( 'language' = MAP )
	$arm_data->insert( 'view_areas' = MAP )
	$arm_data->insert( 'view_metadata' = ARRAY )
	$arm_data->insert( 'view_js' = MAP )
	$arm_data->insert( 'view_css' = MAP )
	$arm_data->insert( 'path' = ARRAY)

	library_once( include_path + 'sourcefile.lasso' )
	library_once( include_path + 'arm_path.lasso' )
	library_once( include_path + 'arm_pref.lasso' )
	library_once( include_path + 'arm_lang.lasso' )
	library_once( include_path + 'arm_addon.lasso' )
	library_once( include_path + 'arm_model.lasso' )
	library_once( include_path + 'arm_view.lasso' )
	library_once( include_path + 'arm_build.lasso' )
	library_once( include_path + 'arm_controller.lasso' )
	library_once( include_path + 'arm.lasso' )

?>
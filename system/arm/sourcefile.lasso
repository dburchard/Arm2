<?lassoscript

	define sourcefile->view_title() => {
		return $arm_data->find( 'view_title' )
	}

	define sourcefile->view_metadata() => {
		return $arm_data->find( 'view_metadata' )
	}

	define sourcefile->view_body() => {
		return $arm_data->find( 'view_body' )
	}

	define sourcefile->view_area( slug::string ) => {
		return $arm_data->find( 'view_areas' )->find( #slug )->invoke
	}

	define sourcefile->partial( loc::string ) => {
		return include( include_path + arm_pref( 'sys:partial_path' ) + #loc + arm_pref( 'sys:file_suffix' ))
	}

?>
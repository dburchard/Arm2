<?lassoscript

	define arm_path_set() => {
		local( 'gp' = client_getparam( arm_pref( 'sys:path_argument' )))
		#gp->removeleading( arm_pref('sys:path_delimiter' ))
		$arm_data->find('path') = #gp->split( arm_pref('sys:path_delimiter' ))
	}
	define arm_path( segment::integer ) => {
		if( #segment <= $arm_data->find('path')->size AND #segment > 0 ) => {
			return( $arm_data->find('path')->get( #segment ) )
		}
		return NULL
	}

	define arm_path_push( element::string ) => {
		$arm_data->find('path')->insert( #element, 1 )
	}

	define arm_path_remove( segment::integer ) => {
		$arm_data->find('path')->remove( #segment )
	}

?>
<?lassoscript

	define Arm_View => type {
		data protected controller	=	NULL
		data protected variables	=	ARRAY
		data protected file_name		=	STRING

		public set_controller( c::any ) => {
			.'controller' = #c
		}

		public set( n::string, v::any ) => {
			.'variables'->insert( pair( #n = #v ))
			return self
		}

		public title( v::string ) => {
			$arm_data->insert( 'view_title' = #v )
			return self
		}

		public metadata( v::string ) => {
			$arm_data->insert( 'view_metadata' = #v )
			return self
		}

		public area( slug::string, package::any ) => {
			$arm_data->find( 'view_areas' )->insert( #slug = #package )
			return self
		}

		public build( t::string ) => {
			.'file_name' = #t
			.dump
			return self
		}

		public build() => {
			.dump
			return self
		}

		public dump( plugin::boolean = FALSE ) => {

			.'variables'->foreach => {
				var(#1->name = #1->value)
			}

			// protect => {

			$arm_data->insert( 'view_body' = include(

				.'controller'->root_directory + 
				.'controller'->pref('sys:view_path') + 
				.'file_name' + 
				.'controller'->pref( 'sys:file_suffix')
			))

			if( #plugin ) => {
				.'controller'->buffer( $arm_data->find( 'view_body' ))
			else
				.'controller'->buffer( include(
	
					.'controller'->pref('sys:theme_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref('sys:path_delimiter') + 
					.'controller'->pref('sys:template_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref( 'sys:file_suffix')
	
				))
			}

			// }
		}
	}

	define Arm_PluginView => type {
		parent Arm_View

		public build( t::string ) => {
			.'file_name' = #t
			.dump( TRUE )
			return self
		}

		public build() => {
			.dump( TRUE )
			return self
		}
	}

?>
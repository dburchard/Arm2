<?lassoscript

	define Arm_Addon => type {

		data addon_name				=	NULL
		data addon					=	NULL

		public oncreate( name::string, args::staticarray = staticarray ) => {

			local( 'path' = arm_pref('sys:addon_path')->asarray )
			#path->foreach => {
				#1->append( #name + arm_pref('sys:path_delimiter') )
			}
			#path->insert( arm_pref( 'sys:default_addon' ) )
			local( 'root_directory' = .load_addon( #path ))

			.run_controller( .'addon_name', #root_directory )

			return .'addon'->buffer

		}

		private load_addon( a::array ) => {

			if( #a->size == 0 ) => {
				fail( -1, arm_lang( 'sys.controller_error', (: '@cont' = .'addon_name' )))
				return
			}

			local( 'n' = #a( 1 )->ascopy )
			#n->removetrailing( arm_pref('sys:path_delimiter') )
			.'addon_name' = #n->split( arm_pref('sys:path_delimiter') )->last

			local('file_found' = TRUE)
			protect => {
				handle_failure => { #file_found = FALSE }
				library_once(
					#a( 1 ) +
					arm_pref( 'sys:controller_path' ) +
					.'addon_name' +
					arm_pref( 'sys:file_suffix' )
				)
			}
			
			if( NOT #file_found ) => {
				#a->remove( 1 )
				.load_addon( #a )
			else
				.load_addon_preferences( #a( 1 ))
				.load_addon_language( #a( 1 ))
			}
			return #a( 1 )

		}

		private load_addon_preferences( root_directory::string ) => {
			library_once(
				#root_directory +
				arm_pref( 'sys:preference_path' ) +
				.'addon_name' +
				arm_pref( 'sys:preference_suffix' ) +
				arm_pref( 'sys:file_suffix' )
			)
		}

		private load_addon_language( root_directory::string ) => {
			arm_lang_loadfile( 
				#root_directory +
				arm_pref( 'sys:language_path' ) +
				.'addon_name' +
				'.'
			)
		}

		protected run_controller( name::string, root_directory::string ) => {
			.'addon' = escape_tag( #name )->invoke
			.'addon'->root_directory( #root_directory )
			.run_method( arm_path( 2 )->asstring )
		}

		public run_method( p::string ) => {
			if( #p == '' && .'addon'->hasmethod( ::index )) => {
				.'addon'->index
				return
			}

			protect => {
				.'addon'->escape_member( tag( #p))->invoke
				return
			}

			if( .'addon'->hasmethod( ::_not_found )) => {
				.'addon'->_not_found
				return
			}

			// fall back to the _not_found method of the default addon
			// Code a means of restarting arm_addon with an empty path

			fail( -1, arm_lang( 'sys.method_error', (: '@mname' = #p ) ))

		}

	}

	define Arm_Plugin => type {
		parent Arm_Addon

		public oncreate( name::string, args::staticarray = staticarray ) => {
			return ..oncreate( #name, #args )
		}

		public run_method( p::string ) => {
			if( .'addon'->hasmethod( ::_plugin )) => {
				.'addon'->_plugin
				return
			}

			fail( -1, arm_lang( 'sys.method_error', (: '@mname' = #p ) ))
		}

	}

?>
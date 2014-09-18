<?lassoscript

	define Arm_Addon => type {

		public oncreate( addon_name::string ) => {
			local( 'addon' = .start( #addon_name ))
			return #addon->buffer
		}

		private start( addon_name::string ) => {

			local( 'method_name' = arm_path( 2 )->asstring )
			local( 'addon' = VOID )

			if( #addon_name ) => {
				local( 'success' = FALSE )
				protect => {
					#addon = .load_addon( #addon_name )
					#success = TRUE
				}

				if( NOT #success ) => {
					#addon = .load_addon( arm_pref( 'sys:default_addon' ))
					if( .run_method( #addon, #addon_name )) => {
						return #addon
					}

					fail( -1, arm_lang( 'sys.method_error', (: '@cname' = #addon->type->asstring, '@mname' = #addon_name )))
				}

				if( .run_method( #addon, #method_name )) => {
					return #addon
				}

				#addon = .load_addon( arm_pref( 'sys:default_addon' ))
				if( . run_method( #addon, '_not_found' )) => {
					return #addon
				}

				fail( -1, arm_lang( 'sys.method_error', (: '@cname' = #addon_name, '@mname' = #method_name )))

			else
				#addon = .load_addon( arm_pref( 'sys:default_addon' ))
				.run_method( #addon, '' )
				return #addon

			}
		}

		private load_addon( addon_name::string ) => {

			local( 'addon_root' = '' )
			local( 'addon' = VOID )

			local( 'success' = FALSE )
			arm_pref( 'sys:addon_path' )->foreach => {
				local( 'search_path' = #1 )
				protect => {
					library(
						#search_path +
						#addon_name + arm_pref('sys:path_delimiter') +
						arm_pref( 'sys:controller_path' ) +
						#addon_name + arm_pref( 'sys:file_suffix' )
					)
					#addon_root = #search_path + #addon_name + arm_pref('sys:path_delimiter')
					#success = TRUE
				}
				if( #success ) => {
					.load_addon_preferences( #addon_name, #addon_root )
					.load_addon_language( #addon_name, #addon_root )
				}
			}

			NOT #success ? fail( -1, arm_lang( 'sys.file_error', (: '@fname' = #addon_name + arm_pref( 'sys:file_suffix' ))))

			local( 'success' = FALSE )
			protect => {
				NOT $arm_data->contains( 'addon_root_directory' ) ? $arm_data->insert( 'addon_root_directory' = '' )
				local( 'outside_root' = $arm_data->find( 'addon_root_directory' ))

				$arm_data->insert( 'addon_root_directory' = #addon_root )
				#addon = escape_tag( #addon_name )->invoke
				#addon->root_directory( #addon_root )

				$arm_data->insert( 'addon_root_directory' = #outside_root )
				NOT #addon->_registry_required ? #success = TRUE
			}

			NOT #success ? fail( -1, arm_lang( 'sys.controller_error', (: '@cname' = #addon_name )))

			#addon->load_build( #addon_name )

			return #addon

		}
		
		private run_method( addon::any, method_name::string ) => {

			if( #method_name == '' && #addon->hasmethod( ::index )) => {
				#addon->index
				return TRUE
			}
		
			if( #addon->hasmethod( tag( #method_name ))) => {
				#addon->escape_member( tag( #method_name ))->invoke
				return TRUE
			}

			if(#addon->hasmethod( ::_not_found )) => {
				#addon->_not_found
				return TRUE
			}

			return FALSE

		}

		private load_addon_preferences( addon_name::string, addon_root::string ) => {
			library_once(
				#addon_root +
				arm_pref( 'sys:preference_path' ) +
				#addon_name +
				arm_pref( 'sys:preference_suffix' ) +
				arm_pref( 'sys:file_suffix' )
			)
		}

		private load_addon_language( addon_name::string, addon_root::string ) => {
			arm_lang_loadfile( 
				#addon_root +
				arm_pref( 'sys:language_path' ) +
				#addon_name +
				'.'
			)
		}

	}

	define Arm_Plugin => type {
		parent Arm_Addon

		data args::staticarray		=	staticarray

		public oncreate( name::string, args::staticarray = staticarray ) => {
			.'args' = #args
			return ..oncreate( #name )
		}

		public run_method( addon::any, method_name::string ) => {
			if( #addon->hasmethod( ::_plugin )) => {
				#addon->_plugin(: .'args' )
				return TRUE
			}

			return FALSE
		}

	}

?>
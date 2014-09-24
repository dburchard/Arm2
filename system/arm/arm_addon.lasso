<?lassoscript

	define Arm_Addon => type {

		public oncreate( addon_name::string ) => {
			local( 'addon' = .start( #addon_name ))
			return #addon->buffer
		}

		protected start( addon_name::string ) => {

			local( 'method_name' = arm_path( 2 )->asstring )
			local( 'addon' = VOID )

			if( #addon_name ) => {
				#addon = .load_addon( #addon_name )

				if( NOT #addon ) => {
					#addon = .load_addon( arm_pref( 'sys:default_addon' ))
					NOT #addon ? fail( -1, arm_lang( 'sys.controller_error', (: '@cname' = .controller_name( #addon_name ))))
					if( .run_method( #addon, #addon_name )) => {
						return #addon
					}

					fail( -1, arm_lang( 'sys.method_error', (: '@cname' = #addon->type->asstring, '@mname' = #addon_name )))
				}

				if( .run_method( #addon, #method_name )) => {
					return #addon
				}

				#addon = .load_addon( arm_pref( 'sys:default_addon' ))
				NOT #addon ? fail( -1, arm_lang( 'sys.controller_error', (: '@cname' = #addon_name )))
				if( .run_method( #addon, '_not_found' )) => {
					return #addon
				}

				fail( -1, arm_lang( 'sys.method_error', (: '@cname' = #addon_name, '@mname' = #method_name )))

			else
				#addon = .load_addon( arm_pref( 'sys:default_addon' ))
				NOT #addon ? fail( -1, arm_lang( 'sys.controller_error', (: '@cname' = #addon_name )))
				.run_method( #addon, '' )
				return #addon

			}
		}

		protected controller_name( addon_name::string ) => {
			return #addon_name
		}

		protected controller_path( search_path::string, addon_name::string ) => {
			local( 'out' = '' )
			#out->append( #search_path )
			#out->append( #addon_name )
			#out->append( arm_pref('sys:path_delimiter' ))
			#out->append( arm_pref( 'sys:controller_path' ))
			#out->append( #addon_name )
			#out->append( arm_pref( 'sys:file_suffix' ))
			return #out
		}

		protected load_addon( addon_name::string ) => {

			local( 'addon_root' = '' )
			local( 'addon' = VOID )

			local( 'success' = FALSE )

			arm_pref( 'sys:addon_path' )->foreach => {
				local( 'search_path' = #1 )

				// #addon_name == 'test' && #search_path == 'system/addons/' ? fail( -5, .controller_path( #search_path, #addon_name ) )

				protect => {
					library(
						.controller_path( #search_path, #addon_name )
					)
					#addon_root = #search_path + #addon_name + arm_pref('sys:path_delimiter')
					#success = TRUE
				}
				if( #success ) => {
					.load_addon_preferences( #addon_name, #addon_root )
					.load_addon_language( #addon_name, #addon_root )
				}
			}
			NOT #success ? return FALSE

			local( 'success' = FALSE )
			protect => {
				NOT $arm_data->contains( 'addon_root_directory' ) ? $arm_data->insert( 'addon_root_directory' = '' )
				local( 'outside_root' = $arm_data->find( 'addon_root_directory' ))

				$arm_data->insert( 'addon_root_directory' = #addon_root )
				#addon = escape_tag( .controller_name( #addon_name ))->invoke
				#addon->root_directory( #addon_root )

				$arm_data->insert( 'addon_root_directory' = #outside_root )
				#success = TRUE
			}
			NOT #success ? return FALSE

			NOT #addon->_registry_required ? return #addon

			$arm_data->find( 'registry' )->is_registered( #addon ) ? return #addon

			return FALSE

		}
		
		protected run_method( addon::any, method_name::string ) => {

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

		protected load_addon_preferences( addon_name::string, addon_root::string ) => {
			library_once(
				#addon_root +
				arm_pref( 'sys:preference_path' ) +
				#addon_name +
				arm_pref( 'sys:preference_suffix' ) +
				arm_pref( 'sys:file_suffix' )
			)
		}

		protected load_addon_language( addon_name::string, addon_root::string ) => {
			arm_lang_loadfile( 
				#addon_root +
				arm_pref( 'sys:language_path' ) +
				#addon_name +
				'.'
			)
		}

	}

	define Arm_Admin => type {
		parent Arm_Addon

		public oncreate( name::string ) => {
			return ..oncreate( #name )
		}

		protected controller_name( addon_name::string ) => {
			return #addon_name + '_admin'
		}

		protected controller_path( search_path::string, addon_name::string ) => {
			local( 'out' = '' )
			#out->append( #search_path )
			#out->append( #addon_name )
			#out->append( arm_pref('sys:path_delimiter' ))
			#out->append( arm_pref( 'sys:controller_path' ))
			#out->append( arm_pref( 'sys:admin_filename' ))
			#out->append( arm_pref( 'sys:file_suffix' ))
			return #out
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
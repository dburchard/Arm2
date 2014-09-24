<?lassoscript

	define Arm_PublicController => type {

		data protected view				=	NULL
		data protected buffer			=	STRING
		data protected root_directory	=	NULL
		data protected build			=	NULL
		data public _registry_required	=	TRUE

		public asstring() => {
			return .buffer()
		}

		public lang( key::string, params::staticarray = staticarray ) => {
			return arm_lang( #key, #params )
		}

		public pref( key::string ) => {
			return arm_pref( #key )
		}

		public buffer( b::string ) => {
			.'buffer' = #b
		}

		public buffer() => {
			return .'buffer'
		}

		public load_build( addon_name::string ) => {
			local( 'filepath' = .root_directory + arm_pref( 'sys:build_filename' ) + .pref( 'sys:file_suffix' ) )
			local( 'success' = FALSE )
			protect => {
				include_raw( #filepath )
				#success = TRUE
			}
			if( #success ) => {
				library_once( #filepath )
				.'build' = escape_tag( #addon_name + '_' +  arm_pref( 'sys:build_filename' ))->invoke
			}
		}

		public root_directory( package::string ) => {
			.'root_directory' = #package
		}

		public root_directory() => {
			if( .'root_directory'->type == NULL->type ) => {
				return $arm_data->find( 'addon_root_directory' )
			else
				return .'root_directory'
			}
		}

		protected view( c::string = '' ) => {
			if( .'view'->type != Arm_View->type ) => {
				.'view' = Arm_View
				.'view'->set_controller( self )
			}
			return .'view'
		}

		protected plugin_view( c::string = '' ) => {
			if( .'view'->type != Arm_PluginView->type ) => {
				.'view' = Arm_PluginView
				.'view'->set_controller( self )
			}
			return .'view'
		}

		protected admin_view( c::string = '' ) => {
			if( .'view'->type != Arm_AdminView->type ) => {
				.'view' = Arm_AdminView
				.'view'->set_controller( self )
			}
			return .'view'
		}

		protected load_library( c::string ) => {
			protect => {
				(: .pref( 'sys:library_path' ), .root_directory + .pref( 'sys:library_path' ) )->foreach => {
					library_once(
						#1 +
						#c +
						.pref( 'sys:file_suffix' )
					)
				}
			}
		}

		protected load_model( c::string ) => {
			library_once(
				.root_directory +
				.pref( 'sys:model_path' ) +
				#c +
				.pref( 'sys:file_suffix' )
			)
		}

	}

	define Arm_AdminController => type {
		parent Arm_PublicController

		data user					=	STRING

		public oncreate() => {
			.'user' = 'foo'
		}

	}

?>
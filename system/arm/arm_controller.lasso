<?lassoscript

	define Arm_PublicController => type {

		data protected view				=	NULL
		data protected buffer			=	STRING
		data protected root_directory	=	NULL

		public asstring() => {
			return .buffer()
		}

		public buffer( b::string ) => {
			.'buffer' = #b
		}

		public buffer() => {
			return .'buffer'
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

		public lang( key::string, params::staticarray = staticarray ) => {
			return arm_lang( #key, #params )
		}

		public pref( key::string ) => {
			return arm_pref( #key )
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
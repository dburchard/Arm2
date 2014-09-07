<?lassoscript

	define Arm_PublicController => type {

		data protected view				=	NULL
		data protected root_directory	=	NULL
		data protected buffer			=	STRING

		public path( segment::integer = -1) => {
			local( 'gp' = client_getparam( .pref( 'sys:path_argument') ))
			#gp->removeleading( .pref('sys:path_delimiter') )
			local( 'path' = #gp->split( .pref('sys:path_delimiter') ))
			if( #segment <= #path->size AND #segment > 0 ) => {
				return( #path->get( #segment ) )
			}
			return NULL
		}

		public asstring() => {
			return .buffer()
		}

		public buffer( b::string ) => {
			.'buffer' = #b
		}

		public buffer() => {
			return .'buffer'
		}

		public root_directory( path::string ) => {
			.'root_directory' = #path
		}

		public root_directory() => {
			return .'root_directory'
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

		protected cleanup_callsitefile( csf::string ) => {

			local( 'controller_path' = arm_pref( 'sys:controller_path' ))
			#controller_path->removetrailing('/')

			local( 'path' = #csf->ascopy )
			#path = #path->split( '//' )->last
			#path = #path->split( '/' )
			#path->removelast
			#path = #path->join( '/' )
			#path->removetrailing( #controller_path )
			return #path
		}

		protected load_library( c::string ) => {

			local( 'addon_root' = .cleanup_callsitefile( currentCapture->continuation->callsite_file ))

			protect => {
				(: .pref( 'sys:library_path' ), #addon_root + .pref( 'sys:library_path' ) )->foreach => {
					library_once(
						#1 +
						#c +
						.pref( 'sys:file_suffix' )
					)
				}
			}
		}

		protected load_model( c::string ) => {
			
			local( 'addon_root' = .cleanup_callsitefile( currentCapture->continuation->callsite_file ))

			library_once(
				#addon_root +
				.pref( 'sys:model_path' ) +
				#c +
				.pref( 'sys:file_suffix' )
			)
		}

		/*
		protected load_controller( c::string ) => {
			library_once(
				.pref( 'sys:controller_path' ) +
				#c +
				.pref( 'sys:file_suffix' )
			)
		}

		protected run_controller( c::string ) => {
			escape_tag( #c )->invoke->run_method( .path( 2 )->asstring )
		}

		public run_method( p::string ) => {

			if( #p == '' && .hasmethod( ::index )) => {
				.index
				return
			}

			protect => {
				.escape_member( tag( #p))->invoke
				return
			}

			if( .hasmethod( ::_not_found )) => {
				._not_found
				return
			}

			fail( -1, .lang( 'sys.method_error', (: '@mname' = #p ) ))

		}
		*/

	}

	define Arm_AdminController => type {
		parent Arm_PublicController

		data user					=	STRING

		public oncreate() => {
			.'user' = 'foo'
		}

	}

?>
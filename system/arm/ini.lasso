<?lassoscript

	var('arm_data' = map)
	$arm_data->insert('preferences' = map)
	$arm_data->insert('language' = map)
	$arm_data->insert('controller_root' = string)

	define sourcefile->view_title() => {
		return $arm_data->find( 'view_title' )
	}

	define sourcefile->view_metadata() => {
		return $arm_data->find( 'view_metadata' )
	}

	define sourcefile->view_body() => {
		return $arm_data->find( 'view_body' )
	}

	define arm_pref( key::string ) => {
		local( 'o' = $arm_data->find('preferences')->find(#key) )
		fail_if( #o->type == void->type, -1, 'Preference key "' + #key + '" not found.' )
		return #o
	}

	define arm_pref( content::pair ) => {
		$arm_data->find('preferences')->insert( #content )
	}

	define arm_lang( key::string ) => {
		local( 'o' = $arm_data->find('language')->find(#key) )
		fail_if( #o->type == void->type, -1, 'Language key "' + #key + '" not found.' )
		return #o
	}

	define arm_lang( content::pair ) => {
		$arm_data->find('language')->insert( #content )
	}

	define Arm_Model => type {
	}

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

		public build( t::string ) => {
			.'file_name' = #t
			return .build
		}

		public build() => {
			.'variables'->foreach => {
				var(#1->name = #1->value)
			}
			$arm_data->insert( 'view_body' = include( .'controller'->root_directory + '/views/' + .'file_name' + '.lasso' ))
			web_response->rawcontent = include( $arm_data->find('theme_location') + $arm_data->find('theme_name') + '/templates/' + $arm_data->find('theme_name') + '.lasso' )
			return self
		}
	}

	define Arm_PublicController => type {

		data protected view		=	NULL

		public path( segment::integer = -1) => {
			local( 'path' = client_getparam( .pref( 'sys:path_argument') )->split( '/' ))
			if( #segment <= #path->size AND #segment > 0 ) => {
				return( #path->get( #segment ) )
			}
			return NULL
		}

		public root_directory() => {
			return $arm_data->find( 'controller_root' )
		}

		public lang( key::string, params::staticarray = staticarray ) => {
			local( 'lang' = arm_lang( #key )->ascopy)
			#params->foreach => {
				#lang->replace( #1->name, #1->value )
			}
			return #lang
		}

		public pref( key::string, params::staticarray = staticarray ) => {
			local( 'pref' = arm_pref( #key )->ascopy)
			#params->foreach => {
				#pref->replace( #1->name, #1->value )
			}
			return #pref
		}

		protected view( c::string = '' ) => {
			if( .'view'->type != Arm_View->type ) => {
				.'view' = Arm_View
				.'view'->set_controller( self )
			}
			return .'view'
		}

		protected run_controller( c::string ) => {
			escape_tag( #c )->invoke->run_method( (.path( 2 ) === NULL ? '' | .path( 2 )))
		}

		protected run_method( p::string ) => {

			if( #p == '' && .hasmethod( ::index )) => {
				.index
				return
			}

			protect => {
				.escape_member( tag( #p))->invoke
				return
			}

			if( .hasmethod( ::not_found )) => {
				.not_found
				return
			}

			fail( -1, .lang( 'sys.method_error', (: '@mname' = #p ) ))

		}

	}

	define Arm_AdminController => type {
		parent Arm_PublicController

		data user					=	STRING

		public oncreate() => {
			.'user' = 'foo'
		}

	}

	define Arm => type {
		parent Arm_PublicController

		data addon_name				=	NULL

		public oncreate() => {

			// .load_database()
			// .load_environment()

			.load_default_preferences()
			.load_default_language()

			.load_theme()
			.load_theme_preferences()
			.load_theme_language()

			.load_addon( array('add-ons/','system/add-ons/','-default') )
			.load_addon_preferences()
			.load_addon_language()

			.run_controller( .'addon_name' )

		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosycracy of BBEdit's code folding of 
			// Lasso script.
			include('preferences/' + 'default_p.lasso')
		}

		private load_default_language() => {
			include('language/' + .pref( 'sys:default_language') + '.lasso')
		}

		private load_theme() => {
			$arm_data->insert( 'theme_name' = .pref('sys:default_themename'))
			$arm_data->insert( 'theme_location' = .pref('sys:default_themelocation'))
		}

		private load_theme_preferences() => {
			include($arm_data->find('theme_location') + $arm_data->find('theme_name') + '/preferences/' + $arm_data->find('theme_name') + '_p.lasso')
		}

		private load_theme_language() => {
			include($arm_data->find('theme_location') + $arm_data->find('theme_name') + '/language/' + .pref( 'sys:default_language') + '.lasso')
		}

		private load_addon( a::array ) => {

			.'addon_name' = .path( 1 )

			if( #a->size == 0 ) => {
				fail( -1, .lang( 'sys.controller_error', (: '@cont' = .'addon_name' )))
				return
			}

			if( #a( 1 ) == '-default' ) => {
				#a->get( 1 ) = .pref( 'sys:default_addonlocation')
				.'addon_name' = .pref( 'sys:default_addonname')
			}

			local('file_found' = TRUE)
			protect => {
				handle_failure => { #file_found = FALSE }
				library_once( #a( 1 ) + .'addon_name' + '/controllers/' + .'addon_name' + '.lasso' )
			}
			
			if( NOT #file_found ) => {
				#a->remove( 1 )
				.load_addon( #a )
			}

			$arm_data->find( 'controller_root' ) = #a( 1 ) + .'addon_name'
		}

		private load_addon_preferences() => {
			include($arm_data->find('controller_root') + '/preferences/' + .'addon_name' + '_p.lasso')
		}

		private load_addon_language() => {
			include($arm_data->find('controller_root') + '/language/' + .'addon_name' + '_l.' + .pref( 'sys:default_language') + '.lasso')
		}

	}


?>
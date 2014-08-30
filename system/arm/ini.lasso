<?lassoscript

	var('arm_data' = map)
	$arm_data->insert('preferences' = map)
	$arm_data->insert('language' = map)
	$arm_data->insert('controller_root' = string)

	define sourcefile->template_title() => {
		return $arm_data->find( 'template_title' )
	}

	define sourcefile->template_metadata() => {
		return $arm_data->find( 'template_metadata' )
	}

	define sourcefile->template_body() => {
		return $arm_data->find( 'template_body' )
	}

	define arm_pref( name::string ) => {
		return $arm_data->find('preferences')->find(#name)
	}

	define arm_pref( content::pair ) => {
		$arm_data->find('preferences')->insert( #content )
	}

	define arm_lang( key::string ) => {
		return $arm_data->find('language')->find(#key)
	}

	define arm_lang( content::pair ) => {
		$arm_data->find('language')->insert( #content )
	}

	define Arm_Model => type {
	}

	define Arm_View => type {
		data protected controller	=	NULL
		data protected variables	=	ARRAY
		data protected template		=	STRING

		public set_controller( c::any ) => {
			.'controller' = #c
		}

		public set( n::string, v::any ) => {
			.'variables'->insert( pair( #n = #v ))
			return self
		}

		public title( v::string ) => {
			$arm_data->insert( 'template_title' = #v )
			return self
		}

		public metadata( v::string ) => {
			$arm_data->insert( 'template_metadata' = #v )
			return self
		}

		public build( t::string ) => {
			.'template' = #t
			return .build
		}

		public build() => {
			.'variables'->foreach => {
				var(#1->name = #1->value)
			}
			$arm_data->insert( 'template_body' = include( .'controller'->root_directory + '/views/' + .'template' + '.lasso' ))
			web_response->rawcontent = include( $arm_data->find('theme_location') + $arm_data->find('theme_name') + '/views/' + $arm_data->find('theme_name') + '.lasso' )
			return self
		}
	}

	define Arm_PublicController => type {

		data protected template		=	NULL

		public path( segment::integer = -1) => {
			local( 'path' = client_getparam( 'ap' )->split( '/' )) // ••••••
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

		protected template( c::string = '' ) => {
			if( .'template'->type != Arm_View->type ) => {
				.'template' = Arm_View
				.'template'->set_controller( self )
			}
			return .'template'
		}

		protected run_controller( c::string ) => {
			escape_tag( #c + '_controller' )->invoke->run_method( (.path( 2 ) === NULL ? '' | .path( 2 )))
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

		data controller				=	NULL

		public oncreate() => {

			.load_default_preferences()
			.load_default_language()

			.load_theme()
			.load_theme_preferences()
			.load_theme_language()

			.load_controller( array('add-ons/','system/add-ons/','-default') )
			.run_controller( .'controller' )

		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosycracy of BBEdit's code folding of 
			// Lasso script.
			include('preferences/' + 'public.lasso')
		}

		private load_default_language() => {
			include('language/' + .pref( 'sys:default_language') + '.lasso')
		}

		private load_theme() => {
			$arm_data->insert( 'theme_name' = .pref('sys:default_themename'))
			$arm_data->insert( 'theme_location' = .pref('sys:default_themelocation'))
		}

		private load_theme_preferences() => {
			include($arm_data->find('theme_location') + $arm_data->find('theme_name') + '/preferences/public.lasso')
		}

		private load_theme_language() => {
			include($arm_data->find('theme_location') + $arm_data->find('theme_name') + '/language/' + .pref( 'sys:default_language') + '.lasso')
		}

		private load_controller( a::array ) => {

			.'controller' = .path( 1 )

			if( #a->size == 0 ) => {
				fail( -1, 'The requested controller "' + .'controller' + '_controller" does not exist.' ) // ••••••
				return
			}

			if( #a( 1 ) == '-default' ) => {
				#a->get( 1 ) = .pref( 'sys:default_addonlocation') // default controller-path from database
				.'controller' = .pref( 'sys:default_addonname') // default controller-name from database
			}

			local('file_found' = TRUE)
			protect => {
				handle_failure => { #file_found = FALSE }
				library_once( #a( 1 ) + .'controller' + '/controllers/public.lasso' )
			}
			
			if( NOT #file_found ) => {
				#a->remove( 1 )
				.load_controller( #a )
			}

			$arm_data->find( 'controller_root' ) = #a( 1 ) + .'controller'
		}

	}


?>
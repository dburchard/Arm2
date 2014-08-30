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
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail_if( #o->type == void->type, -1, 'Preference key "' + #key + '" not found.' )
		return #o
	}

	define arm_pref( content::pair ) => {
		$arm_data->find('preferences')->insert( #content )
	}

	define arm_lang( key::string ) => {
		local( 'o' = $arm_data->find('language')->find(#key) )
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
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
			$arm_data->insert( 'view_body' = include(

				.'controller'->root_directory + 
				'/' + 
				.'controller'->pref('sys:view_path') + 
				.'file_name' + 
				.'controller'->pref( 'sys:file_suffix')
			))

			web_response->rawcontent = include(

				.'controller'->pref('sys:theme_path') + 
				$arm_data->find('theme_name') + 
				'/' + 
				.'controller'->pref('sys:template_path') + 
				$arm_data->find('theme_name') + 
				.'controller'->pref( 'sys:file_suffix')

			)
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

			local( 'path' = .pref('sys:addon_path')->ascopy->asarray )
			#path->foreach => {
				#1->append( .path(1) )
			}
			#path->insert( .pref( 'sys:default_addon' ) )
			.load_addon( #path )
			.load_addon_preferences()
			.load_addon_language()

			.run_controller( .'addon_name' )

		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosycracy of BBEdit's code folding of 
			// Lasso script.
			include( 'preferences/' + 'default_p.lasso' )
		}

		private load_default_language() => {
			include(
				.pref( 'sys:language_path' ) +
				.pref( 'sys:default_language' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_theme() => {
			$arm_data->insert( 'theme_name' = .pref('sys:default_theme'))
		}

		private load_theme_preferences() => {
			include(
				.pref( 'sys:theme_path' ) +
				$arm_data->find( 'theme_name')  +
				'/' +
				.pref( 'sys:preference_path' ) +
				$arm_data->find('theme_name' ) +
				.pref( 'sys:preference_suffix' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_theme_language() => {
			include(
				.pref( 'sys:theme_path' ) +
				$arm_data->find('theme_name' ) +
				'/' +
				.pref( 'sys:language_path' ) +
				.pref( 'sys:default_language' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_addon( a::array ) => {

			.'addon_name' = #a( 1 )->split( '/' )->last

			if( #a->size == 0 ) => {
				fail( -1, .lang( 'sys.controller_error', (: '@cont' = .'addon_name' )))
				return
			}

			local('file_found' = TRUE)
			protect => {
				handle_failure => { #file_found = FALSE }
				library_once(
					#a( 1 ) +
					'/' +
					.pref( 'sys:controller_path' ) +
					.'addon_name' +
					.pref( 'sys:file_suffix' )
				)
			}
			
			if( NOT #file_found ) => {
				#a->remove( 1 )
				.load_addon( #a )
			}

			$arm_data->find( 'controller_root' ) = #a( 1 )
		}

		private load_addon_preferences() => {
			include(
				$arm_data->find( 'controller_root' ) +
				'/' +
				.pref( 'sys:preference_path' ) +
				.'addon_name' +
				.pref( 'sys:preference_suffix' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_addon_language() => {
			include(
				$arm_data->find( 'controller_root' ) +
				'/' +
				.pref( 'sys:language_path' ) +
				.'addon_name' +
				.pref( 'sys:language_suffix' ) +
				'.' +
				.pref( 'sys:default_language' ) +
				.pref( 'sys:file_suffix' )
			)
		}

	}


?>
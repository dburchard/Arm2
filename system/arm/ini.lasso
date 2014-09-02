<?lassoscript

	var('arm_data' = map)
	$arm_data->insert('preferences' = map)
	$arm_data->insert('language' = map)
	$arm_data->insert('addon_root' = string)

	define sourcefile->view_title() => {
		return $arm_data->find( 'view_title' )
	}

	define sourcefile->view_metadata() => {
		return $arm_data->find( 'view_metadata' )
	}

	define sourcefile->view_body() => {
		return $arm_data->find( 'view_body' )
	}

	define sourcefile->partial( loc::string ) => {
		local( 'current_path' = Include_CurrentPath->split( arm_pref('sys:path_delimiter') ) )
		#current_path->removelast
		#current_path = #current_path->join( arm_pref('sys:path_delimiter') )
		return include( #current_path + arm_pref('sys:path_delimiter') + arm_pref( 'sys:partial_path' ) + #loc + arm_pref( 'sys:file_suffix' ))
	}

	define arm_pref( ... ) => {
		local( environment = '' )
		local( key = '' )
		local( package = PAIR )
		#rest->foreach => {
			local( 'param' = #1 )
			#param->isa( ::keyword ) ? #environment = #param->name->asstring
			#param->isa( ::string ) ? #key = #param
			#param->isa( ::pair ) ? #package = #param
		}
		#environment->lowercase
		#key->size > 0 ? return arm_pref_get( #key, #environment )
		#package->name->size > 0 ? return arm_pref_set( #package, #environment )
	}

	define arm_pref_get( key::string, environment::string ) => {
		if( #environment->size > 0 ) => {
			return arm_pref_getenv( #key, #environment )
		}
		return arm_pref_getany( #key )
	}

	define arm_pref_getenv( key::string, environment::string ) => {
		local( 'out' = $arm_data->find('preferences')->find( #key + ' @ ' + #environment ))
		#out->type != VOID->type ? return #out
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail( -1, 'Preference key "' + #key + '", for environment "' + #environment + '", not found.' )
	}

	define arm_pref_getany( key::string ) => {
		local( 'out' = $arm_data->find('preferences')->find( #key + ' @ ' + action_param( 'arm_env' )))
		#out->type != VOID->type ? return #out
		#out = $arm_data->find('preferences')->find( #key + ' @ any')
		#out->type != VOID->type ? return #out
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail( -1, 'Preference key "' + #key + '" not found.' )
	}

	define arm_pref_set( package::pair, environment::string ) => {
		if( #environment->size > 0 ) => {
			arm_pref_setenv( #package, #environment )
			return VOID
		}
		arm_pref_setany( #package )
		return VOID
	}

	define arm_pref_setenv( package::pair, environment::string ) => {
		$arm_data->find('preferences')->insert( #package->name + ' @ ' + #environment = #package->value )
	}

	define arm_pref_setany( package::pair ) => {
		$arm_data->find('preferences')->insert( #package->name + ' @ any' = #package->value )
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
				.'controller'->pref('sys:view_path') + 
				.'file_name' + 
				.'controller'->pref( 'sys:file_suffix')
			))

			web_response->rawcontent = include(

				.'controller'->pref('sys:theme_path') + 
				$arm_data->find('theme_name') + 
				.'controller'->pref('sys:path_delimiter') + 
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
			local( 'gp' = client_getparam( .pref( 'sys:path_argument') ))
			#gp->removeleading( .pref('sys:path_delimiter') )
			local( 'path' = #gp->split( .pref('sys:path_delimiter') ))
			if( #segment <= #path->size AND #segment > 0 ) => {
				return( #path->get( #segment ) )
			}
			return NULL
		}

		public root_directory() => {
			return $arm_data->find( 'addon_root' )
		}

		public lang( key::string, params::staticarray = staticarray ) => {
			local( 'lang' = arm_lang( #key )->ascopy)
			#params->foreach => {
				#lang->replace( #1->name, #1->value )
			}
			return #lang
		}

		public pref( key::string, params::staticarray = staticarray ) => {
			return arm_pref( #key )->ascopy
		}

		protected view( c::string = '' ) => {
			if( .'view'->type != Arm_View->type ) => {
				.'view' = Arm_View
				.'view'->set_controller( self )
			}
			return .'view'
		}

		protected load_library( c::string ) => {
			protect => {
				(: .pref( 'sys:library_path' ), $arm_data->find( 'addon_root' ) + .pref( 'sys:library_path' ) )->foreach => {
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
				$arm_data->find( 'addon_root' ) +
				.pref( 'sys:model_path' ) +
				#c +
				.pref( 'sys:file_suffix' )
			)
		}

		protected load_controller( c::string ) => {
			library_once(
				.pref( 'sys:controller_path' ) +
				#c +
				.pref( 'sys:file_suffix' )
			)
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

			.load_default_preferences()
			.load_default_language()

			inline(
					web_request->params,
					.pref( 'sys:development_database' ), // .pref( -Development, 'sys:database' )
					-nothing) => {

				.load_theme()
				.load_theme_preferences()
				.load_theme_language()

				local( 'path' = .pref('sys:addon_path')->ascopy->asarray )
				#path->foreach => {
					#1->append( .path(1) + .pref('sys:path_delimiter') )
				}
				#path->insert( .pref( 'sys:default_addon' ) )
				.load_addon( #path )
				.load_addon_preferences()
				.load_addon_language()

				.run_controller( .'addon_name' )
			}

		}

		private accepted_language() => {
			local( 'x' = FALSE)
			local( 's' = '')
			web_request->httpAcceptLanguage->split('')->foreach => {
				(string_isalpha( #1 ) OR #1 == '-' OR #1 == ',') AND NOT #x ? #s->append( #1 ) | #x = TRUE
			}
			#s->lowercase
			#s = #s->split(',')
			NOT #s->contains( .pref( 'sys:default_language' ) ) ? #s->insert( .pref( 'sys:default_language' ) )
			#s->reverse
			return #s
		}

		private load_language_file( filepath::string ) => {
			.accepted_language()->foreach => {
				local( 'p' = #filepath + #1 + .pref( 'sys:file_suffix' ))
				protect => {
					include( #p )
				}
			}
		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosycracy of BBEdit's code folding of 
			// Lasso script.
			include( 'preferences/' + 'default_p.lasso' )
		}

		private load_default_language() => {
			.load_language_file( .pref( 'sys:language_path' ) )
		}

		private load_theme() => {
			$arm_data->insert( 'theme_name' = .pref('sys:default_theme'))
		}

		private load_theme_preferences() => {
			include(
				.pref( 'sys:theme_path' ) +
				$arm_data->find( 'theme_name')  +
				.pref('sys:path_delimiter') +
				.pref( 'sys:preference_path' ) +
				$arm_data->find('theme_name' ) +
				.pref( 'sys:preference_suffix' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_theme_language() => {
			.load_language_file(
				.pref( 'sys:theme_path' ) +
				$arm_data->find('theme_name' ) +
				.pref('sys:path_delimiter') +
				.pref( 'sys:language_path' ) +
				$arm_data->find('theme_name' ) +
				'.'
			)
		}

		private load_addon( a::array ) => {

			local( 'n' = #a( 1 )->ascopy )
			#n->removetrailing( .pref('sys:path_delimiter') )
			.'addon_name' = #n->split( .pref('sys:path_delimiter') )->last

			if( #a->size == 0 ) => {
				fail( -1, .lang( 'sys.controller_error', (: '@cont' = .'addon_name' )))
				return
			}

			local('file_found' = TRUE)
			protect => {
				handle_failure => { #file_found = FALSE }
				library_once(
					#a( 1 ) +
					.pref( 'sys:controller_path' ) +
					.'addon_name' +
					.pref( 'sys:file_suffix' )
				)
			}
			
			if( NOT #file_found ) => {
				#a->remove( 1 )
				.load_addon( #a )
			}

			$arm_data->find( 'addon_root' ) = #a( 1 )
		}

		private load_addon_preferences() => {
			include(
				$arm_data->find( 'addon_root' ) +
				.pref( 'sys:preference_path' ) +
				.'addon_name' +
				.pref( 'sys:preference_suffix' ) +
				.pref( 'sys:file_suffix' )
			)
		}

		private load_addon_language() => {
			.load_language_file( 
				$arm_data->find( 'addon_root' ) +
				.pref( 'sys:language_path' ) +
				.'addon_name' +
				'.'
			)
		}

	}


?>
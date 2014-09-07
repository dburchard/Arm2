<?lassoscript

	define Arm => type {
		parent Arm_PublicController

		data addon_name				=	NULL

		public oncreate() => {

			.load_default_preferences()
			.load_default_language()

			inline(
					web_request->params,
					.pref( 'sys:database' ), // .pref( -Development, 'sys:database' )
					-nothing) => {

				.load_theme()
				.load_theme_preferences()
				.load_theme_language()

				/*
				local( 'path' = .pref('sys:addon_path')->ascopy->asarray )
				#path->foreach => {
					#1->append( .path(1) + .pref('sys:path_delimiter') )
				}
				#path->insert( .pref( 'sys:default_addon' ) )
				.load_addon( #path )

				.run_controller( .'addon_name' )
				*/
				return arm_addon( .path( 1 )->asstring, (: ))
			}

		}

		private accepted_language() => {
			local( 'x' = FALSE)
			local( 's' = '')
			web_request->httpAcceptLanguage->split('')->foreach => {
				( string_isalpha( #1 ) OR #1 == '-' OR #1 == ',' ) AND NOT #x ? #s->append( #1 ) | #x = TRUE
			}
			#s->lowercase
			#s = #s->split(',')
			NOT #s->contains( .pref( 'sys:default_language' )) ? #s->insert( .pref( 'sys:default_language' ) )
			#s->reverse
			return #s
		}

		private load_language_file( filepath::string ) => {
			.accepted_language()->foreach => {
				local( 'p' = #filepath + #1 + .pref( 'sys:file_suffix' ))
				protect => {
					library_once( #p )
				}
			}
		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosycracy of BBEdit's code folding of 
			// Lasso script.
			library_once( 'preferences/' + 'default_p.lasso' )
		}

		private load_default_language() => {
			.load_language_file( .pref( 'sys:language_path' ))
		}

		private load_theme() => {
			$arm_data->insert( 'theme_name' = .pref( 'sys:default_theme' ))
		}

		private load_theme_preferences() => {
			library_once(
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

		/*
		private load_addon( a::array ) => {

			if( #a->size == 0 ) => {
				fail( -1, .lang( 'sys.controller_error', (: '@cont' = .'addon_name' )))
				return
			}

			local( 'n' = #a( 1 )->ascopy )
			#n->removetrailing( .pref('sys:path_delimiter') )
			.'addon_name' = #n->split( .pref('sys:path_delimiter') )->last

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

			.load_addon_preferences()
			.load_addon_language()
		}

		private load_addon_preferences() => {
			library_once(
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
		*/

	}

?>
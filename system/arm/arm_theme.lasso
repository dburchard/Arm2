<?lassoscript

	/**!
	 * provides the following signatures for use in creating 
	 * theme and view files.
	 * 
	 *     arm_theme( -baseurl::boolean )::string
	 *     arm_theme( -favicon::string, -rel::string, -sizes::string = '', -type::string = '' )::string
	 *     arm_theme( -css::string, -group::string = '_any' )::void
	 *     arm_theme( -css::boolean )::string
	 *     arm_theme( -js::string, -group::string = '_any' )::void
	 *     arm_theme( -js::boolean )::string
	 *     arm_theme( -image::string, -alt::string = '' )::string
	 * 
	 */
	define Arm_Theme( ... ) => {

		local( 'args' = MAP )
		local( 'signature' = STRING )
		local( 'catch' = FALSE )
		local( 'baseurl' = $arm_data->find( 'theme_baseurl' ))

		// convert the #rest argument to a map, capture the signature, 
		// and trap for any non-keyword parameters.
		#rest->foreach => {
			local( 'arg' = #1 )
			if( #arg->type == ::keyword ) => {
				#signature->append( '-' + #arg->name + '::' + #arg->value->type->asstring )
			else
				#signature->append( #arg->asstring + '::' + #arg->type->asstring )
				#catch = TRUE
			}
			#signature->append( ', ' )
			#args->insert( #1->name = #1->value )

		}
		#signature->removetrailing( ', ' )
		#catch ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))

		// process -baseurl::boolean form of tag
		if( #args->find( 'baseurl' ) === TRUE ) => {
			#args->removeall( 'baseurl' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			return #baseurl
		}

		// process -favicon::string form of tag
		if( #args->find( 'favicon' )->type === STRING->type ) => {
			local( 'out' = '<link' )
			#args->find( 'rel' )->type === STRING->type ? #out->append( ' rel="' + #args->find( 'rel' ) + '"' ); #args->removeall( 'rel' )
			#args->find( 'favicon' )->type === STRING->type ? #out->append( ' href="' + #baseurl + arm_pref( 'sys:image_path' ) + #args->find( 'favicon' ) + '"' ); #args->removeall( 'favicon' )
			#args->find( 'sizes' )->type === STRING->type ? #out->append( ' sizes="' + #args->find( 'sizes' ) + '"' ); #args->removeall( 'sizes' )
			#args->find( 'type' )->type === STRING->type ? #out->append( ' type="' + #args->find( 'type' ) + '"' ); #args->removeall( 'type' )
			#out->append( ' />' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			return #out
		}

		// process -css::string form of tag
		if( #args->find( 'css' )->type === STRING->type ) => {
			local( 'file' = '' )
			local( 'group' = '_any' )
			#args->find( 'css' )->type === STRING->type ? #file = #args->find( 'css' ); #args->removeall( 'css' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			$arm_data->find( 'theme_css' )->find( #group )->type != array->type ? $arm_data->find( 'theme_css' )->insert( #group = array )
			$arm_data->find( 'theme_css' )->find( #group )->insert( #baseurl + arm_pref( 'sys:css_path' ) + #file, 1 )
			return
		}

		// process -css::boolean form of tag
		if( #args->find( 'css' ) === TRUE ) => {
			local( 'group' = '_any' )
			#args->removeall( 'css' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			local( 'css' = $arm_data->find( 'theme_css' )->find( #group ))
			#css->type != array->type ? return ''
			local( 'out' = array )
			#css->foreach => {
				#out->insert( '<link rel="stylesheet" type="text/css" href="' + #1 + '" />')
			}
			return #out->join( '\n' )
		}

		// process -js::string form of tag
		if( #args->find( 'js' )->type === STRING->type ) => {
			local( 'file' = '' )
			local( 'group' = '_any' )
			#args->find( 'js' )->type === STRING->type ? #file = #args->find( 'js' ); #args->removeall( 'js' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			$arm_data->find( 'theme_js' )->find( #group )->type != array->type ? $arm_data->find( 'theme_js' )->insert( #group = array )
			$arm_data->find( 'theme_js' )->find( #group )->insert( #baseurl + arm_pref( 'sys:js_path' ) + #file, 1 )
			return
		}

		// process -js::boolean form of tag
		if( #args->find( 'js' ) === TRUE ) => {
			local( 'group' = '_any' )
			#args->removeall( 'js' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			local( 'js' = $arm_data->find( 'theme_js' )->find( #group ))
			#css->type != array->type ? return ''
			local( 'out' = array )
			#js->foreach => {
				#out->insert( '<script type="text/javascript" src="' + #1 + '"></script>')
			}
			return #out->join( '\n' )
		}


		// process -image::string form of tag
		if( #args->find( 'image' )->type === STRING->type ) => {
			local( 'out' = '<img' )
			#args->find( 'image' )->type === STRING->type ? #out->append( ' src="' + #baseurl + arm_pref( 'sys:image_path' ) + #args->find( 'image' ) + '"' ); #args->removeall( 'image' )
			#args->find( 'alt' )->type === STRING->type ? #out->append( ' alt="' + #args->find( 'alt' ) + '"' ); #args->removeall( 'alt' )
			#out->append( ' />' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))
			return #out
		}

		// trap for no valid parameter.
		fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_theme( ' + #signature + ' )' )))

	}

	if( NOT lasso_tagexists( 'arm_themeloader' )) => {
		define Arm_ThemeLoader => trait {

			/**!
			 * loads the default theme name into the $arm_data variable.
			 * 
			 * the theme name is set in the default preferences, but
			 * can be overridden in the registry.
			 */
			provide load_theme( theme_name::string ) => {
				$arm_data->insert( 'theme_name' = #theme_name )
				.load_theme_preferences()
				.load_theme_language()
				arm_pref( 'sys:default_theme' = #theme_name )
			}
		
			/**!
			 * if present, loads the theme preference file.
			 */
			provide load_theme_preferences() => {
				local( 'filepath' =
					arm_pref( 'sys:theme_path' ) +
					$arm_data->find( 'theme_name')  +
					arm_pref('sys:path_delimiter') +
					arm_pref( 'sys:preference_path' ) +
					$arm_data->find('theme_name' ) +
					arm_pref( 'sys:preference_suffix' ) +
					arm_pref( 'sys:file_suffix' )
				)
				local( 'success' = FALSE )
				protect => {
					include_raw( #filepath )
					#success = TRUE
				}
				#success ? library_once( #filepath )
			}

			/**!
			 * if present, loads the theme language file(s).
			 */
			provide load_theme_language() => {
				arm_lang_loadfile(
					arm_pref( 'sys:theme_path' ) +
					$arm_data->find('theme_name' ) +
					arm_pref('sys:path_delimiter') +
					arm_pref( 'sys:language_path' ) +
					$arm_data->find('theme_name' ) +
					'.'
				)
			}
		}
	}

	/**!
	 * provides a means of including a partial -- meaning a portion 
	 * of a template -- without knowing the place of the addon or 
	 * theme in the file structure.
	 */
	define Arm_Partial( name::string ) => {

		return include( $arm_data->find( 'partial_root' ) + #name + arm_pref( 'sys:file_suffix' ))

	}

?>
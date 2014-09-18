<?lassoscript

	define Arm => type {
		parent Arm_PublicController

		data addon_name				=	NULL

		public oncreate() => {

			.load_default_preferences()
			.load_default_language()
			arm_path_set()

			inline(
					web_request->params,
					arm_pref( 'sys:database' ),
					-nothing) => {

				.load_registry()

				.load_theme()
				.load_theme_preferences()
				.load_theme_language()

				return arm_addon( arm_path( 1 )->asstring )
			}

		}

		/**!
		 * loads the default preference file.
		 */
		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosyncrasy of BBEdit's code folding of 
			// Lasso script.
			library_once( 'preferences/' + 'default_p.lasso' )
		}

		/**!
		 * loads the default language file(s).
		 */
		private load_default_language() => {
			arm_lang_loadfile( arm_pref( 'sys:language_path' ))
		}

		/**!
		 * attempts to load the registry file.
		 * 
		 * if the file loads without error, the registry type is
		 * invoked, and it's load method run.
		 * 
		 * the registry filepath and type name are set in the 
		 * default preferences file.
		 */
		private load_registry() => {
			local( 'registry' = VOID )
			local( 'file_loaded' = FALSE )
			protect => {
				library_once( arm_pref( 'sys:registry_filepath' ))
				#file_loaded = TRUE
			}
			#file_loaded ? #registry = escape_tag( arm_pref( 'sys:registry_typename' ))->invoke
			#registry->hasmethod( ::load ) ? #registry->load
		}

		/**!
		 * loads the default theme name into the $arm_data variable.
		 * 
		 * the theme name is set in the default preferences, but
		 * can be overridden in the registry.
		 */
		private load_theme() => {
			$arm_data->insert( 'theme_name' = arm_pref( 'sys:default_theme' ))
		}
		
		/**!
		 * if present, loads the theme preference file.
		 */
		private load_theme_preferences() => {
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
		private load_theme_language() => {
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

?>
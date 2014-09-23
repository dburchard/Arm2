<?lassoscript

	define Arm_Thread => trait {

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

?>
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
					.pref( 'sys:database' ),
					-nothing) => {

				.load_theme()
				.load_theme_preferences()
				.load_theme_language()

				return arm_addon( arm_path( 1 )->asstring )
			}

		}

		private load_default_preferences() => {
			// The string passed to the [include] tag is broken, to 
			// overcome an idiosyncrasy of BBEdit's code folding of 
			// Lasso script.
			library_once( 'preferences/' + 'default_p.lasso' )
		}

		private load_default_language() => {
			arm_lang_loadfile( .pref( 'sys:language_path' ))
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
			arm_lang_loadfile(
				.pref( 'sys:theme_path' ) +
				$arm_data->find('theme_name' ) +
				.pref('sys:path_delimiter') +
				.pref( 'sys:language_path' ) +
				$arm_data->find('theme_name' ) +
				'.'
			)
		}

	}

?>
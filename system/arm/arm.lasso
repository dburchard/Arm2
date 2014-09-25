<?lassoscript

	define Arm => type {
		parent Arm_PublicController

		trait {
			import arm_themeloader
		}

		data addon_name				=	NULL

		/**!
		 * loads preferenses and language, processes request,
		 * returns arm_addon
		 */
		public oncreate() => {

			.load_default_preferences()
			.load_default_language()
			arm_path_set()

			// we're surrounding all subsequent processing with
			// an inline, so that subsequent inlines don't need
			// to specify the host or database parameters.
			inline(
					web_request->params,
					arm_pref( 'sys:database' ),
					-nothing) => {

				.load_registry()

				.load_theme( arm_pref( 'sys:default_theme' ))

				.load_library( 'arm_auth' )
				local( 'auth' = VOID )
				protect => {
					#auth = arm_auth
				}

				if( #auth->isa( ::void ) OR #auth->is_authorized( arm_path )) => {

					return arm_addon( arm_path( 1 )->asstring )

				else

					#auth->login_screen

				}

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
			#file_loaded ? $arm_data->find( 'registry' ) = escape_tag( arm_pref( 'sys:registry_typename' ))->invoke
			$arm_data->find( 'registry' )->hasmethod( ::load ) ? $arm_data->find( 'registry' )->load
		}

	}

?>
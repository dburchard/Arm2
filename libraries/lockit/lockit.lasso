<?lassoscript

	define LockIt => type {

		public is_authorized( ticket::string ) => {

			return TRUE

		}

		public login_screen() => {

			return include( 'libraries/lockit/loginscreen.lasso' )

		}

	}

?>
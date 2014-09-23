<?lassoscript

	define Arm_Registry => type {

		/**!
		 * an optional member. if present, is called on 
		 * the initial load of the registry object, at 
		 * the beginning of each client request.
		 */
		public load() => {
		}

		/**!
		 * required member. accepts a controller object, 
		 * and returns true or false.
		 */
		public is_registered( addon ) => {
			return TRUE
		}

	}


?>
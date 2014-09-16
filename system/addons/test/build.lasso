<?lassoscript

	// This file contains a Type definistion that is called whenever
	// adding the addon to, or removing the addon from, the addon
	// registry. The type's self defined version number is also 
	// compared to the version number in the registry on every call
	// to the controller. If the current version number is higher than
	// that in the registry, the required upgrade method is called. If
	// the current version number is lower than that in the registry,
	// an error is thrown.

	define Test_Build => type {
		parent Arm_Build

		/* 
		 * info() is a required method inside this type.
		 * returns an array with basic information about your module.
		 */
		protected info() => {
		}

		/* 
		 * install() is a required method inside this type
		 * runs the queries for your database setup.
		 */
		protected install() => {
			return TRUE;
		}

		/* 
		 * uninstall() is a required method inside this type.
		 * cleans up your database, and returns true if successful.
		 */
		protected uninstall() => {
			return TRUE;
		}

		/* 
		 * help() is a required method inside this type.
		 * returns an html markup string with help for your addon.
		 */
		protected help() => {
			// Return a string containing help info
			// You could include a file and return it here.
			return 'No documentation has been added for this module.<br />Contact the <a href="mailto:developer@example.com">addon developer</a> for assistance.';
		}

		/* 
		 * upgrade() is an optional method inside this type
		 * conditionally makes changes to your database, and
		 * returns true if successful.
		 */
		protected upgrade( old_version::integer ) => {
			// Your Upgrade Logic
			return TRUE;
		}

	}

?>
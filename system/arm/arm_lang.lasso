<?lassoscript

	define arm_lang( key::string ) => {
		local( 'o' = $arm_data->find('language')->find(#key) )
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail_if( #o->type == void->type, -1, 'Language key "' + #key + '" not found.' )
		return #o->ascopy
	}

	define arm_lang( content::pair ) => {
		$arm_data->find('language')->insert( #content )
	}

	define arm_lang( key::string, params::staticarray ) => {
		local( 'lang' = arm_lang( #key ))
		#params->foreach => {
			#lang->replace( #1->name, #1->value )
		}
		return #lang
	}

?>
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

	define arm_lang_loadfile( filepath::string ) => {
		arm_lang_accepted()->foreach => {
			local( 'p' = #filepath + #1 + arm_pref( 'sys:file_suffix' ))
			protect => {
				library_once( #p )
			}
		}
	}

	define arm_lang_accepted()::array => {
		local( 'x' = FALSE)
		local( 's' = '')
		web_request->httpAcceptLanguage->split('')->foreach => {
			( string_isalpha( #1 ) OR #1 == '-' OR #1 == ',' ) AND NOT #x ? #s->append( #1 ) | #x = TRUE
		}
		#s->lowercase
		#s = #s->split(',')
		NOT #s->contains( arm_pref( 'sys:default_language' )) ? #s->insert( arm_pref( 'sys:default_language' ) )
		#s->reverse
		return #s
	}

?>
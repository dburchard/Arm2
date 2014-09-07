<?lassoscript

	define arm_pref( ... ) => {
		local( environment = '' )
		local( key = '' )
		local( package = PAIR )
		#rest->foreach => {
			local( 'param' = #1 )
			#param->isa( ::keyword ) ? #environment = #param->name->asstring
			#param->isa( ::string ) ? #key = #param
			#param->isa( ::pair ) ? #package = #param
		}
		#environment->lowercase
		#key->size > 0 ? return arm_pref_get( #key, #environment )
		#package->name->size > 0 ? return arm_pref_set( #package, #environment )
	}

	define arm_pref_get( key::string, environment::string ) => {
		if( #environment->size > 0 ) => {
			return arm_pref_getenv( #key, #environment )
		}
		return arm_pref_getany( #key )
	}

	define arm_pref_getenv( key::string, environment::string ) => {
		local( 'out' = $arm_data->find('preferences')->find( #key + ' @ ' + #environment ) )
		#out->type != VOID->type ? return #out->ascopydeep
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail( -1, 'Preference key "' + #key + '", for environment "' + #environment + '", not found.' )
	}

	define arm_pref_getany( key::string ) => {
		local( 'out' = $arm_data->find('preferences')->find( #key + ' @ ' + action_param( 'arm_env' )))
		#out->type != VOID->type ? return #out
		#out = $arm_data->find('preferences')->find( #key + ' @ any')
		#out->type != VOID->type ? return #out->ascopydeep
		// This error message is hard coded, because utilizing
		// the default language-file could cause an error, or
		// an infinite loop, at this point in the code.
		fail( -1, 'Preference key "' + #key + '" not found.' )
	}

	define arm_pref_set( package::pair, environment::string ) => {
		if( #environment->size > 0 ) => {
			arm_pref_setenv( #package, #environment )
			return VOID
		}
		arm_pref_setany( #package )
		return VOID
	}

	define arm_pref_setenv( package::pair, environment::string ) => {
		$arm_data->find('preferences')->insert( #package->name + ' @ ' + #environment = #package->value )
	}

	define arm_pref_setany( package::pair ) => {
		$arm_data->find('preferences')->insert( #package->name + ' @ any' = #package->value )
	}

?>
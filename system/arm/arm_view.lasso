<?lassoscript

	define Arm_PluginView => type {

		data protected controller	=	NULL
		data protected variables	=	ARRAY
		data protected file_name	=	STRING

		public set_controller( c::any ) => {
			.'controller' = #c
		}

		public set( n::string, v::any ) => {
			.'variables'->insert( pair( #n = #v ))
			return self
		}

		public metadata( ... ) => {
			local( 'args' = map )
			local( 'signature' = string )
			local( 'catch' = FALSE )

			// capture the signature, and trap for any non-keyword parameters.
			#rest->foreach => {
				local( 'arg' = #1 )
				if( #arg->type == ::keyword ) => {
					#signature->append( '-' + #arg->name + '::' + #arg->value->type->asstring )
				else
					#signature->append( #arg->asstring + '::' + #arg->type->asstring )
					#catch = TRUE
				}
				#signature->append( ', ' )
			}
			#signature->removetrailing( ', ' )
			#catch ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = self->type->asstring + '->' + 'metadata( ' + #signature + ' )' )))

			// Convert the #rest argument to a map, and trap for non-string values.
			#rest->foreach => {
				NOT #1->value->isa( ::string ) ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = self->type->asstring + '->' + 'metadata( ' + #signature + ' )' )))
				#args->insert( #1->name = #1->value )
			}

			// Store meta-tags, and trap for any extraneous parameters.
			if( #args->contains( 'content' )) => {
				local( 'tag' = map( 'tag' = 'meta', 'content' = #args->find( 'content' ))); #args->removeall( 'content' )
				#args->keys->contains( 'name' ) ? #tag->insert( 'name' = #args->find( 'name' )); #args->removeall( 'name' )
				#args->keys->contains( 'httpequiv' ) ? #tag->insert( 'http-equiv' = #args->find( 'httpequiv' )); #args->removeall( 'httpequiv' )
				#args->keys->contains( 'itemprop' ) ? #tag->insert( 'itemprop' = #args->find( 'itemprop' )); #args->removeall( 'itemprop' )
				#args->keys->contains( 'property' ) ? #tag->insert( 'property' = #args->find( 'property' )); #args->removeall( 'property' )
				#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = self->type->asstring + '->' + 'metadata( ' + #signature + ' )' )))
				$arm_data->find( 'view_metadata' )->insert( #tag )
				return self
			}

			// Store link-tags, and trap for any extraneous parameters.
			if( #args->contains( 'rel' )) => {
				local( 'tag' = map( 'tag' = 'link', 'rel' = #args->find( 'rel' ))); #args->removeall( 'rel' )
				#args->keys->contains( 'href' ) ? #tag->insert( 'href' = #args->find( 'href' )); #args->removeall( 'href' )
				#args->keys->contains( 'type' ) ? #tag->insert( 'type' = #args->find( 'type' )); #args->removeall( 'type' )
				#args->keys->contains( 'media' ) ? #tag->insert( 'media' = #args->find( 'media' )); #args->removeall( 'media' )
				#args->keys->contains( 'title' ) ? #tag->insert( 'title' = #args->find( 'title' )); #args->removeall( 'title' )
				#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = self->type->asstring + '->' + 'metadata( ' + #signature + ' )' )))
				$arm_data->find( 'view_metadata' )->insert( #tag )
				return self
			}

			// Trap for no valid parameter.
			fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = self->type->asstring + '->' + 'metadata( ' + #signature + ' )' )))

			// Return self, just in case a developer wants to suppress errors
			return self
		}

		public metadata( key::string, value::string, -link::boolean = FALSE ) => {
			if( #link ) => {
				return .metadata( -rel=#key, -href=#value )
			else
				return .metadata( -name=#key, -content=#value )
			}
		}

		public css( file::string, -group::string = '_any' ) => {
			$arm_data->find( 'view_css' )->find( #group )->type != array->type ? $arm_data->find( 'view_css' )->insert( #group = array )
			$arm_data->find( 'view_css' )->find( #group )->insert( .'controller'->root_directory + arm_pref( 'sys:css_path' ) + #file )
			return self
		}

		public js( file::string, -group::string = '_any' ) => {
			$arm_data->find( 'view_js' )->find( #group )->type != array->type ? $arm_data->find( 'view_js' )->insert( #group = array )
			$arm_data->find( 'view_js' )->find( #group )->insert( .'controller'->root_directory + arm_pref( 'sys:js_path' ) + #file )
			return self
		}

		public area( slug::string, package::any ) => {
			$arm_data->find( 'view_areas' )->insert( #slug = #package )
			return self
		}

		public build( t::string ) => {
			.'file_name' = #t
			.dump( TRUE )
			return self
		}

		public build() => {
			.dump( TRUE )
			return self
		}

		protected dump( notheme::boolean = FALSE ) => {

			.'variables'->foreach => {
				var(#1->name = #1->value)
			}

			$arm_data->insert( 'theme_baseurl' = arm_pref( 'sys:theme_path' ) + arm_pref( 'sys:default_theme' ) + arm_pref('sys:path_delimiter') )
			$arm_data->insert( 'addon_baseurl' = .'controller'->root_directory )

			$arm_data->insert( 'view_body' = include(

				.'controller'->root_directory + 
				.'controller'->pref('sys:view_path') + 
				.'file_name' + 
				.'controller'->pref( 'sys:file_suffix')
			))



			if( #notheme ) => {
				.'controller'->buffer( $arm_data->find( 'view_body' ))
			else
				.'controller'->buffer( include(
	
					.'controller'->pref('sys:theme_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref('sys:path_delimiter') + 
					.'controller'->pref('sys:template_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref( 'sys:file_suffix')
	
				))
			}
		}
	}

	define Arm_AdminView => type {
		parent Arm_PluginView
	}

	define Arm_View => type {
		parent Arm_PluginView

		trait {
			import arm_theme
		}

		public title( v::string ) => {
			$arm_data->insert( 'view_title' = #v )
			return self
		}

		public theme( theme_name::string ) => {
			.load_theme( #theme_name )
			return self
		}

		public build( t::string ) => {
			.'file_name' = #t
			.dump
			return self
		}

		public build() => {
			.dump
			return self
		}
	}

?>
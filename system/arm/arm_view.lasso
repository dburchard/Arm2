<?lassoscript

	/**!
	 * provides the following signatures for use in creating 
	 * theme and view files.
	 * 
	 *     arm_view( -baseurl::boolean )::string
	 *     arm_view( -title::boolean )::string
	 *     arm_view( -metadata::boolean )::string
	 *     arm_view( -body::boolean )::string
	 *     arm_view( -area::string )::string
	 *     arm_view( -css::boolean, -group::string )::void
	 *     arm_view( -css::boolean )::string
	 *     arm_view( -js::boolean, -group::string )::void
	 *     arm_view( -js::boolean )::string
	 *     arm_view( -image::string, -alt::string = '' )::string
	 * 
	 *     arm_view( -section::string, -alt::string = '' )::string
	 *     arm_view( -shortcut::string, -alt::string = '' )::string
	 * 
	 */
	define Arm_View( ... ) => {

		local( 'args' = MAP )
		local( 'signature' = STRING )
		local( 'catch' = FALSE )
		local( 'baseurl' = $arm_data->find( 'addon_baseurl' ))

		// convert the #rest argument to a map, capture the signature, 
		// and trap for any non-keyword parameters.
		if( #rest->type == STATICARRAY->type) => {
			#rest->foreach => {
				local( 'arg' = #1 )
				if( #arg->type == ::keyword ) => {
					#signature->append( '-' + #arg->name + '::' + #arg->value->type->asstring )
				else
					#signature->append( #arg->asstring + '::' + #arg->type->asstring )
					#catch = TRUE
				}
				#signature->append( ', ' )
				#args->insert( #1->name = #1->value )
			}
		}
		#signature->removetrailing( ', ' )
		#catch ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))

		// process -baseurl::boolean form of tag
		if( #args->find( 'baseurl' ) === TRUE ) => {
			#args->removeall( 'baseurl' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return #baseurl
		}

		// process -title::boolean form of tag
		if( #args->find( 'title' ) === TRUE ) => {
			#args->removeall( 'title' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return $arm_data->find( 'view_title' )
		}

		// process -metadata::boolean form of tag
		if( #args->find( 'metadata' ) === TRUE ) => {
			#args->removeall( 'metadata' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			local( 'out' = array )
			$arm_data->find( 'view_metadata' )->foreach => {
				local( 'tag' = '' )
				#tag->append( '<' + #1->get( 'tag' ))
				#1->keys->contains( 'name' ) ? #tag->append( ' name="' + #1->get( 'name' ) + '"' )
				#1->keys->contains( 'rel' ) ? #tag->append( ' rel="' + #1->get( 'rel' ) + '"' )
				#1->keys->contains( 'http-equiv' ) ? #tag->append( ' http-equiv="' + #1->get( 'http-equiv' ) + '"' )
				#1->keys->contains( 'itemprop' ) ? #tag->append( ' itemprop="' + #1->get( 'itemprop' ) + '"' )
				#1->keys->contains( 'property' ) ? #tag->append( ' property="' + #1->get( 'property' ) + '"' )
				#1->keys->contains( 'content' ) ? #tag->append( ' content="' + #1->get( 'content' ) + '"' )
				#1->keys->contains( 'href' ) ? #tag->append( ' href="' + #1->get( 'href' ) + '"' )
				#1->keys->contains( 'type' ) ? #tag->append( ' type="' + #1->get( 'type' ) + '"' )
				#1->keys->contains( 'media' ) ? #tag->append( ' media="' + #1->get( 'media' ) + '"' )
				#1->keys->contains( 'title' ) ? #tag->append( ' title="' + #1->get( 'title' ) + '"' )
				#tag->append( ' />' )
				#out->insert( #tag )
			}
			return #out->join( '\n' )
		}

		// process -body::boolean form of tag
		if( #args->find( 'body' ) === TRUE ) => {
			#args->removeall( 'body' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return $arm_data->find( 'view_body' )
		}

		// process -area::string form of tag
		if( #args->find( 'area' )->type === STRING->type ) => {
			local( 'slug' = #args->find( 'area' )); #args->removeall( 'area' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return $arm_data->find( 'view_areas' )->find( #slug )->invoke
		}

		// process -css::string form of tag
		if( #args->find( 'css' )->type === STRING->type ) => {
			local( 'file' = '' )
			local( 'group' = '_any' )
			#args->find( 'css' )->type === STRING->type ? #file = #args->find( 'css' ); #args->removeall( 'css' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			$arm_data->find( 'view_css' )->find( #group )->type != array->type ? $arm_data->find( 'view_css' )->insert( #group = array )
			$arm_data->find( 'view_css' )->find( #group )->insert( #baseurl + arm_pref( 'sys:css_path' ) + #file, 1 )
			return
		}

		// process -css::boolean form of tag
		if( #args->find( 'css' ) === TRUE ) => {
			local( 'group' = '_any' )
			#args->removeall( 'css' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			local( 'css' = $arm_data->find( 'view_css' )->find( #group ))
			#css->type != array->type ? return ''
			local( 'out' = array )
			#css->foreach => {
				#out->insert( '<link rel="stylesheet" type="text/css" href="' + #1 + '" />')
			}
			return #out->join( '\n' )
		}

		// process -js::string form of tag
		if( #args->find( 'js' )->type === STRING->type ) => {
			local( 'file' = '' )
			local( 'group' = '_any' )
			#args->find( 'js' )->type === STRING->type ? #file = #args->find( 'js' ); #args->removeall( 'js' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			$arm_data->find( 'view_js' )->find( #group )->type != array->type ? $arm_data->find( 'view_js' )->insert( #group = array )
			$arm_data->find( 'view_js' )->find( #group )->insert( #baseurl + arm_pref( 'sys:js_path' ) + #file, 1 )
			return
		}

		// process -js::boolean form of tag
		if( #args->find( 'js' ) === TRUE ) => {
			local( 'group' = '_any' )
			#args->removeall( 'js' )
			#args->find( 'group' )->type === STRING->type ? #group = #args->find( 'group' ); #args->removeall( 'group' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			local( 'js' = $arm_data->find( 'view_js' )->find( #group ))
			#js->type != array->type ? return ''
			local( 'out' = array )
			#js->foreach => {
				#out->insert( '<script type="text/javascript" src="' + #1 + '"></script>')
			}
			return #out->join( '\n' )
		}

		// process -image::string form of tag
		if( #args->find( 'image' )->type === STRING->type ) => {
			local( 'out' = '<img' )
			#args->find( 'image' )->type === STRING->type ? #out->append( ' src="' + #baseurl + arm_pref( 'sys:image_path' ) + #args->find( 'image' ) + '"' ); #args->removeall( 'image' )
			#args->find( 'alt' )->type === STRING->type ? #out->append( ' alt="' + #args->find( 'alt' ) + '"' ); #args->removeall( 'alt' )
			#out->append( ' />' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return #out
		}

		// process -admin_title::boolean form of tag
		if( #args->find( 'admin_title' ) === TRUE ) => {
			#args->removeall( 'admin_title' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return $arm_data->find( 'view_admintitle' )
		}

		// process -admin_description::boolean form of tag
		if( #args->find( 'admin_description' ) === TRUE ) => {
			#args->removeall( 'admin_description' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			return $arm_data->find( 'view_admindescription' )
		}

		// process -admin_sections::boolean form of tag
		if( #args->find( 'admin_sections' ) === TRUE ) => {
			#args->removeall( 'admin_sections' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			local( 'out' = '<ol>' )
			local( 'sections' = $arm_data->find( 'view_adminsections' ))
			#sections->type != array->type ? return ''
			#sections->foreach => {
				local( 's' = #1 )
				local( 'o' = STRING )
				#o->append( '<li><a href="' + #s->find( 'slug' ) + '">' )
				#o->append( #s->find( 'name' ))
				#o->append( '</a></li>' )
				#out->append( #o )
			}
			#out->append( '</ol>' )
			return #out
		}

		// process -admin_shortcuts::boolean form of tag
		/*
		$arm_data->find( 'view_adminshortcuts' )->insert( map( 'name' = #name, 'slug' = #slug, 'class' = #class ))
		<ol id="shortcuts">
			<li><a class="help" href="#">Help</a></li>
			<li><a class="create" href="#">Create</a></li>
		</ol>
		*/
		if( #args->find( 'admin_shortcuts' ) === TRUE ) => {
			#args->removeall( 'admin_shortcuts' )
			#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))
			local( 'out' = '<ol id="shortcuts">' )
			local( 'sections' = $arm_data->find( 'view_adminshortcuts' ))
			#sections->type != array->type ? return ''
			#sections->foreach => {
				local( 's' = #1 )
				local( 'o' = STRING )
				#o->append( '<li><a' )
				#s->find( 'class' ) == 'create' ? #o->append( ' class="create"' )
				#s->find( 'class' ) == 'read' ? #o->append( ' class="read"' )
				#s->find( 'class' ) == 'update' ? #o->append( ' class="update"' )
				#s->find( 'class' ) == 'delete' ? #o->append( ' class="delete"' )
				#o->append( ' href="' + #s->find( 'slug' ) + '"' )
				#o->append( '>' )
				#o->append( #s->find( 'name' ))
				#o->append( '</a></li>' )
				#out->append( #o )
			}
			#out->append( '</ol>' )
			return #out
		}

		// trap for no valid parameter.
		#args->size > 0 ? fail( -1, arm_lang( 'sys.signature_error', (: '@signature' = 'arm_view( ' + #signature + ' )' )))

		return Arm_ControllerView

	}

	define Arm_PluginView => type {

		trait {
			import arm_themeloader
		}

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

		public theme( theme_name::string ) => {
			.load_theme( #theme_name )
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

		public build( template::string ) => {
			.'file_name' = #template
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

			local( 'view_path' = .'controller'->root_directory + 
				.'controller'->pref('sys:view_path') + 
				.'file_name' + 
				.'controller'->pref( 'sys:file_suffix')
			)
			$arm_data->insert( 'partial_root' = .'controller'->root_directory + arm_pref( 'sys:view_path' ) + arm_pref( 'sys:partial_path' ) )
			$arm_data->insert( 'view_body' = include( #view_path ))



			if( #notheme ) => {
				.'controller'->buffer( $arm_data->find( 'view_body' ))
			else

				local( 'theme_path' = .'controller'->pref('sys:theme_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref('sys:path_delimiter') + 
					.'controller'->pref('sys:template_path') + 
					$arm_data->find('theme_name') + 
					.'controller'->pref( 'sys:file_suffix')
				)
				$arm_data->insert( 'partial_root' = .'controller'->pref('sys:theme_path') + $arm_data->find('theme_name') + arm_pref('sys:path_delimiter' ) + arm_pref( 'sys:template_path' ) + arm_pref( 'sys:partial_path' ))
				.'controller'->buffer( include( #theme_path ))
			}
		}
	}

	define Arm_AdminView => type {
		parent Arm_PluginView

		public title( package::string ) => {
			$arm_data->insert( 'view_admintitle' = #package )
			return self
		}

		public description( package::string ) => {
			$arm_data->insert( 'view_admindescription' = #package )
			return self
		}

		public shortcut( name::string, slug::string, class::string = '' ) => {
			local( 'path' = #slug )
			$arm_data->find( 'view_adminshortcuts' )->type != array->type ? $arm_data->insert( 'view_adminshortcuts' = array )
			$arm_data->find( 'view_adminshortcuts' )->insert( map( 'name' = #name, 'slug' = arm_path( 1 ) + arm_pref('sys:path_delimiter' ) + arm_path( 2 ) + arm_pref('sys:path_delimiter' ) + #path, 'class' = #class ))
			return self
		}

		public section( name::string, slug::string, class::string = '' ) => {
			local( 'path' = #slug )
			#path->removeleading( arm_pref('sys:path_delimiter' ))
			$arm_data->find( 'view_adminsections' )->type != array->type ? $arm_data->insert( 'view_adminsections' = array )
			$arm_data->find( 'view_adminsections' )->insert( map( 'name' = #name, 'slug' = arm_path( 1 ) + arm_pref('sys:path_delimiter' ) + arm_path( 2 ) + arm_pref('sys:path_delimiter' ) + #path, 'class' = #class ))
			return self
		}
	}

	define Arm_ControllerView => type {
		parent Arm_PluginView

		public title( package::string ) => {
			$arm_data->insert( 'view_title' = #package )
			return self
		}

		public build( template::string ) => {
			.'file_name' = #template
			.dump
			return self
		}

		public build() => {
			.dump
			return self
		}
	}

?>
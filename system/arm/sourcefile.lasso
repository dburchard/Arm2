<?lassoscript

	define sourcefile->view_title() => {
		return $arm_data->find( 'view_title' )
	}

	define sourcefile->view_css( group::string ) => {
		local( 'css' = $arm_data->find( 'view_css' )->find( #group ))
		#css->type != array->type ? return ''
		local( 'out' = array )
		#css->foreach => {
			#out->insert( '<link rel="stylesheet" type="text/css" href="' + #1 + '" />')
		}
		return #out->join( '\n' )
	}

	define sourcefile->view_css() => {
		return .view_css( '_any')
	}

	define sourcefile->view_js( group::string ) => {
		local( 'js' = $arm_data->find( 'view_js' )->find( #group ))
		#js->type != array->type ? return ''
		local( 'out' = array )
		#js->foreach => {
			#out->insert( '<script type="text/javascript" src="' + #1 + '"></script>')
		}
		return #out->join( '\n' )
	}

	define sourcefile->view_js() => {
		return .view_js( '_any')
	}

	define sourcefile->view_metadata() => {
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

	define sourcefile->view_body() => {
		return $arm_data->find( 'view_body' )
	}

	define sourcefile->view_area( slug::string ) => {
		return $arm_data->find( 'view_areas' )->find( #slug )->invoke
	}

	define sourcefile->partial( loc::string ) => {
		return include( include_path + arm_pref( 'sys:partial_path' ) + #loc + arm_pref( 'sys:file_suffix' ))
	}

	define sourcefile->addon_baseurl() => {
		return $arm_data->find( 'addon_baseurl' )
	}

	define sourcefile->addon_image( file::string, -alt::string = '' ) => {
		return '<img src="' + .addon_baseurl + arm_pref( 'sys:image_path' ) + #file + '" alt="' + #alt + '" />'
	}

	define sourcefile->theme_baseurl() => {
		return $arm_data->find( 'theme_baseurl' )
	}

	define sourcefile->theme_image( file::string, -alt::string = '' ) => {
		return '<img src="' + .theme_baseurl + arm_pref( 'sys:image_path' ) + #file + '" alt="' + #alt + '" />'
	}

	define sourcefile->theme_css( file::string, -group::string = '_any' ) => {
		$arm_data->find( 'view_css' )->find( #group )->type != array->type ? $arm_data->find( 'view_css' )->insert( #group = array )
		$arm_data->find( 'view_css' )->find( #group )->insert( .theme_baseurl + arm_pref( 'sys:css_path' ) + #file )
	}

	define sourcefile->theme_js( file::string, -group::string = '_any' ) => {
		$arm_data->find( 'view_js' )->find( #group )->type != array->type ? $arm_data->find( 'view_js' )->insert( #group = array )
		$arm_data->find( 'view_js' )->find( #group )->insert( .theme_baseurl + arm_pref( 'sys:js_path' ) + #file )
	}

?>
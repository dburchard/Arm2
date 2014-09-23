<?lassoscript

arm_pref( -DEVELOPMENT,	'sys:database'		=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))
arm_pref( -STAGING,		'sys:database'		=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))
arm_pref( -PRODUCTION,		'sys:database'	=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))

/*
	This preference establishes the language file(s) to load, 
	along with any languages identified by the client's 
	HTTP accept-language field.
*/
arm_pref('sys:default_language'			=	'en')

/*
	This preference sets the default theme to use.
*/
arm_pref('sys:default_theme'			=	'default')

/*
	This preference sets the addon to call, when no controller
	is specified in the client's web request.
*/
arm_pref('sys:default_addon'			=	'test')

/*
	Most likely, you will have no need to modify any of the 
	preferences below this comment.
	===========================================================
*/

arm_pref('sys:registry_filepath'		=	'system/addons/admin/extra/registry.lasso')
arm_pref('sys:registry_typename'		=	'arm_registry')

arm_pref('sys:path_argument'			=	'arm_path')
arm_pref('sys:environment_argument'		=	'arm_env')
arm_pref('sys:addon_path'				=	(: 'addons/','system/addons/' ))

arm_pref('sys:theme_path'				=	'themes/')
arm_pref('sys:model_path'				=	'models/')
arm_pref('sys:view_path'				=	'views/')
arm_pref('sys:controller_path'			=	'controllers/')
arm_pref('sys:template_path'			=	'templates/')
arm_pref('sys:partial_path'				=	'partials/')
arm_pref('sys:library_path'				=	'libraries/')
arm_pref('sys:preference_path'			=	'preferences/')
arm_pref('sys:language_path'			=	'language/')
arm_pref('sys:css_path'					=	'css/')
arm_pref('sys:js_path'					=	'js/')
arm_pref('sys:image_path'				=	'images/')
arm_pref('sys:path_delimiter'			=	'/')

arm_pref('sys:preference_suffix'		=	'_p')
arm_pref('sys:admin_filename'			=	'admin')
arm_pref('sys:build_filename'			=	'build')
arm_pref('sys:file_suffix'				=	'.lasso')

?>
EOF
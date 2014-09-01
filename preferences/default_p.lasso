<?lassoscript

arm_pref('sys:development_database'	=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))

arm_pref('sys:staging_database'	=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))

arm_pref('sys:production_database'	=	array(

	-Host				=	array(
		-Datasource		=	'MySQLDS',
		-Name			=	'127.0.0.1',
		-Username		=	'Root',
		-Password		=	''
	),
	-Database			=	'MyDatabase'

))

arm_pref('sys:path_argument'			=	'ap')
arm_pref('sys:default_language'			=	'en')

arm_pref('sys:default_theme'			=	'default')

arm_pref('sys:addon_path'				=	(: 'add-ons/','system/add-ons/' ))
arm_pref('sys:default_addon'			=	'system/add-ons/test/')

arm_pref('sys:theme_path'				=	'themes/')
arm_pref('sys:model_path'				=	'models/')
arm_pref('sys:view_path'				=	'views/')
arm_pref('sys:controller_path'			=	'controllers/')
arm_pref('sys:template_path'			=	'templates/')
arm_pref('sys:library_path'				=	'libraries/')
arm_pref('sys:preference_path'			=	'preferences/')
arm_pref('sys:language_path'			=	'language/')

arm_pref('sys:preference_suffix'		=	'_p')
arm_pref('sys:file_suffix'				=	'.lasso')

?>
EOF
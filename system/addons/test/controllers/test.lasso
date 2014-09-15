<?lassoscript

	define Test => type {
		parent Arm_PublicController

		public index() => {
			self->view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Index Page' )
			->build( 'test_v' )
		}

		public foo() => {
			self->view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Foo' )
			->build( 'test_v' )
		}

		public _not_found() => {
			self->view
			->set( 'out', .lang( 'test.404_welcome' ))
			->title( 'Error 404' )
			->build( 'test_v' )
		}

		public _plugin() => {
			self->plugin_view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Plugin with no parameters' )))
			->build( 'testplugin_v' )
		}

		public _plugin( myparam::string ) => {
			self->plugin_view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Plugin with the parameter: "' + #myparam + '"' )))
			->build( 'testplugin_v' )
		}

	}


?>
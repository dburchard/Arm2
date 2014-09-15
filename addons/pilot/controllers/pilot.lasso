<?lassoscript

	define Pilot => type {
		parent Arm_PublicController

		public oncreate() => {

			.load_library( 'mytag' )
			.load_model( 'pilot_m' )

		}

		public index() => {
			self->view
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Index' )) + ' ' + MYTAG)
			->area( 'myarea', arm_plugin('test', (: 'myarg')) )
			->area( 'navigation', arm_plugin('test') )
			->title( 'Pilot Page' )
			->build( 'pilot_v' )
		}

		public foo() => {
			self->view
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Foo' )))
			->title( 'Fooh' )
			->build( 'pilot_v' )
		}

		public _not_found() => {
			self->view
			->set( 'out', .lang( 'pilot.404_welcome' ))
			->title( 'Pilot Error 404' )
			->build( 'pilot_v' )
		}

		public _plugin() => {
		}

	}


?>
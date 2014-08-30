<?lassoscript

	define Pilot => type {
		parent Arm_PublicController

		public index() => {
			self->view
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Index Page' )
			->build( 'pilot_v' )
		}

		public not_found() => {
			self->view
			->set( 'out', .lang( 'pilot.404_welcome' ))
			->title( 'Error 404' )
			->build( 'pilot_v' )
		}

		public foo() => {
			self->view
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Foo' )))
			->title( 'Foo' )
			->build( 'pilot_v' )
		}

	}


?>
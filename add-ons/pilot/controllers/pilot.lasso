<?lassoscript

	define Pilot => type {
		parent Arm_PublicController

		public index() => {
			self->template
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Index Page' )
			->build( 'pilot_v' )
		}

		public not_found() => {
			self->template
			->set( 'out', .lang( 'pilot.404_welcome' ))
			->title( 'Error 404' )
			->build( 'pilot_v' )
		}

		public foo() => {
			self->template
			->set( 'out', .lang( 'pilot.method_welcome', (: '@mname' = 'Foo' )))
			->title( 'Foo' )
			->build( 'pilot_v' )
		}

	}


?>
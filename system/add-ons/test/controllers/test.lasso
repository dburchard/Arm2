<?lassoscript

	define Test => type {
		parent Arm_PublicController

		public index() => {
			self->view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Index Page' )
			->build( 'test_v' )
		}

		public not_found() => {
			self->view
			->set( 'out', .lang( 'test.404_welcome' ))
			->title( 'Error 404' )
			->build( 'test_v' )
		}

		public foo() => {
			self->view
			->set( 'out', .lang( 'test.method_welcome', (: '@mname' = 'Index' )))
			->title( 'Foo' )
			->build( 'test_v' )
		}

	}


?>
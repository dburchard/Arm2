<?lassoscript

	define Test_Controller => type {
		parent Arm_PublicController

		public index() => {
			self->template
			->set( 'out', 'This is the index() method in the Test controller.' )
			->build( 'default' )
		}

		public not_found() => {
			self->template
			->set( 'out', 'Wrong turn. Error 404.' )
			->build( 'default' )
		}

		public foo() => {
			self->template
			->set( 'out', 'This is the foo() method in the Test controller.' )
			->build( 'default' )
		}

	}


?>
<?lassoscript

	define Test_Admin => type {
		parent Arm_PublicController

		data public _registry_required		=		FALSE

		public index() => {
			self->admin_view
			->set( 'out', 'This is the test-admin controller, index method.' )
			->build( 'testadmin_v' )
		}

	}


?>
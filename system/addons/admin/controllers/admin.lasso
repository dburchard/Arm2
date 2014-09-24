<?lassoscript

	define Admin => type {
		parent Arm_PublicController

		data public _registry_required		=		FALSE

		public index() => {
			self->view
			->theme( 'arm_admin' )
			->title( 'Admin' )
			->area( 'add-on-admin', arm_admin( 'test' ))
			->build( 'admin_v' )
		}

		public _not_found() => {
			self->view
			->title( 'Admin 404' )
			->build( 'admin_v' )
		}

	}


?>
<?lassoscript

	define Admin => type {
		parent Arm_AdminController

		data public _registry_required		=		FALSE

		public index() => {
			self->view
			->theme( 'arm_admin' )
			->title( 'Admin' )
			->area( 'addon-admin', arm_admin( 'test' ))
			->build( 'admin_v' )
		}

		public _not_found() => {
			self->view
			->theme( 'arm_admin' )
			->title( 'Admin' )
			->area( 'addon-admin', arm_admin( arm_path( 2 )->asstring ))
			->build( 'admin_v' )
		}

	}


?>
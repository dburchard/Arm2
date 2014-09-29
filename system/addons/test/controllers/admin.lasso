<?lassoscript

	define Test_Admin => type {
		parent Arm_PublicController

		data public _registry_required		=		FALSE

		public oncreate() => {
			self->admin_view
			->title( 'Test' )
			->description( 'This is a description of the test add-on.' )
			->section( 'test', '/' )
			->section( 'sub-test', 'sub-test' )
		}

		public index() => {
			self->admin_view
			->shortcut( 'Create', 'create', 'create' )
			->shortcut( 'Delete', 'delete', 'delete' )
			->set( 'out', 'This is the test-admin controller, index method.' )
			->build( 'testadmin_v' )
		}

		public _not_found() => {
			self->admin_view
			->set( 'out', '404 Error. Sorry, this page isn\'t configured yet.' )
			->build( 'testadmin_v' )
		}

	}


?>
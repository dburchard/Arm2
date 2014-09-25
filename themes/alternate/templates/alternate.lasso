<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?= arm_view( -title ) ?></title>

	<?= arm_theme( -favicon='favicon.ico', -rel='icon', -sizes='16x16 32x32', -type='image/png' ) ?>

	<?= arm_theme( -css='theme_style.css' ) ?>

	<?= arm_theme( -js='theme_jquery.js', -group='footer' ) ?>

	<?= arm_theme( -baseurl ) ?>

	<?= arm_view( -baseurl ) ?>

	<?= arm_view( -metadata ) ?>

	<?= arm_view( -css ) ?>

</head>
<body>
	<div class="container">

		<?= arm_view( -image='foo.png', -alt='' ) ?>

		<?= arm_theme( -image='foo.png', -alt='Foo' ) ?>

		<?= arm_partial( 'head' ) ?>

		<?= arm_view( -area='myarea') ?>

		<div class="main">
			<p>This is the alternate theme.</p>

			<?= arm_view( -body ) ?>
		</div>

	</div>
	<?= arm_view( -js='footer' ) ?>
</body>
</html>

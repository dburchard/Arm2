<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?= arm_view( -title ) ?></title>

	<?= arm_theme( -favicon='favicon.ico', -rel='icon', -sizes='16x16 32x32', -type='image/png' ) ?>

	<?= arm_theme( -css='theme_style.css' ) ?>

	<?= arm_theme( -js='theme_jquery.js', -group='footer' ) ?>

	<?= arm_view( -metadata ) ?>

	<?= arm_view( -css ) ?>

</head>
<body>
	<div class="container">

		<?= arm_partial( 'head' ) ?>

		<?= arm_view( -area='myarea') ?>

			<p>This is the admin theme.</p>

		<div class="main" style="border:thin solid red">
			<?= arm_view( -body ) ?>
		</div>

	</div>
	<?= arm_view( -js='footer' ) ?>
</body>
</html>

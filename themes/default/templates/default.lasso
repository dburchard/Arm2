<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?= .view_title ?></title>

	<?=
		/*

		.navigation( 'footer' )

		.theme_favicon( 'favicon.ico', -rel='icon', -sizes='16x16 32x32', -type='image/png' )
		.theme_title
		.theme_subtitle


		*/
	?>

	<?= .theme_css( 'theme_style.css' ) ?>

	<?= .theme_js( 'theme_jquery.js', -group='footer' ) ?>

	<?= .theme_baseurl ?>

	<?= .addon_baseurl ?>

	<?= .view_metadata ?>

	<?= .view_css ?>

</head>
<body>
	<div class="container">

		<?= .addon_image( 'foo.png', -alt='' ) ?>

		<?= .theme_image( 'foo.png', -alt='Foo' ) ?>

		<?= .partial('head') ?>

		<?= .view_area('myarea') ?>

		<div class="main">
			<?= .view_body ?>
		</div>

	</div>
	<?= .view_js( 'footer' ) ?>
</body>
</html>

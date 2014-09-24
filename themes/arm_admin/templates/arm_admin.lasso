<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?= .view_title ?></title>

	<?= .theme_favicon( 'favicon.ico', -rel='icon', -sizes='16x16 32x32', -type='image/png' ) ?>

	<?= .theme_css( 'theme_style.css' ) ?>

	<?= .theme_js( 'theme_jquery.js', -group='footer' ) ?>

	<?= .view_metadata ?>

	<?= .view_css ?>

</head>
<body>
	<div class="container">

		<?= .partial('head') ?>

		<?= .view_area('myarea') ?>

			<p>This is the admin theme.</p>

		<div class="main" style="border:thin solid red">
			<?= .view_body ?>
		</div>

	</div>
	<?= .view_js( 'footer' ) ?>
</body>
</html>

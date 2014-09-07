<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title><?= .view_title ?></title>

	<?= .view_metadata ?>

</head>
<body>
	<div class="container">

		<?= .partial('head') ?>

		<?= .view_area('myarea') ?>

		<div class="main">
			<?= .view_body ?>
		</div>

	</div>
</body>
</html>

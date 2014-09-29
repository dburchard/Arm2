<!DOCTYPE html>

<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<base href="/"/>

	<title><?= arm_view( -title ) ?></title>
	<?= arm_view( -metadata ) ?>

	<?= arm_theme( -css='responsive.css' ) ?>

	<?= arm_theme( -css ) ?>
	<style type="text/css" title="text/css" media="all">#branding:after {content:url("<?= arm_theme( -baseurl ) ?>images/arm_logo_22x18.png");}</style>
	<?= arm_view( -css ) ?>

	<?= arm_theme( -js ) ?>
	<?= arm_view( -js ) ?>
</head>
<body>

	<div id="header">

		<h1 id="branding">Arm 2.0</h1>

		<ol id="nav">
			<li><a href="#">Home</a></li>
			<li><a href="#">Content</a>
				<ol>
					<li>Custom</li>
					<li>Pages</li>
				</ol>
			</li>
			<li><a href="#">Custom</a></li>
			<li><a href="#">Add-ons</a></li>
			<li><a href="#">Profile</a></li>
		</ol>

	</div>

	<div id="sub-header">
		<h1 id="name"><?= arm_view( -admin_title ) ?></h1>
		<p id="description"><?= arm_view( -admin_description ) ?> <a id="help" href="#"><?= arm_lang( 'aadmin.help_linktext' ) ?></a></p>
		<?= arm_view( -admin_shortcuts ) ?>
	</div>

	<?= 
		local( 'out' = arm_view( -admin_sections ))
		if( #out->size > 0 ) => {^
			'<div id="sub-nav">'
				'<h2>' + arm_lang( 'aadmin.section_header' ) + '</h2>'
				#out
			'</div>'
		^}
	?>

	<div id="container">

		<?= arm_view( -body ) ?>

	</div>

	<?= arm_view( -js='footer' ) ?>
</body>
</html>
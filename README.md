Arm2
====

A bottom-up redesign of the Arm framework. This is really a completely new project, and has very little connection to the original Arm1 design.


GETTING STARTED

Why Use a Framework?


MVC Basics
Model-View-Controller is a pattern of organizing your code. It separates data storage and retrieval (Model), application logic (Controller), and the user experience (View). Let's walk through how this plays out with the Arm Framework, and the following web request.

	http://www.example.com/sample

The above request automatically maps to a controller named "sample". The controller pushes information to the view, which uses templates to normalize the display into a finalized webpage. If data is needed from a database, or other datasource, a model is loaded and queried.

Installation
Installing the Arm Framework is as simple as downloading the latest version, and placing the files and folders in your web application's root directory.

Download as a ZIP: https://github.com/dburchard/Arm2/archive/master.zip

Clone as Git: git clone https://github.com/dburchard/Arm2

Checkout as SVN: svn export https://github.com/dburchard/Arm2


Setup
After installing the Arm Framework into it's intended location, about the only two things remaining to setup are the URL redirection, and a few preferences. We'll begin with the URL rewriting.

Most web servers have some sort of URL rewriting mechanism. In the case of Apache, it's usually mod_rewrite. The following code is appropriate for an .htaccess file at the root of your Arm instalation.

	RewriteEngine On

	RewriteRule ^ - [E=ARM_ENV:development]

	# Explicitely allow direct access to existing files.
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d

	# Take everything following the directory name, 
	# place it into an argument named "arm_path", and 
	# redirect the request to index.lasso.

	RewriteRule ^(.*)$ index.lasso?arm_env=development&arm_path=$1 [PT,NC,L,QSA]


In a virtual host definition, this might look more like the following.

	<VirtualHost *:80>
		ServerName www.example.com
		DocumentRoot /Library/WebServer/Documents/example
		CustomLog "/private/var/log/apache2/example-access_log" combined
		ErrorLog "/private/var/log/apache2/example-error_log"
		ServerAdmin webmaster@example.com
		HostnameLookups Off
		DirectoryIndex index.lasso
		SetEnv ARM_ENV development
		RewriteEngine On
		RewriteCond /Library/WebServer/Documents/example/%{REQUEST_FILENAME} !-f
		RewriteCond /Library/WebServer/Documents/example/%{REQUEST_FILENAME} !-d
		RewriteRule ^(.*)$ /index.lasso?arm_env=development&arm_path=$1 [PT,L,NC,NE,QSA]
	</VirtualHost>


Make sure to read the documentation for your server software. The above might take some fiddling if your version of Apache is significantly different than mine. I'll amend this portion of the documentation as I find out more about other servers. Please let me know your experience.







BUILDING A WEB APPLICATION

Creating an Addon

	The Controller

	Creating a View

	Calling a View

	Creating a Model

	Loading a Model

	Calling a Model

Working with Preferences

Working with Languages

Working with Themes

	Selecting a Theme


GUIDES

Creating a Theme


TODO



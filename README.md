Arm2
====

A bottom-up redesign of the Arm framework. This is really a completely new project, and has very little connection to the original Arm1 design.


GETTING STARTED

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
1. pull the prefered language from the web request.
2. do we *really* need folders for the preferences files? 
	perhaps move them to pilot_setup.lasso?



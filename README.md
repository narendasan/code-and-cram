code-and-cram
=============
This is a subset of the code used to create the Fairviewhs.org Mobile Web Application.
Includes:
-Embeded Ruby markup (.html.erb) for views
-CSS (.css.scss) assets that are responsible for styling for things like cards etc.
  - jqueryui is the actual structure of the site
-JavaScript and jQuery (.js) controls the AJAX loading and touch interaction 
-In the application controller (application.rb) the first three methods read the user-agent and based on that select the correct views (desktop or mobile) to render 

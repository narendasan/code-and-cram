# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Nav pages
nav_pages = {1 => "About Fairview", 2 => "Academics", 3 => "Athletics & Activities", 4 => "Website Support", 5 => "Library"}
nav_pages.each do |page|
  nav_page = NavPage.find_or_initialize_by_id(page[0])
  nav_page.name = page[1]
  nav_page.save
end

# Department pages
department_pages = ["World Languages", "Language Arts", "Science", "Mathematics", "English Language Learners", "Physical Education & Health", "Social Studies", "Student Services", "Visual Arts", "Fine Arts", "Business & Computer Education", "Special Education",  "Family & Consumer Science", "Library"]
department_pages.each do |page_name|
  DepartmentPage.find_or_create_by_name(page_name)
end

# Static pages
static_pages = {"info" => [2, "Contact Info & Directions"], "parent-resources" => [2, "Parent Resources"], "counseling" => [1, "Counseling"]}
static_pages.each do |page|
  static_page = StaticPage.find_or_initialize_by_url(page[0])
  static_page.template = page[1][0]
  static_page.name = page[1][1]
  static_page.save
end

# Activity pages
activity_pages = {"newsletter" => "FairViews Newsletter", "fpo" => "Fairview Parent Organization"}
activity_pages.each do |page|
  activity_page = ActivityPage.find_or_initialize_by_short_name(page[0])
  activity_page.name = page[1]
  activity_page.save
end

# Calendars
calendars = ["School Calendar", "Counseling Calendar"]
calendars.each do |calendar|
  Calendar.find_or_create_by_name(calendar)
end

# Feeds
Rake::Task['setup:build_feeds'].invoke

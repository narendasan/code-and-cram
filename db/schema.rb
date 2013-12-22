# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131124002840) do

  create_table "activity_pages", :force => true do |t|
    t.text     "name"
    t.text     "short_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contact_name"
    t.text     "contact_email"
    t.text     "contact_phone"
    t.text     "schedule_info"
    t.integer  "activity_type"
    t.boolean  "secure"
    t.integer  "nav_page_id"
    t.text     "nav_section_name"
    t.boolean  "display_files",    :default => true
    t.boolean  "display_calendar", :default => true
    t.boolean  "display_messages", :default => true
    t.boolean  "private_messages"
    t.boolean  "private_files"
    t.boolean  "private_calendar"
    t.text     "url_forward"
    t.text     "slug"
    t.boolean  "active",           :default => true
    t.text     "location"
  end

  create_table "activity_static_pages", :force => true do |t|
    t.text     "name"
    t.text     "contents"
    t.integer  "activity_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.integer  "template"
    t.boolean  "secure"
    t.boolean  "hidden"
    t.text     "url_forward"
    t.boolean  "hide_name"
    t.text     "slug"
    t.integer  "display_order"
  end

  add_index "activity_static_pages", ["activity_page_id"], :name => "index_activity_static_pages_on_activity_page_id"

  create_table "announcements", :force => true do |t|
    t.text     "title"
    t.text     "contents"
    t.date     "event_date"
    t.date     "expiration_date"
    t.boolean  "important"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feed_id"
  end

  create_table "answer_votes", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.text     "contents"
    t.boolean  "best_answer"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answer_votes_count", :default => 0, :null => false
  end

  create_table "assignments", :force => true do |t|
    t.text     "name"
    t.date     "due"
    t.text     "description"
    t.integer  "class_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private_item"
  end

  add_index "assignments", ["class_page_id", "due"], :name => "index_assignments_on_class_page_id_and_due"

  create_table "attachments", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.text     "file_file_name"
    t.text     "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachable_id"
    t.text     "attachable_type"
    t.boolean  "private_item"
    t.boolean  "hidden",            :default => false
  end

  add_index "attachments", ["attachable_type", "attachable_id"], :name => "attachs_on_poly_type_and_id"

  create_table "breakfast_reservations", :force => true do |t|
    t.string   "email"
    t.datetime "session"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "calendars", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_page_links", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.integer  "staff_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "class_pages", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "staff_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "class_photo_file_name"
    t.text     "class_photo_content_type"
    t.integer  "class_photo_file_size"
    t.text     "class_photo_updated_at"
    t.text     "syllabus_file_name"
    t.text     "syllabus_content_type"
    t.integer  "syllabus_file_size"
    t.text     "syllabus_updated_at"
    t.text     "class_photo_2_file_name"
    t.text     "class_photo_2_content_type"
    t.integer  "class_photo_2_file_size"
    t.datetime "class_photo_2_updated_at"
    t.text     "class_photo_3_file_name"
    t.text     "class_photo_3_content_type"
    t.integer  "class_photo_3_file_size"
    t.datetime "class_photo_3_updated_at"
    t.text     "class_photo_4_file_name"
    t.text     "class_photo_4_content_type"
    t.integer  "class_photo_4_file_size"
    t.datetime "class_photo_4_updated_at"
    t.boolean  "private_assignments"
    t.boolean  "private_calendar"
    t.boolean  "private_files"
    t.boolean  "private_messages"
    t.boolean  "active",                     :default => true
    t.boolean  "classroom_enabled",          :default => false
    t.text     "slug"
    t.integer  "display_order"
    t.text     "url_forward"
  end

  add_index "class_pages", ["staff_page_id"], :name => "index_class_pages_on_staff_page_id"

  create_table "comments", :force => true do |t|
    t.text     "contents"
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.boolean  "great_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboard_flashes", :force => true do |t|
    t.text     "text"
    t.text     "flash_type"
    t.boolean  "permanent"
    t.integer  "interval"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "department_pages", :force => true do |t|
    t.text     "name"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_order"
    t.text     "slug"
  end

  create_table "directory_records", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parent_1_last_name"
    t.text     "parent_1_first_name"
    t.text     "address"
    t.text     "city"
    t.text     "zip"
    t.text     "phone"
    t.text     "parent_2_last_name"
    t.text     "parent_2_first_name"
    t.text     "address_2"
    t.text     "city_2"
    t.text     "zip_2"
    t.text     "phone_2"
    t.integer  "user_id"
    t.boolean  "show_preferred_email"
    t.text     "parent_email_1"
    t.text     "parent_email_2"
  end

  create_table "discussions", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "class_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_count", :default => 0, :null => false
  end

  create_table "edit_privileges", :force => true do |t|
    t.integer  "editor_id"
    t.integer  "editable_page_id"
    t.text     "editable_page_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edit_privileges", ["editable_page_id"], :name => "index_edit_privileges_on_editable_id"
  add_index "edit_privileges", ["editable_page_type"], :name => "index_edit_privileges_on_editable_type"
  add_index "edit_privileges", ["editor_id", "editable_page_id", "editable_page_type"], :name => "edit_privilege_uniqueness", :unique => true
  add_index "edit_privileges", ["editor_id"], :name => "index_edit_privileges_on_editor_id"

  create_table "events", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "name"
    t.boolean  "all_day"
    t.text     "location"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calendar_id"
    t.text     "calendar_type"
    t.boolean  "private_item"
    t.text     "context"
  end

  add_index "events", ["calendar_type", "calendar_id"], :name => "index_events_on_calendar_type_and_calendar_id"
  add_index "events", ["start_time"], :name => "index_events_on_start_time"

  create_table "feeds", :force => true do |t|
    t.text     "title"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "slug"
    t.boolean  "active",        :default => true
    t.text     "context"
    t.integer  "display_order"
  end

  create_table "flashcard_decks", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "class_page_id"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flashcards_count", :default => 0, :null => false
  end

  create_table "flashcards", :force => true do |t|
    t.text     "front_side"
    t.text     "back_side"
    t.integer  "flashcard_deck_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folders", :force => true do |t|
    t.text     "name"
    t.text     "ancestry"
    t.text     "folderable_type"
    t.integer  "folderable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",          :default => false
  end

  add_index "folders", ["ancestry"], :name => "index_folders_on_ancestry"
  add_index "folders", ["folderable_type", "folderable_id"], :name => "index_folders_on_folderable_type_and_folderable_id"

  create_table "links", :force => true do |t|
    t.text     "name"
    t.text     "url"
    t.integer  "link_list_id"
    t.text     "link_list_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locker_registrations", :force => true do |t|
    t.text     "name"
    t.text     "school"
    t.text     "partner_name"
    t.text     "partner_school"
    t.text     "partner_2_name"
    t.text     "partner_2_school"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "title"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messenger_id"
    t.text     "messenger_type"
    t.boolean  "private_item"
  end

  add_index "messages", ["messenger_type", "messenger_id"], :name => "index_messages_on_messenger_type_and_messenger_id"

  create_table "nav_pages", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "nav_sections", :force => true do |t|
    t.text     "name"
    t.integer  "nav_page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "nav_section_photo_file_name"
    t.text     "nav_section_photo_content_type"
    t.integer  "nav_section_photo_file_size"
    t.datetime "nav_section_photo_updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.text     "notifiable_type"
    t.boolean  "read",            :default => false
    t.text     "message"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "photos", :force => true do |t|
    t.text     "caption"
    t.datetime "date"
    t.text     "photo_file_name"
    t.text     "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "album_type"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "class_page_id"
    t.boolean  "resolved"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answers_count", :default => 0, :null => false
  end

  create_table "quiz_answers", :force => true do |t|
    t.text     "contents"
    t.integer  "quiz_question_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_questions", :force => true do |t|
    t.text     "contents"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "quiz_score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "correct_responses"
    t.text     "responses"
    t.text     "question_order"
  end

  create_table "quizzes", :force => true do |t|
    t.text     "name"
    t.text     "instructions"
    t.integer  "user_id"
    t.integer  "class_page_id"
    t.text     "quiz_type"
    t.boolean  "public"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quiz_questions_count", :default => 0, :null => false
  end

  create_table "registrations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "directory_information"
    t.boolean  "media_coverage"
    t.boolean  "student_code_of_conduct"
    t.boolean  "parent_code_of_conduct"
    t.boolean  "student_compulsory_attendance"
    t.boolean  "parent_compulsory_attendance"
    t.boolean  "student_club_membership"
    t.boolean  "parent_club_membership"
    t.boolean  "student_sports_media_coverage"
    t.boolean  "parent_sports_media_coverage"
    t.boolean  "student_technology"
    t.boolean  "parent_technology"
    t.boolean  "student_military_opt_out"
    t.boolean  "parent_military_opt_out"
    t.boolean  "student_academic_honesty"
    t.boolean  "parent_academic_honesty"
    t.text     "parent_first_name"
    t.text     "parent_last_name"
    t.boolean  "health_screenings"
    t.integer  "step",                          :default => 0
    t.boolean  "parent_attendance_review"
    t.boolean  "student_attendance_review"
    t.text     "senior_first_name"
    t.text     "senior_middle_name"
    t.text     "senior_last_name"
  end

  create_table "scholarship_attributes", :force => true do |t|
    t.text     "name"
    t.text     "category_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "scholarship_attributes", ["category_name"], :name => "index_scholarship_attributes_on_category_name"

  create_table "scholarship_attributes_scholarships", :id => false, :force => true do |t|
    t.integer "scholarship_id"
    t.integer "scholarship_attribute_id"
  end

  add_index "scholarship_attributes_scholarships", ["scholarship_attribute_id", "scholarship_id"], :name => "attribute_scholarships_index", :unique => true
  add_index "scholarship_attributes_scholarships", ["scholarship_id", "scholarship_attribute_id"], :name => "scholarship_attributes_index", :unique => true

  create_table "scholarships", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.text     "url"
    t.integer  "amount"
    t.date     "deadline"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "phone"
    t.text     "email"
  end

  create_table "senior_lockers", :force => true do |t|
    t.text     "name"
    t.text     "student_id"
    t.text     "partner_name"
    t.text     "partner_student_id"
    t.boolean  "balcony"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "grade"
  end

  create_table "slugs", :force => true do |t|
    t.text     "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",       :default => 1, :null => false
    t.text     "sluggable_type"
    t.text     "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "staff_pages", :force => true do |t|
    t.text     "email"
    t.text     "phone"
    t.text     "office"
    t.text     "biography"
    t.text     "schedule"
    t.integer  "department_page_id"
    t.text     "staff_photo_file_name"
    t.text     "staff_photo_content_type"
    t.integer  "staff_photo_file_size"
    t.datetime "staff_photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "first_name"
    t.text     "last_name"
    t.boolean  "counselor"
    t.boolean  "administrator"
    t.boolean  "support"
    t.boolean  "active",                   :default => true
    t.text     "slug"
    t.text     "notification_settings"
    t.text     "category"
  end

  add_index "staff_pages", ["administrator"], :name => "index_staff_pages_on_administrator"
  add_index "staff_pages", ["category"], :name => "index_staff_pages_on_category"
  add_index "staff_pages", ["counselor"], :name => "index_staff_pages_on_counselor"
  add_index "staff_pages", ["department_page_id"], :name => "index_staff_pages_on_department_page_id"
  add_index "staff_pages", ["email"], :name => "index_staff_pages_on_email"
  add_index "staff_pages", ["support"], :name => "index_staff_pages_on_support"

  create_table "static_pages", :force => true do |t|
    t.text     "url"
    t.text     "name"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template"
    t.integer  "nav_page_id"
    t.text     "nav_section_name"
    t.boolean  "hide_name"
    t.text     "restricted_access"
    t.text     "url_forward"
    t.text     "ancestry"
    t.text     "slug"
    t.boolean  "hide_files"
    t.integer  "display_order"
    t.boolean  "hidden",            :default => false
  end

  add_index "static_pages", ["url"], :name => "index_static_pages_on_url"

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.text     "subscribed_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["subscribed_id"], :name => "index_subscriptions_on_subscribed_id"
  add_index "subscriptions", ["subscribed_type"], :name => "index_subscriptions_on_subscribed_type"
  add_index "subscriptions", ["subscriber_id", "subscribed_id", "subscribed_type"], :name => "subscription_uniqueness", :unique => true
  add_index "subscriptions", ["subscriber_id"], :name => "index_subscriptions_on_subscriber_id"

  create_table "tour_reservations", :force => true do |t|
    t.text     "name"
    t.text     "email"
    t.boolean  "attendance_area"
    t.datetime "session"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.text     "access_token"
  end

  create_table "users", :force => true do |t|
    t.text     "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.text     "name"
    t.text     "encrypted_password"
    t.text     "salt"
    t.text     "preferred_email"
    t.integer  "grade"
    t.boolean  "temp_password"
    t.text     "welcome"
    t.text     "user_type"
    t.boolean  "returning_student",     :default => true
    t.text     "notification_settings"
    t.text     "student_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

  create_table "volunteer_records", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "parent_first_name"
    t.text     "parent_last_name"
    t.text     "student_grade"
    t.text     "parent_phone"
    t.text     "parent_email"
    t.boolean  "fundraising"
    t.boolean  "communications"
    t.boolean  "parent_education"
    t.boolean  "hospitality"
    t.boolean  "volunteer_coordination"
    t.boolean  "district_parent_council_rep"
    t.boolean  "impact_on_education_rep"
    t.boolean  "sit_committee"
    t.boolean  "alumni_association"
    t.boolean  "bookroom_volunteer"
    t.boolean  "interior_campus_improvement"
    t.boolean  "exterior_campus_improvement"
    t.boolean  "copy_room_volunteer"
    t.boolean  "counseling_volunteer"
    t.boolean  "exam_proctor"
    t.boolean  "fairviews_newsletter"
    t.boolean  "food_donations"
    t.boolean  "grant_writing"
    t.boolean  "health_room_volunteer"
    t.boolean  "library_volunteer"
    t.boolean  "knight_crew_lunches"
    t.boolean  "parent_link_leader"
    t.boolean  "tutoring"
    t.boolean  "webmaster"
    t.boolean  "post_graduate_center"
    t.boolean  "after_prom"
    t.boolean  "csap_snacks"
    t.boolean  "dances"
    t.boolean  "diplomas"
    t.boolean  "student_directory"
    t.boolean  "fpo_kick_off"
    t.boolean  "freshman_pizza_party"
    t.boolean  "open_enrollment_refreshments"
    t.boolean  "registration"
    t.boolean  "senior_barbecue"
    t.boolean  "staff_appreciation_august"
    t.boolean  "staff_appreciation_february"
    t.boolean  "staff_appreciation_may"
    t.boolean  "vision_and_hearing_screening"
    t.boolean  "anything"
    t.integer  "user_id"
  end

end

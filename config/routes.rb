Fairview::Application.routes.draw do

  ## Sessions
  match '/signup',  to: 'users#new'
  get   '/signin',  to: 'sessions#new',     as: :new_session
  post  '/signin',  to: 'sessions#create',  as: :create_session
  match '/signout', to: 'sessions#destroy', as: :destroy_session

  get   '/apps_auth_begin',  to: 'sessions#apps_auth_begin', as: :apps_auth
  get   '/apps_auth_finish', to: 'sessions#apps_auth_finish'

  ## Users
  get "/users/autocomplete", to: "users#autocomplete"
  get "/users/new-temp",     to: "users#new_temp",    as: :new_temp_user
  post "/users/create-temp", to: "users#create_temp", as: :create_temp_user
  resources :users
  get "/request-reset-password" => "users#request_reset_password", as: :request_reset_password
  post "/reset-password" => "users#reset_password",                as: :reset_password

  ## Edit Privileges
  resources :edit_privileges, only: [:create, :destroy]

  ## Subscriptions
  resources :subscriptions, only: [:create, :destroy]

  ## Notifications
  post "/notifications/fetch", to: "notifications#fetch", as: :notification_fetch
  # get  "/notifications",       to: "notifications#index", as: :notifications

  ## Dashboard
  root to: "dashboard#show"
  get "/assignments",   to: "dashboard#all_assignments", as: :all_assignments
  get "/messages",      to: "dashboard#all_messages",    as: :all_messages
  get "/bell-schedule", to: "dashboard#bell_schedule",   as: :bell_schedule
  get "/features",      to: "dashboard#features",        as: :features

  ## Announcements
  resources :feeds, path: "/feeds" do
    member do
      get :editors
    end
    post 'sort', on: :collection
    resources :announcements, path: "/announcements"
  end

  ## School Calendar
  get "/calendar/list" => "school_events#list",                defaults: { calendar_name: "School Calendar" }, as: :school_calendar_list
  get "/calendar/editors" => "school_events#editors",          defaults: { calendar_name: "School Calendar" }, as: :editors_school_calendar
  match "/calendar(/:year(/:month))" => "school_events#index", defaults: { calendar_name: "School Calendar" }, as: :school_calendar, constraints: {year: /20(?:1[1-9]|20)/, month: /\d{1,2}/}
  resources :school_events, path: "/events",                   defaults: { calendar_name: "School Calendar" }, except: [:index]

  ## Activity Pages
  resources :activity_pages, path: "/sites/" do
    member do
      get :editors
    end
    get "/calendar/list", to: "activity_events#list", as: :calendar_list
    match "/calendar(/:year(/:month))" => "activity_events#index",
      as: :calendar,
      constraints: { year: /\d{4}/, month: /\d{1,2}/ }
    resources :activity_events,   path: "/events",   except: [:index, :show]
    resources :activity_messages, path: "/messages", except: :show
    resources :folders, except: :index do
      post "move_file",   to: "attachments#move",           on: :member
      post "move_folder", to: "folders#move",               on: :member
      match "hide" => "folders#hide", via: [:put, :delete], on: :member
    end
    resources :attachments, path: "/files", except: [:index, :show] do
      match "hide" => "attachments#hide", via: [:put, :delete], on: :member
    end
    match "/files" => "folders#show", as: :attachments
    match "/multi-upload" => "attachments#multi_upload", as: :multi_upload

    resources :activity_static_pages, path: "/pages/" do
      resources :photos, path: "/photos", only: :create
      post 'sort', on: :collection
    end
    match "/multi-photo-upload" => "photos#multi_upload", as: :multi_photo_upload
  end

  ## Staff Directory
  get "/staff" => "staff_pages#directory", as: :staff_directory

  ## Page Activation
  get "/staff-inactive" => "staff_pages#inactive", as: :inactive_staff

  ## Department Pages
  resources :department_pages, path: "/departments", except: :index do
    resources :staff_pages, path: "/staff", controller: "staff_pages", only: [:new, :create]
  end

  ## Staff Pages, Class Pages & Resources
  resources :staff_pages, path: "/staff", controller: "staff_pages", except: [:index, :new] do
    member do
      get :editors
    end

    match "/enable-classroom" => "staff_pages#enable_classroom", as: :enable_classroom_for_staff_page

    match "/activate" => "staff_pages#activate", as: :activate

    resources :class_pages, path: "/classes" do
      member do
        get :subscribers
      end

      get "/description" => "class_pages#description", as: :class_description

      resources :folders, except: :index do
        post "move_file",   to: "attachments#move", on: :member
        post "move_folder", to: "folders#move",     on: :member
        match "hide" => "folders#hide", via: [:put, :delete], on: :member
      end
      resources :assignments, except: :show
      resources :class_messages, path: "/messages", except: :show
      resources :attachments, path: "/files", except: [:index, :show] do
        match "hide" => "attachments#hide", via: [:put, :delete], on: :member
      end
      match "/files" => "folders#show", as: :attachments
      match "/multi-upload" => "attachments#multi_upload", as: :multi_upload

      get "/calendar/list" => "class_events#list", as: :calendar_list
      match "/calendar(/:year(/:month))" => "class_events#index",
        as: :calendar,
        constraints: { year: /\d{4}/, month: /\d{1,2}/ }
      resources :class_events, path: "/events", except: [:index, :show]

      match "/activate" => "class_pages#activate", as: :activate

      match "/enable-classroom" => "class_pages#enable_classroom", as: :enable_classroom
    end
  end

  ## Classroom
  match "/classroom", to: "classroom#info", as: :classroom_info
  match "/show-classroom-spot", to: "classroom#show_spot", as: :show_classroom_spot

  match "/enable-classroom", to: "classroom#enable_classroom", as: :enable_classroom_for_user

  resources :discussions,     path: "/classroom/discussions", except: [:show, :edit, :update], as: :orphan_discussions
  resources :questions,       path: "/classroom/questions",   except: [:show, :edit, :update], as: :orphan_questions
  resources :flashcard_decks, path: "/classroom/flashcards",  except: [:show, :edit, :update], as: :orphan_flashcard_decks
  resources :quizzes,         path: "/classroom/quizzes",     except: [:show, :edit, :update], as: :orphan_quizzes
  match "/classroom/:id", to: "classroom#show", as: :classroom

  resources :discussions, path: "/classroom/:class_page_id/discussions" do
    post "/great_comment" => "comments#update_great_comment", as: :update_great_comment
    resources :comments, except: [:index, :show, :new]
  end

  resources :questions, path: "/classroom/:class_page_id/questions" do
    post "/resolve"   => "questions#resolve",   as: :resolve
    post "/unresolve" => "questions#unresolve", as: :unresolve
    resources :answers, except: [:index, :show, :new]
  end
  resources :answer_votes, only: [:create, :destroy]

  resources :flashcard_decks, path: "/classroom/:class_page_id/flashcards"

  resources :quizzes, path: "/classroom/:class_page_id/quizzes", except: :show do
    post "/clone" => "quizzes#clone", on: :member
    resources :quiz_reports, path: "reports", except: [:update, :edit]
  end

  ## Counseling
  get "/counseling", to: "counseling#home", as: :counseling

  get "/counseling/calendar/list" => "school_events#list",                defaults: { calendar_name: "Counseling Calendar" }, as: :counseling_calendar_list
  get "/counseling/calendar/editors" => "school_events#editors",          defaults: { calendar_name: "Counseling Calendar" }, as: :editors_counseling_calendar
  match "/counseling/calendar(/:year(/:month))" => "school_events#index", defaults: { calendar_name: "Counseling Calendar" }, as: :counseling_calendar, constraints: {year: /\d{4}/, month: /\d{1,2}/}
  resources :school_events, path: "/counseling/events",                   defaults: { calendar_name: "Counseling Calendar" }, except: :index, as: :counseling_event

  resources :scholarships, path: "/counseling/scholarships"

  ## Nav Pages
  get "/about",     to: "nav_pages#show", id: 1
  get "/academics", to: "nav_pages#show", id: 2
  get "/athletics", to: "nav_pages#show", id: 3
  get "/support",   to: "nav_pages#show", id: 4, as: :website_support
  get "/library",   to: "nav_pages#show", id: 5
  resources :nav_pages, except: :index

  ## Mailers
  resources :emails, path: "/contact", only: [:index, :create]

  ## Registration
  scope "(:locale)", locale: /en|es/ do

    get "/registration-export",         to: "registrations#dump_csv"
    get "/registration-diploma-export", to: "registrations#dump_diplomas_csv"
    get "/registration-emails-export",  to: "registrations#dump_emails_csv"

    get "/registration",       to: "registrations#welcome", as: :registration_welcome
    get "/registration/forms", to: "registrations#forms",   as: :registration_forms
    resources :registrations, path: "/registration", only: [:edit, :update]
    post "/registration/user-update", to: "registrations#user_update"

    resources :volunteer_records, path: "/registration/volunteering"
    get "/registration/volunteering-export", to: "volunteer_records#dump_csv"

    resources :tour_reservations, path: "/registration/tours", only: [:new, :create, :edit, :update, :destroy]
    get "/registration/tours",        to: "tour_reservations#new"
    get "/registration/tours-export", to: "tour_reservations#dump_csv"

    resources :breakfast_reservations, path: "/registration/breakfast", only: [:new, :create, :edit, :update, :destroy]
    get "/registration/breakfast",        to: "breakfast_reservations#new"
    get "/registration/breakfast-export", to: "breakfast_reservations#dump_csv"

    resources :senior_lockers, path: "/registration/lockers", only: [:new, :create]
    get "/lockers",                     to: "senior_lockers#new"
    get "/registration/lockers-export", to: "senior_lockers#dump_csv"

    ## Registration Sessions
    get   '/registration/signin',  to: 'registration_sessions#new',     as: :new_registration_session
    post  '/registration/signin',  to: 'registration_sessions#create',  as: :create_registration_session
    match '/registration/signout', to: 'registration_sessions#destroy', as: :destroy_registration_session

    ## Directory
    resources :directory_records, path: "/directory" do
      get 'email', on: :member
    end
  end

  ## File Uploading
  resources :folders, except: :index do
    resources :attachments, except: :show do
      match "hide" => "attachments#hide", via: [:put, :delete], on: :member
    end
  end

  post "/upload_file",  to: "attachments#upload"
  post "/upload_photo", to: "photos#upload"

  match "/multi-photo-upload", to: "photos#multi_upload", as: :static_page_multi_photo_upload

  ## Redirects
  match "/old" => redirect("http://www.bvsd.org/schools/fairviewhs")
  match "/lame" => redirect("http://www.bvsd.org/schools/fairviewhs")
  match "/nhs" => redirect("/sites/nhs")
  match "/news" => redirect("http://fhsroyalbanner.com")
  match "/choir" => redirect("/sites/choir")
  match "/activities" => redirect("/sites")
  match "/clubs" => redirect("/sites")
  match "/planner" => redirect("/assignments")
  match "/help" => redirect("/support")
  match "/webteam" => redirect("/support")
  match "/index(.html)" => redirect("/")

  ## Jammit Asset Packaging
  #match "/assets/:package.:extension",
  #  to: 'jammit#package',
  #  as: :jammit,
  #  constraints: {
  #    # A hack to allow extension to include "."
  #    extension: /.+/
  #  }

  ## Static Pages
  resources :static_pages, path: "/pages", only: [:create, :index, :new]
  get    "(/*parents)/:url/edit",    to: "static_pages#edit",    as: :edit_static_page
  get    "(/*parents)/:url/new",     to: "static_pages#new",     as: :new_static_page
  get    "(/*parents)/:url/index",   to: "static_pages#index",   as: :static_pages
  get    "(/*parents)/:url/editors", to: "static_pages#editors", as: :editors_static_page
  post   "(/*parents)/:url/index",   to: "static_pages#create"
  get    "(/*parents)/:url",         to: "static_pages#show",    as: :static_page
  put    "(/*parents)/:url",         to: "static_pages#update"
  delete "(/*parents)/:url",         to: "static_pages#destroy"
  post   "/pages/sort",              to: "static_pages#sort",    as: :sort_static_pages

  ###################################################################

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  # This route can be invoked with purchase_url(id: product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root to: "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

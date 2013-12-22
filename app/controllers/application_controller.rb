class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include RegistrationSessionsHelper

  before_filter :mobile_session

  def mobile_platform?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile/
    end
  end
  helper_method :mobile_platform?

  def mobile_session
    session[:mobile_param] = params[:mobile] if params[:mobile]
    mobile_view_path if mobile_platform?
  end

  def mobile_view_path
    if mobile_platform?
      prepend_view_path Rails.root + 'app' + 'mobile_views'
    end
  end

  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
    # or delete the remember_token
  end

  def helpers
    ActionController::Base.helpers
    # this allows us to use helpers outside of views, e.g. 'helpers.pluralize('word', 3)'
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  if Rails.env != "development"
    rescue_from(ActionView::MissingTemplate) do |e|
      head(:not_acceptable)
    end
  end

  def default_url_options(options={})
    options[:locale] = params[:locale] ? I18n.locale : nil
    options
  end

  before_filter :set_locale
  before_filter :miniprofiler_access

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def miniprofiler_access
    Rack::MiniProfiler.authorize_request if current_user.try(:admin)
  end
  private :miniprofiler_access

  # Defined Globals
  @@security_message = "Hey! You're not allowed to access that page. Big Brother is watching..."
  @@signin_message = "You must be signed in to access that page."
  @@subscription_message = "You must be a subscriber to access that page."


  helper_method :static_page_path
  helper_method :editors_static_page_path
  helper_method :edit_static_page_path
  helper_method :new_static_page_path
  helper_method :static_pages_path

  helper_method :messages_path
  helper_method :message_path
  helper_method :edit_message_path

  helper_method :assignments_path
  helper_method :assignment_path
  helper_method :edit_assignment_path

  helper_method :attachment_path
  helper_method :attachments_path
  helper_method :attachments_folder_path
  helper_method :edit_attachment_path
  helper_method :new_attachment_path
  helper_method :multiple_attachments_path
  helper_method :hide_attachment_path

  helper_method :multiple_photos_path

  helper_method :folder_path
  helper_method :new_folder_path
  helper_method :edit_folder_path
  helper_method :hide_folder_path

  helper_method :event_path
  helper_method :calendar_path
  helper_method :calendar_list_path
  helper_method :create_event_path
  helper_method :edit_event_path
  helper_method :new_event_path

  helper_method :new_attachable_path

  helper_method :edit_page_path
  helper_method :page_path



  protected

    def static_page_path(page)
      if page.is_root?
        "/" + page.url
      else
        "/" + page.ancestors.collect {|c| c.url}.join("/") + "/" + page.url
      end
    end

    def editors_static_page_path(page)
      static_page_path(page) + "/editors"
    end

    def edit_static_page_path(page)
      static_page_path(page) + "/edit"
    end

    def new_static_page_path(page = nil)
      if page
        static_page_path(page) + "/new"
      else
        "/pages/new"
      end
    end

    def static_pages_path(page = nil)
      if page
        static_page_path(page) + "/index"
      else
        "/pages"
      end
    end


    def message_path(message)
      case message.messenger_type
      when "ClassPage"
        staff_page_class_page_class_message_path(message.messenger.staff_page, message.messenger, message)
      when "ActivityPage"
        activity_page_activity_message_path(message.messenger, message)
      end
    end

    def messages_path(message)
      case message.messenger_type
      when "ClassPage"
        staff_page_class_page_class_messages_path(message.messenger.staff_page, message.messenger)
      when "ActivityPage"
        activity_page_activity_messages_path(message.messenger)
      end
    end

    def edit_message_path(message)
      case message.messenger_type
      when "ClassPage"
        edit_staff_page_class_page_class_message_path(message.messenger.staff_page, message.messenger, message)
      when "ActivityPage"
        edit_activity_page_activity_message_path(message.messenger, message)
      end
    end



    def assignment_path(assignment)
      staff_page_class_page_assignment_path(assignment.class_page.staff_page, assignment.class_page, assignment)
    end

    def assignments_path(assignment)
      staff_page_class_page_assignments_path(assignment.class_page.staff_page, assignment.class_page)
    end

    def edit_assignment_path(assignment)
      edit_staff_page_class_page_assignment_path(assignment.class_page.staff_page, assignment.class_page, assignment)
    end



    def attachment_path(page, attachment)
      case page
      when ClassPage
        staff_page_class_page_attachment_path(page.staff_page, page, attachment)
      when ActivityPage
        activity_page_attachment_path(page, attachment)
      when StaticPage
        folder_attachment_path(attachment.attachable, attachment)
      end
    end

    def attachments_path(attachment)
      case attachment.attachable
      when ClassPage
        staff_page_class_page_attachments_path(attachment.folder.staff_page, attachment.folder)
      when ActivityPage
        activity_page_attachments_path(attachment.folder)
      when StaticPage
        folder_path(attachment.folder)
      end
    end

    def attachments_folder_path(page)
      case page
      when ClassPage
        staff_page_class_page_attachments_path(page.staff_page, page)
      when ActivityPage
        activity_page_attachments_path(page)
      end
    end

    def edit_attachment_path(page, attachable, attachment)
      case page
      when ClassPage
        edit_staff_page_class_page_attachment_path(page.staff_page, page, attachment,
                                                     attachable_id: attachable.id,
                                                     attachable_type: attachable.class.to_s)
      when ActivityPage
        edit_activity_page_attachment_path(page, attachment,
                                           attachable_id: attachable.id,
                                           attachable_type: attachable.class.to_s)
      when StaticPage
        edit_folder_attachment_path(attachable, attachment)
      end
    end

    def new_attachment_path(page, attachable)
      case page
      when ClassPage
        new_staff_page_class_page_attachment_path(page.staff_page, page,
                                                    attachable_id: attachable.id,
                                                    attachable_type: attachable.class.to_s)
      when ActivityPage
        new_activity_page_attachment_path(page,
                                          attachable_id: attachable.id,
                                          attachable_type: attachable.class.to_s)
      when StaticPage
        new_root_attachment_path(page,
                                 attachable_id: attachable.id,
                                 attachable_type: attachable.class.to_s)
      end
    end

    def multiple_attachments_path(page, attachable)
      case page
      when ClassPage
        staff_page_class_page_multi_upload_path(page.staff_page, page,
                                                  attachable_id: attachable.id,
                                                  attachable_type: attachable.class.to_s)
      when ActivityPage
        activity_page_multi_upload_path(page,
                                        attachable_id: attachable.id,
                                        attachable_type: attachable.class.to_s)
      end
    end

    def hide_attachment_path(page, attachable, attachment)
      case page
      when ClassPage
      hide_staff_page_class_page_attachment_path(page.staff_page, page, attachment,
                                                   attachable_id: attachable.id,
                                                   attachable_type: attachable.class.to_s)
      when ActivityPage
        hide_activity_page_attachment_path(page, attachment,
                                           attachable_id: attachable.id,
                                           attachable_type: attachable.class.to_s)
      when StaticPage
        hide_folder_attachment_path(attachable, attachment)
      end
    end

    def multiple_photos_path(page)
      case page
      when ActivityStaticPage
        activity_page_multi_photo_upload_path(page.activity_page,
                                              album_id: page.id,
                                              album_type: page.class.to_s)
      when StaticPage
        static_page_multi_photo_upload_path(album_id: page.id,
                                            album_type: page.class.to_s)
      end
    end



    def folder_path(page, folder)
      case page
      when ClassPage
        staff_page_class_page_folder_path(page.staff_page, page, folder)
      when ActivityPage
        activity_page_folder_path(page, folder)
      when StaticPage
        static_page_path(page)
      end
    end

    def new_folder_path(page, folder)
      case page
      when ClassPage
        new_staff_page_class_page_folder_path(page.staff_page, page, folder,
                                                parent_id: folder.id,
                                                folderable_id: page.id,
                                                folderable_type: page.class.to_s)
      when ActivityPage
        new_activity_page_folder_path(page, folder,
                                      parent_id: folder.id,
                                      folderable_id: page.id,
                                      folderable_type: page.class.to_s)
      end
    end

    def edit_folder_path(page, folder)
      case page
      when ClassPage
        edit_staff_page_class_page_folder_path(page.staff_page, page, folder)
      when ActivityPage
        edit_activity_page_folder_path(page, folder)
      end
    end

    def hide_folder_path(page, folder)
      case page
      when ClassPage
        hide_staff_page_class_page_folder_path(page.staff_page, page, folder)
      when ActivityPage
        hide_activity_page_folder_path(page, folder)
      end
    end


    def event_path(event)
      case event.calendar_type
      when "ClassPage"
        staff_page_class_page_class_event_path(event.calendar.staff_page, event.calendar, event)
      when "ActivityPage"
        activity_page_activity_event_path(event.calendar, event)
      else
        case event.calendar.name
        when "Counseling Calendar"
          counseling_event_path(event)
        when "School Calendar"
          school_event_path(event)
        end
      end
    end

    def calendar_path(event, params = { year: event.start_time.try(:year), month: event.start_time.try(:month) })
      case event.calendar_type
      when "ClassPage"
        staff_page_class_page_calendar_path(event.calendar.staff_page, event.calendar, params)
      when "ActivityPage"
        activity_page_calendar_path(event.calendar, params)
      when "Calendar"
        case event.calendar.name
        when "Counseling Calendar"
          counseling_calendar_path(params)
        when "School Calendar"
          school_calendar_path(params)
        end
      end
    end

    def calendar_list_path(event)
      case event.calendar.name
      when "Counseling Calendar"
        counseling_calendar_list_path
      when "School Calendar"
        school_calendar_list_path
      end
    end

    def create_event_path(calendar)
      case calendar.name
      when "Counseling Calendar"
        counseling_event_index_path
      when "School Calendar"
        school_events_path
      end
    end

    def edit_event_path(event)
      case event.calendar_type
      when "ClassPage"
        edit_staff_page_class_page_class_event_path(event.calendar.staff_page, event.calendar, event)
      when "ActivityPage"
        edit_activity_page_activity_event_path(event.calendar, event)
      else
        case event.calendar.name
        when "Counseling Calendar"
          edit_counseling_event_path(event)
        when "School Calendar"
          edit_school_event_path(event)
        end
      end
    end

    def new_event_path(calendar, params = {})
      case calendar.name
      when "Counseling Calendar"
        new_counseling_event_path(params)
      when "School Calendar"
        new_school_event_path(params)
      end
    end



    def edit_page_path(page)
      case page
      when ActivityStaticPage
        edit_activity_page_activity_static_page_path(page.activity_page, page)
      else
        edit_static_page_path(page)
      end
    end

    def page_path(page)
      case page
      when ActivityStaticPage
        activity_page_activity_static_page_path(page.activity_page, page)
      else
        static_page_path(page)
      end
    end


    # Admin security check

    def admin_security
      if signed_in? && !current_user.admin?
        flash[:error] = @@security_message
        redirect_to root_path
      else
        user_security
      end
    end

    def user_security
      unless signed_in?
        flash[:error] = @@signin_message
        redirect_to(new_session_path(continue: request.path))
      end
    end

    def access_security(page = @page)
      if signed_in? && !access(page)
        flash[:error] = @@security_message
        redirect_to root_path
      else
        user_security
      end
    end

    def classroom_user_security
      unless current_user.try(:student?) || current_user.try(:staff?)
        flash[:error] = "You must be signed in as a student or staff member to access that page."
        redirect_to(new_session_path(continue: request.path))
      end
    end

    def get_classroom_class_page
      @class_page = ClassPage.find_by_id(params[:class_page_id])
      @current = "Classroom"
    end

    def subscription_security
      if @class_page && !(current_user.subscribed?(@class_page) || access(@class_page))
        flash[:error] = "Only students in #{@class_page.name} are allowed to access that page. If you are, subscribe here and try again."
        redirect_to staff_page_class_page_path(@class_page.staff_page, @class_page)
      end
    end

    def find_class_page_param(params)
      [:discussion, :flashcard_deck, :question, :quiz].each do |p|
        return params[p][:class_page_id] if params[p]
      end
      return nil
    end

    def classroom_enabled
      if @class_page || @class_page = ClassPage.find_by_id(find_class_page_param(params))
        unless @class_page.classroom_enabled
          flash[:error] = "Classroom has not been enabled for this class yet."
          redirect_to(request.referer || url_for([@class_page.staff_page, @class_page])) and return
        end
      end
    end

    def registration_user_security
      unless registration_user.try(:student?)
        sign_out
        redirect_to new_registration_session_path
      end
    end
end

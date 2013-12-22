module ApplicationHelper

  def broadcast(channel, &block)
    message = { channel: channel, data: capture(&block), ext: { auth_token: FAYE_TOKEN }}
    uri = URI.parse("#{request.protocol}#{request.host}:9292/faye")
    Net::HTTP.post_form(uri, message: message.to_json)
  end

  def markdown(text, options = {})
    return "" if text.blank?

    if options[:simple]
      sanitize(RedcarpetParser.render(text), tags: %w(strong em a), attributes: %w(href))
    elsif options[:safe]
      sanitize(RedcarpetParser.render(text), tags: %w(strong em a p ul ol li br h1 h2 h3 h4 h5 h6 div span), attributes: %w(href class id))
    else
      RedcarpetParser.render(text)
    end
  end

  def strip_markdown(text)
    text.blank? ? "" : sanitize(CGI.unescapeHTML(RedcarpetParser.render(text)), tags: [])
  end

  def text_preview(text, truncate_string = "")
    stripped_text = strip_markdown(text)
    if stripped_text.length < 150
      stripped_text
    else
      truncate(stripped_text, length: 150) + truncate_string
    end
  end

  def truncate_words(text, length, path = "#", truncate_string = "...")
    return if text.nil?
    l = length
    truncate_string = truncate_string + (" ([continued](" + path + "))") if path
    text.length > length ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end

  def possessivize(text)
    if text[-1,1] == "s"
      text + "'"
    else
      text + "'s"
    end
  end

  def crumbs_for(object)
    case object
    when :staff_directory
      [
        ["Home", :root],
        ["Staff", :staff_directory]
      ]
    when :school_calendar
      [
        ["Home", :root],
        ["Calendar", :school_calendar]
      ]
    when :counseling_calendar
      [
        ["Home", :root],
        ["Counseling", StaticPage.roots_only.find_by_url("counseling")],
        ["Calendar", :counseling_calendar]
      ]
    when :activity_pages
      [
        ["Home", :root],
        ["Athletics & Activities", :activity_pages]
      ]
    when ActivityPage
      crumbs_for(:activity_pages) + [
        [object.name, object]
      ]
    when NavPage
      [
        ["Home", :root],
        [object.name, object]
      ]
    when DepartmentPage
      crumbs_for(:staff_directory) + [
        [object.name, object]
      ]
    when StaffPage
      (crumbs_for(object.department_page) || crumbs_for(:staff_directory)) + [
        [object.full_name, object]
      ]
    when ClassPage
      crumbs_for(object.staff_page) + [
        [object.name, [object.staff_page, object]]
      ]
    when Assignment
      crumbs_for(object.class_page) + [
        ["Assignments", [object.class_page.staff_page, object.class_page, object]]
      ]
    when Folder
      case object.folderable_type
      when "ClassPage"
        class_page = ClassPage.find(object.folderable_id)
        crumbs_for(class_page) + [
          ["Files", [class_page.staff_page, class_page, object]]
        ]
      when "ActivityPage"
        activity_page = ActivityPage.find(object.folderable_id)
        crumbs_for(activity_page) + [
          ["Files", [activity_page, object]]
        ]
      end
    when ClassEvent
      crumbs_for(object.calendar) + [
        ["Calendar", [object.calendar.staff_page, object.calendar, object]]
      ]
    when ActivityEvent
      crumbs_for(object.calendar) + [
        ["Calendar", [object.calendar, object]]
      ]
    when Event
      case object.calendar
      when ClassPage
        crumbs_for(object.calendar) + [
          ["Calendar", [object.calendar.staff_page, object.calendar, :calendar]]
        ]
      when ActivityPage
        crumbs_for(object.calendar) + [
          ["Calendar", [object.calendar, :calendar]]
        ]
      when Calendar
        case object.calendar.name
        when "Counseling Calendar"
          crumbs_for(:counseling_calendar)
        when "School Calendar"
          crumbs_for(:school_calendar)
        end
      end + [
        [truncate(object.name, length: 30, separator: ' '), object]
      ]
    when Calendar
      case object.name
      when "Counseling Calendar"
        crumbs_for(:counseling_calendar)
      when "School Calendar"
        crumbs_for(:school_calendar)
      end
    end

  end

  def sub_links_for(object)
    case object
    when :welcome
      [
        ["Announcements", :root],
        ["School News", "http://www.fhsroyalbanner.com/"],
        ["FPO", "/sites/fpo"],
        ["Student Directory", directory_records_path(utm_source: "dashboard-signed-out", utm_medium: "dashboard-button", utm_campaign: "student-directory")],
        ["Calendar", :school_calendar],
        ["Bell Schedule", :bell_schedule],
        ["Contact Info", "/info"],
        ["Map & Directions", "/info"],
        ["Alumni", "/alumni?utm_source=dashboard-signed-out&utm_medium=dashboard-button&utm_campaign=alumni"]
      ]
    when :staff_dashboard
      [
        ["Dashboard", :root],
        ["School News", "http://www.fhsroyalbanner.com/"],
        ["Staff Information", "/staff-info"],
        ["Student Directory", directory_records_path(utm_source: "dashboard-signed-in", utm_medium: "dashboard-button", utm_campaign: "student-directory")],
        ["Calendar", :school_calendar],
        ["Bell Schedule", :bell_schedule],
        ["Classroom", classroom_info_path]
      ]
    when :student_dashboard
      [
        ["Dashboard", :root],
        ["School News", "http://www.fhsroyalbanner.com/"],
        ["Student Directory", directory_records_path(utm_source: "dashboard-signed-in", utm_medium: "dashboard-button", utm_campaign: "student-directory")],
        ["Calendar", :school_calendar],
        ["Bell Schedule", :bell_schedule],
        ["Alumni", "/alumni?utm_source=dashboard-signed-in&utm_medium=dashboard-button&utm_campaign=alumni"],
        ["Assignments", :all_assignments],
        ["Messages", :all_messages],
        ["Classroom", classroom_info_path],
        ["Tutoring Marketplace", "/tutoring_marketplace"]
      ]
    when :staff_directory
      [
        ["Teaching Faculty", "#teaching-faculty"],
        ["Administrative Staff", "#administrative-staff"],
        ["Counseling Staff", "#counseling-staff"],
        ["Support Staff", "#support-staff"]
      ]
    end
  end

  # micro_links_for method can be found in /app/controllers/staff_controller.rb

  def quick_links_for(object)
    case object
    when :welcome
      links = StaticPage.find_by_url("parent-resources").try(:links) || []
      return_links = Array.new([["Parent Resources"]])
      links.each do |link|
        return_links << [link.name, link.url]
      end
      return_links
    end
  end

  def date_spans(date)
    month = content_tag(:span, date.strftime("%b"), class: "month")
    day = content_tag(:span, date.strftime("%d"), class: "day")

    content_tag(:span, month + day, class: "date")
  end

  def pluralize_no_count(count, singular, plural = nil)
    ((count == 1 || count == '1') ? singular : (plural || singular.pluralize))
  end

  def staff_inheritance(staff)
    if request.fullpath.include?("departments")
      [staff.department_page, staff]
    else
      staff
    end
  end

  def classroom_user_link(user)
    if current_user.admin?
      link_to user.name, user, class: user.user_type
    elsif user.staff?
      staff_page = user.edit_privileges.where(editable_page_type: "StaffPage").first.try(:editable_page)
      if staff_page
        link_to user.name, staff_page, class: "staff"
      else
        content_tag(:a, user.name, class: "staff")
      end
    else
      content_tag(:a, user.name, class: user.user_type)
    end
  end
end

def link_to_add_fields(name, f, association)
  new_object = f.object.class.new
  fields = f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
    render("shared/" + association.to_s.singularize + "_fields", f: builder)
  end
  link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
end

def safe_redirect(unsafe_url)
  uri = URI.parse(unsafe_url)
  (!uri.host || uri.host == request.host) && uri.path[0] == "/" ? uri.path : root_path
  rescue URI::InvalidURIError
    root_path
end

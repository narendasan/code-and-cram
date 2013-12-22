atom_feed(root_url: feed_url(@feed)) do |feed|
  feed.title "Fairview #{@feed.title}"
  feed.updated @upcoming_announcements.order("updated_at").last.updated_at if @upcoming_announcements.length > 0

  @upcoming_announcements.each do |announcement|
    feed.entry(announcement, url: feed_announcement_url(@feed, announcement)) do |entry|
      entry.title(announcement.title)
      entry.content(markdown(announcement.contents).html_safe, type: 'html')

      entry.author do |author|
        if @feed.context == "school"
          author.name "Fairview High School"
          author.uri root_url
        else
          author.name "Fairview High School Counseling Department"
          author.uri URI.join(root_url, static_page_path(@counseling_root))
        end
      end
    end
  end
end


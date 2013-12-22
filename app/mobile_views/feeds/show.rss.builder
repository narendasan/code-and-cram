xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Fairview #{@feed.title}"
    xml.description "Fairview #{@feed.title}"
    xml.link feed_url(@feed)

    for announcement in @upcoming_announcements
      xml.item do
        xml.title announcement.title
        xml.description markdown(announcement.contents).html_safe
        xml.pubDate announcement.created_at.to_s(:rfc822)
        xml.link feed_announcement_url(@feed, announcement)
        xml.guid feed_announcement_url(@feed, announcement)
      end
    end
  end
end

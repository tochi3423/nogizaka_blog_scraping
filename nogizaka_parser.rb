require_relative './common.rb'


class NogizakaParser

  def parse_member_page(doc)
    doc = Nokogiri::HTML.parse(doc, nil, "UTF-8")
    articles = doc.css("div.entrybody")
    titles = doc.css("span.entrytitle > a")
    dates = doc.css("span.date")
    member_name = doc.css("div#sideprofile h3").text
    return member_name, dates.zip(articles, titles)
  end

  def parse_picture(html)
    doc = Nokogiri::HTML.parse(html, nil, "UTF-8")
    img_nodeset = doc.css("div.entrybody > div > a > img")
    img_url_arr = []
    img_nodeset.each do |img_node|
      img_url_arr << img_node.attribute("src").text
    end
    return unless img_url_arr.present?
    img_url_arr
  end
end
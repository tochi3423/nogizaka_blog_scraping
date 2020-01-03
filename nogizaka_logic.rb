require_relative './common.rb'
require_relative './nogizaka_crawler.rb'
require_relative './nogizaka_parser.rb'

class NogizakaLogic
  def initialize
    @crawler = NogizakaCrawler.new
    @parser = NogizakaParser.new
  end

  def main(blog_home_url)
    date_key, member_url_arr = @crawler.crawl_blog_page(blog_home_url)
    member_url_arr.each do |member|
      date_key.each do |date|
        url = blog_home_url + member + "/" +  date
        member_html = @crawler.fetch_html(url)
        doc = Nokogiri::HTML.parse(member_html, nil, "UTF-8")
        page_arr = @crawler.get_page_number_arr(doc)
        page_arr.unshift(1)
        page_arr.each do |page|
          url = blog_home_url + member + "/?p=" + page.to_s + "&" + date.gsub("?", "")
          member_name, article_arr = @parser.parse_member_page(@crawler.fetch_html(url))
          insert_article(article_arr, member_name, @crawler.fetch_html(url))
        end
      end
    end
  end

  def insert_article(article_arr, member_name, html)
    article_arr.each do |article|
      hash = {
        "member_name" => member_name,
        "date" => article[0].text,
        "text" => article[1].text,
        "title" => article[2].text,
        "html" => html,
        "pictures_url" => @parser.parse_picture(html)
      }
      insert_hash(MemberBlog, hash)
    end
  end

  def insert_hash(class_name, article_hash)
    return if record_existing?(class_name, article_hash)
    class_name.create(article_hash)
  end

  def record_existing?(class_name, article_hash)
    member_hash = {
      date: article_hash["date"],
      title: article_hash["title"],
      member_name: article_hash["member_name"]
    }
    same_record = class_name.find_by(member_hash)
    return same_record.present?
  end

end



logic  = NogizakaLogic.new
logic.main("http://blog.nogizaka46.com/")
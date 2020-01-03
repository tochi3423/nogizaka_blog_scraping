require_relative './common.rb'

class NogizakaCrawler
  def initialize
    @ua_chrome = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'.freeze
  end

  def fetch_html(url, ua = @ua_chrome)
    open(url, 'User-Agent' => ua, allow_redirections: :all).read
  end

  def crawl_blog_page(url)
    home_html = fetch_html(url)
    doc = Nokogiri::HTML.parse(home_html, nil, "UTF-8")
    date_nodes = doc.css("div#sidearchives > select > option")
    date_key = date_nodes.map do |date_node|
      date_node.attribute("value").text.gsub("http://blog.nogizaka46.com/", "")
    end
    member_url = doc.css("div.unit > a")
    member_url_arr = member_url.map do |url_node|
      url_node.attribute("href").text.gsub(/^../, "")
    end
    return date_key, member_url_arr
  end


  def get_page_number_arr(doc)
    page = doc.at_css("div.paginate")
    page_arr = []
    return ["1"] if page.blank?
    page.css("a").each do |a_tag|
      page_arr << a_tag.text.gsub(/[[:space:]]/, "").to_i
    end
    page_arr.pop
    return page_arr
  end

end


if __FILE__ == $0
  logic = NogizakaCrawler.new
  logic.move_to_member_page("http://blog.nogizaka46.com/")
end
require 'rubygems'
require 'bundler'
require 'nokogiri'
require 'socket'
require 'active_record'
require 'active_support'
require 'active_support/core_ext'
require 'selenium-webdriver'
require 'open-uri'
require 'open_uri_redirections'


dbname = "nogizaka"
host = 'localhost'
user = 'souta'
pass = "souta3423"
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :adapter  => 'mysql2',
  :charset => 'utf8mb4',
  :encoding => 'utf8mb4',
  :collation => 'utf8mb4_general_ci',
  :database => dbname,
  :host     => host,
  :username => user,
  :password => pass
)
Time.zone_default =  Time.find_zone! 'Tokyo' # config.time_zone
ActiveRecord::Base.default_timezone = :local # config.active_record.default_timezone

class MemberBlog < ActiveRecord::Base; end
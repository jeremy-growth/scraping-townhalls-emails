require 'rubygems'
require 'nokogiri'   
require 'open-uri'

class Scrapper
  @@url_mairie = "https://www.annuaire-des-mairies.com/val-d-oise.html"   

  def self.perform
    page = Nokogiri::HTML(open(@@url_mairie))
    array_townhall_urls = self.get_townhall_urls(page)
    array_city = self.get_townhall_names(page)
    array_emails = self.get_townhall_email(array_townhall_urls)
    array_of_hash = self.join_my_two_arrays(array_city, array_emails)
    return array_of_hash
  end

  def self.get_townhall_urls(url)
    b = []
    news_links = url.css("a.lientxt")
    news_links.each do |link|
      b << link['href']
    end
    b.map! do |partial_adress|
      partial_adress = partial_adress[2..-1]
      partial_adress = "https://www.annuaire-des-mairies.com/#{partial_adress}"
    end
    return b
  end

  def self.get_townhall_names(url)
    b = []
    news_links = url.css("a.lientxt")
    news_links.each do |link|
      b << link.text
    end
    return b
  end

  def self.get_townhall_email(array_of_adresses)
    a = []
    array_of_adresses.each do |adresses|
      Nokogiri::HTML(open(adresses)).xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |node|
        a << node.text
      end
    end
    return a
  end

  def self.join_my_two_arrays(array_1, array_2)
    array_final = Hash[array_1.zip array_2]
    return array_final
  end
end
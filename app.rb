
require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'app/email_sender'
require 'views/done'
require 'views/index'

def save_as_JSON(hash_brut)
  File.open("db/emails.json","w") do |f|
    f.write(hash_brut.to_json)
  end
end

def save_as_spreadsheet(session, hash_brut)
  ws = session.spreadsheet_by_key("your_key").worksheets[0]
  ws[1, 1] = "Ville"
  ws[1, 2] = "Mail"
  hash_brut.each do |key, value|
    ws.insert_rows(ws.num_rows + 1, [[key, value]])
  end
  ws.save
end

def save_as_csv(hash_brut)
  CSV.open("db/scrap.csv", "w", :write_headers => true, :headers => ["Ville","Email"]) do |csv|
    hash_brut.each do |key, value|
      csv << [key, value]
    end
  end
end

def perform
session = GoogleDrive::Session.from_config("config.json")
townhall_array = Scrapper.perform
#json_file = save_as_JSON(townhall_array)
#spreadsheet_file = save_as_spreadsheet(session, townhall_array)
#csv_file = save_as_csv(townhall_array)
end

perform

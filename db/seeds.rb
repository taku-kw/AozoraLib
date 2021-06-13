# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

Lib.destroy_all

# CSV.foreach('tmp/storage/list_short.csv', headers: true) do |fg|
CSV.foreach('tmp/storage/list_person_all_extended_utf8.csv', headers: true) do |fg|
  title = fg['作品名']
  class_number = fg['分類番号']
  link = fg['XHTML/HTMLファイルURL']
  if /\p{katakana}/ === fg['姓'] then
    author = fg['名'] + fg['姓']
  else
    author = fg['姓'] + fg['名']
  end

  Lib.create(title: title, author: author, class_number: class_number, link: link)
end

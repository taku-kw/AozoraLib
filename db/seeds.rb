# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

Book.destroy_all
CSV.foreach('tmp/storage/list_person_all_extended_utf8.csv', headers: true) do |fg|
  title = fg['作品名']
  title_yomi = fg['ソート用読み']
  class_number = fg['分類番号']
  link = fg['XHTML/HTMLファイルURL']
  if /\p{katakana}/ === fg['姓'] then
    author = fg['名'] + '・' + fg['姓']
    author_yomi = fg['名読みソート用'] + fg['姓読みソート用']
  else
    author = fg['姓'] + fg['名']
    author_yomi = fg['姓読みソート用'] + fg['名読みソート用']
  end
  release_date = fg['公開日']

  Book.create(title: title, title_yomi: title_yomi, author: author, author_yomi: author_yomi, class_number: class_number, link: link, release_date: release_date)
end

# Create Recommend Author Whitelist to DB
RecommendAuthor.destroy_all
authors = Book.all.select(:author).distinct().pluck(:author)
for author in authors do
  RecommendAuthor.create(author: author, can_webapi: true)
end


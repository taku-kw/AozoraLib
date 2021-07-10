require "#{Rails.root}/app/models/book"
require 'nokogiri'
require 'open-uri'

class AddNewBooks
  def self.execute
    p ("exec add_new_books.rb")

    aozora_url = 'https://www.aozora.gr.jp/index_pages/whatsnew1.html'
    aozora_top_url = 'https://www.aozora.gr.jp'
    
    fd_new_books = URI.open(aozora_url)
    doc_new_books = Nokogiri::HTML.parse(fd_new_books)
    
    latest_book_title = Book.order(release_date: 'DESC', created_at: 'DESC').first.title.to_s
   
    books = [] 
    header_flag = true;
    doc_new_books.xpath('//tr[@valign="top"]').each do |node|
      if header_flag then
        header_flag = false
      else
        new_book_title = node.css('a').inner_text.strip
        new_book_url = aozora_top_url + node.css('a').attribute('href').to_s.slice(2..)
        new_book_release_date = node.css('td')[0].inner_text.strip
    
        if latest_book_title == new_book_title then
          break
        end
    
        fd_new_book = URI.open(new_book_url)
        doc_new_book = Nokogiri::HTML.parse(fd_new_book)
    
        book_hash = {"title" => "", "title_yomi" => "", "author" => "", "author_yomi" => "", "link" => "", "release_date" => ""}
    
        # title, title_yomi
        title_data_table = doc_new_book.xpath('//table[@summary="タイトルデータ"]')[0]
        book_hash["title"] = title_data_table.css('tr')[0].css('font').inner_text.strip
        book_hash["title_yomi"] = title_data_table.css('tr')[1].css('td')[1].inner_text.strip.tr('ァ-ン', 'ぁ-ん').delete("^[ぁ-んー－]")
        # author, author_yomi
        author_data_table = doc_new_book.xpath('//table[@summary="作家データ"]')[0]
        author_tmp = author_data_table.css('tr')[1].css('a').inner_text.strip
        author_split = author_tmp.split(' ')
        if /\p{katakana}/ === author_tmp then
          book_hash["author"] = author_split[1] + '・' + author_split[0]
        else
          book_hash["author"] = author_split[0] + author_split[1]
        end
        book_hash["author_yomi"] = author_data_table.css('tr')[2].css('td')[1].inner_text.strip.tr('ァ-ン', 'ぁ-ん').delete("^[ぁ-んー－]")
        # link
        link_div = doc_new_book.xpath('//div[@align="right"]')[1]
        book_hash["link"] = new_book_url.gsub(/(card[0-9]+.*)/, "") + link_div.css('a')[1].attribute('href').to_s.slice(2..)
        # release_date
        book_hash["release_date"] = new_book_release_date

        p book_hash
        books.push(Book.new(book_hash))

        RecommendAuthor.find_or_create_by(author: book_hash["author"])
      end
    end
    for book in books.reverse do
      book.save
    end
    p ("done add_new_books.rb")
  end
end

AddNewBooks.execute
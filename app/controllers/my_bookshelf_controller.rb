class MyBookshelfController < ApplicationController
  SEARCH_OFFSET = 12

  def show
    rentals = current_user.rentals.order(created_at: 'desc').limit(SEARCH_OFFSET)
    @books = []
    for rental in rentals
      @books.push(Book.find_by(id: rental.book_id))
    end
    session[:my_bookshelf_search_offset] = 0
    session[:my_bookshelf_search_count] = current_user.rentals.count
    if session[:my_bookshelf_search_count] <= (session[:my_bookshelf_search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false 
  end

  def show_next
    session[:my_bookshelf_search_offset] += SEARCH_OFFSET
    rentals = current_user.rentals.order(created_at: 'desc').limit(SEARCH_OFFSET).offset(session[:my_bookshelf_search_offset])
    @books = []
    for rental in rentals
      @books.push(Book.find_by(id: rental.book_id))
    end
    if session[:my_bookshelf_search_count] <= (session[:my_bookshelf_search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = true    
  end

  def show_previous
    session[:my_bookshelf_search_offset] -= SEARCH_OFFSET
    rentals = current_user.rentals.order(created_at: 'desc').limit(SEARCH_OFFSET).offset(session[:my_bookshelf_search_offset])
    @books = []
    for rental in rentals
      @books.push(Book.find_by(id: rental.book_id))
    end
    if session[:my_bookshelf_search_offset] == 0 then
      @previous_flag = false
    else
      @previous_flag = true
    end
    @next_flag = true
  end

  def new
    @book = Book.find_by(id: params['book_id'])
    rental_flag = false
    for rental in current_user.rentals do
      if rental.book_id == @book.id then
        rental_flag = true
        break
      end
    end
    if rental_flag then
      render 'duplicate'
    else
      current_user.books << @book
    end
  end

  def delete
    current_user.rentals.find_by(book_id: params['book_id']).destroy
    session[:my_bookshelf_search_count] = current_user.books.count
    if (session[:my_bookshelf_search_count] - session[:my_bookshelf_search_offset] == 0) && (session[:my_bookshelf_search_count] != 0) then
      session[:my_bookshelf_search_offset] -= SEARCH_OFFSET
    end
    @books = current_user.books.limit(SEARCH_OFFSET).offset(session[:my_bookshelf_search_offset])
    if session[:my_bookshelf_search_count] <= (session[:my_bookshelf_search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    if session[:my_bookshelf_search_offset] == 0 then
      @previous_flag = false
    else
      @previous_flag = true
    end
  end

end

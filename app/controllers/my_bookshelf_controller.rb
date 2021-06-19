class MyBookshelfController < ApplicationController
  SEARCH_OFFSET = 10

  def show
    @books = current_user.books.limit(SEARCH_OFFSET)
    session[:my_bookshelf_search_offset] = 0
    session[:my_bookshelf_search_count] = current_user.books.count
    if session[:my_bookshelf_search_count] <= session[:my_bookshelf_search_offset] then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false 
  end

  def show_next
    session[:my_bookshelf_search_offset] += SEARCH_OFFSET
    @books = current_user.books.limit(SEARCH_OFFSET).offset(session[:my_bookshelf_search_offset])
    if session[:my_bookshelf_search_count] <= (session[:my_bookshelf_search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = true    
  end

  def show_previous
    session[:my_bookshelf_search_offset] -= SEARCH_OFFSET
    @books = current_user.books.limit(SEARCH_OFFSET).offset(session[:my_bookshelf_search_offset])
    if session[:my_bookshelf_search_offset] == 0 then
      @previous_flag = false
    else
      @previous_flag = true
    end
    @next_flag = true
  end

  def new
    current_user.books += Book.where(id: params['book_id'])
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

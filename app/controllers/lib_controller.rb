class LibController < ApplicationController
  include LibHelper
  SEARCH_OFFSET = 12

  def index

  end

  def lib
    err = 'Not Exec'
    while !err.empty? do
      begin
        err = ''
        @author_name = Book.offset( rand(Book.count) ).first.author
        @author_summary = get_author_summary(@author_name)
        @author_image = get_author_image(@author_name)
        @author_books = Book.where('author like ? ', @author_name).order('RANDOM()').limit(4)            
      rescue => exception
        err = 'Wiki API Err : ' + @author_name
        logger.warn err.colorize(:yellow)
      end
    end
  end

  def contact

  end

  def search_name_title
    @search_result = Book.where('title_yomi like ?', params['keyword'] + '%').limit(SEARCH_OFFSET)
    session[:search_offset] = 0
    session[:keyword] = params['keyword']
    session[:search_method] = 'title'
    session[:search_count] = Book.where('title_yomi like ?', params['keyword'] + '%').count

    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false
  end

  def search_name_author
    @search_result = Book.where('author_yomi like ?', params['keyword'] + '%').limit(SEARCH_OFFSET).select(:author).distinct
    session[:search_offset] = 0
    session[:keyword] = params['keyword']
    session[:search_method] = 'author'
    session[:search_count] = Book.where('author_yomi like ?', params['keyword'] + '%').select(:author).distinct.count

    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false    
  end

  def search_name_title_by_author
    @search_result = Book.where(author: params[:keyword]).limit(SEARCH_OFFSET)
    session[:search_offset] = 0
    session[:keyword] = params['keyword']
    session[:search_method] = 'title_by_author'
    session[:search_count] = Book.where(author: session[:keyword]).count

    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false    
  end

  def search_class
    @search_result = Book.where('class_number like ?', '% ' + params['keyword'] + '%').limit(SEARCH_OFFSET)
    session[:search_offset] = 0
    session[:keyword] = params['keyword']
    session[:search_method] = 'class'
    session[:search_count] = Book.where('class_number like ?', '% ' + params['keyword'] + '%').count

    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false    
  end

  def search_text 
    case params[:search_method]
    when '作品名' then
      @search_result = Book.where('title like ?', '%' + params['keyword'] + '%').limit(SEARCH_OFFSET)
      session[:search_method] = 'text_title'
      session[:search_count] = Book.where('title like ?', '%' + params['keyword'] + '%').count
    when '作者名' then
      @search_result = Book.where('author like ?', '%' + params['keyword'] + '%').limit(SEARCH_OFFSET).select(:author).distinct
      session[:search_method] = 'text_author'
      session[:search_count] = Book.where('author like ?', '%' + params['keyword'] + '%').select(:author).distinct.count
    end
    session[:search_offset] = 0
    session[:keyword] = params['keyword']

    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = false
  end

  def next_result
    session[:search_offset] += SEARCH_OFFSET
    case session[:search_method]
    when 'title' then
      @search_result = Book.where('title_yomi like ?', session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'author' then
      @search_result = Book.where('author_yomi like ?', session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset]).select(:author).distinct
    when 'title_by_author' then
      @search_result = Book.where(author: session[:keyword]).limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'class' then
      @search_result = Book.where('class_number like ?', '% ' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'text_title' then
      @search_result = Book.where('title like ?', '%' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'text_author' then
      @search_result = Book.where('author like ?', '%' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset]).select(:author).distinct
    end
    if session[:search_count] <= (session[:search_offset] + SEARCH_OFFSET) then
      @next_flag = false
    else
      @next_flag = true
    end
    @previous_flag = true
  end

  def previous_result
    session[:search_offset] -= SEARCH_OFFSET
    case session[:search_method]
    when 'title' then
      @search_result = Book.where('title_yomi like ?', session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'author' then
      @search_result = Book.where('author_yomi like ?', session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset]).select(:author).distinct
    when 'title_by_author' then
      @search_result = Book.where(author: session[:keyword]).limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'class' then
      @search_result = Book.where('class_number like ?', '% ' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'text_title' then
      @search_result = Book.where('title like ?', '%' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
    when 'text_author' then
      @search_result = Book.where('author like ?', '%' + session[:keyword] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset]).select(:author).distinct
    end
    if session[:search_offset] == 0 then
      @previous_flag = false
    else
      @previous_flag = true
    end
    @next_flag = true
  end

end

class LibController < ApplicationController
  include LibHelper
  SEARCH_OFFSET = 12
  ERR_CNT_MAX = 5

  BOOK_CLASS_TO_NDI_HASH = {'総記' => '00', '図書館. 図書館情報学' => '01', '団体' => '06', 'ジャーナリズム. 新聞' => '07',
                            '哲学' => '10', '哲学各論' => '11', '東洋思想' => '12', '西洋思想' => '13', '心理学' => '14', '倫理学. 道徳' => '15', '宗教' => '16', '神道' => '17', '仏教' => '18', 'キリスト教' => '19',
                            '歴史' => '20', '日本史' => '21', 'アジア史. 東洋史' => '22', 'ヨーロッパ史. 西洋史' => '23', '北アメリカ史' => '25', '伝記' => '28', '地理. 地誌. 紀行' => '29',
                            '社会科学' => '30', '政治' => '31', '法律' => '32', '経済' => '33', '社会' => '36', '教育' => '37', '風俗習慣. 民俗学. 民族学' => '38', '国防. 軍事' => '39',
                            '自然科学' => '40', '数学' => '41', '物理学' => '42', '化学' =>'43', '天文学. 宇宙科学' => '44', '地球科学. 地学 ' => '45', '生物科学. 一般生物学 ' => '46', '植物学' => '47', '動物学' => '48', '医学' => '49',
                            '技術. 工学' => '50', '建設工学. 土木工学' => '51', '建築学' => '52', '機械工学' => '53', '電気工学' => '54', '海洋工学. 船舶工学' => '55', '金属工学. 鉱山工学' => '56', '化学工業' => '57', '製造工業' => '58', '家政学. 生活科学' => '59',
                            '産業' => '60', '農業' => '61', '畜産業' => '64', '林業' => '65', '水産業' => '66', '商業' => '67', '運輸. 交通' => '68', '通信事業' => '69',
                            '芸術. 美術' => '70', '彫刻' => '71', '絵画' => '72', '版画' => '73', '写真' => '74', '工芸' => '75', '音楽' => '76', '演劇' => '77', 'スポーツ. 体育' => '78', '諸芸. 娯楽' => '79',
                            '言語' => '80', '日本語' => '81', '中国語' => '82', '英語' => '83', 'ドイツ語' => '84', 'その他の諸言語' => '89',
                            '文学' => '90', '日本文学' => '91', '中国文学' => '92', '英米文学' => '93', 'ドイツ文学' => '94', 'フランス文学' => '95', 'スペイン文学' => '96', 'イタリア文学' => '97', 'ロシア・ソビエト文学' => '98', 'その他の諸言語文学' => '99'
                           }

  def index

  end

  def lib
    session[:search_offset] = 0
    session[:search_count] = 0    
    err = 'Not Exec'
    err_cnt = 0
    @err_flag = false
    while !err.empty? && err_cnt < ERR_CNT_MAX do
      err = ''
      author = RecommendAuthor.where(can_webapi: true).order('RANDOM()').first
      @author_name = author.author
      begin
        @author_summary = get_author_summary(@author_name)
        @author_image = get_author_image(@author_name)
        @author_books = Book.where('author like ? ', @author_name).order('RANDOM()').limit(4)            
      rescue => exception
        err = 'Wiki API Err : ' + @author_name
        logger.warn err.colorize(:yellow)
        err_cnt = err_cnt + 1
        author.can_webapi = false
        author.save
      end
    end
    if err_cnt >= ERR_CNT_MAX then
      @err_flag = true
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
    @search_result = Book.where('class_number like ?', '% ' + BOOK_CLASS_TO_NDI_HASH[params['keyword']] + '%').limit(SEARCH_OFFSET)
    session[:search_offset] = 0
    session[:keyword] = params['keyword']
    session[:search_method] = 'class'
    session[:search_count] = Book.where('class_number like ?', '% ' + BOOK_CLASS_TO_NDI_HASH[params['keyword']] + '%').count

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
      @search_result = Book.where('class_number like ?', '% ' + BOOK_CLASS_TO_NDI_HASH[session[:keyword]] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
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
      @search_result = Book.where('class_number like ?', '% ' + BOOK_CLASS_TO_NDI_HASH[session[:keyword]] + '%').limit(SEARCH_OFFSET).offset(session[:search_offset])
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

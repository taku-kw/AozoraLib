$('.show').on('click', '.previous-bookshelf-click,.next-bookshelf-click', function(){
  $('.book-card-list').append('<div id="loading-search"></div>')
})

$('.show').on('click', '.previous-bookshelf-click,.next-bookshelf-click', function(){
  $("html,body").animate({scrollTop:$('.bookshelf-area').offset().top});
})

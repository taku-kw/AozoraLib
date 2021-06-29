
$('.item-1')
  .on('mouseover', function() {
    $(this).children('.item-area-2').css('display', 'block')
  })
  .on('mouseout', function() {
    $(this).children('.item-area-2').css('display', 'none')
  })

$('.item-2')
  .on('mouseover', function() {
    $(this).children('.item-area-3').css('display', 'block')
  })
  .on('mouseout', function() {
    $(this).children('.item-area-3').css('display', 'none')
  })

$('.item-area-1 a')
  .on('click', function(){
    $('.item-area-3').css('display', 'none')
    $('.item-area-2').css('display', 'none')
  })

$('.search-item')
  .on('click', function(){
    $('#result-area').append('<div id=#loading-search></div>')
  })

  $('.result-area')
    .on('click', '.search-item-author', function() {
      $('#result-area').append('<div id=#loading-search></div>')
  })
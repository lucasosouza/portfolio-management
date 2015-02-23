
function updateNews(transactions) {
  $.ajax({url: "/api/v1/news"}).done(function(response){
    console.log("Successfully retrieved news")
    renderNews(response);
  }).fail(function(err){
    console.log("Failed to retrieve news")
  })
};

function renderNews(data) {
  console.log(data)
  $('#news').empty()
  $.each(data, function(stock, news){
    $('#news').append("<h4>" + stock + "</h4>")
    $.each(news, function(headline, link) {
      $('#news').append("<p><a href='" + link + "' target='_blank'>" + headline + "</a></p>")
    })
  })
}
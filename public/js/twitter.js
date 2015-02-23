
function updateTweets(transactions) {
  $.ajax({url: "/api/v1/tweets"}).done(function(response){
    console.log("Successfully retrieved tweets")
    renderTweets(response);
  }).fail(function(err){
    console.log("Failed to retrieve tweets")
  })
};

function renderTweets(data) {
  $('#twitters').empty()
  $.each(data, function(stock, tweets){
    var rateColor;
    if (tweets[0] > 0) { rateColor = "blue"; }
    else if (tweets[0] < 0) { rateColor = "red"; }
    else { rateColor = "gray";}
    $('#twitters').append("<h4>" + stock + "</h4><span class='lead' style='font-size:14px;display:block;color:" + rateColor + "'>Rate: " + Number(tweets[0] * 100).toFixed(2) + "</span>")
    $.each(tweets, function(j, tweet) {
      if (j > 0) { $('#twitters').append("<p>" + tweet + "</p>") }
    })
  })
}




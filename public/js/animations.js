$(document).ready(function() {


//Filter status

$('#select-status').change(function(e) {
  var status = $('#select-status option:selected').text().toLowerCase();
  if (status === "open") {
    $.each($('th[data-status]'), function(i, obj){
      if ($(obj).text().toLowerCase() === "sold") {
        $(obj).parent().fadeOut(0);
      } else if ($(obj).text().toLowerCase() === "open") {
        $(obj).parent().fadeIn(0);
      }
    })
  } else if (status === "sold") {
    $.each($('th[data-status]'), function(i, obj){
      if ($(obj).text().toLowerCase() === "open") {
        $(obj).parent().fadeOut(0);
      } else if ($(obj).text().toLowerCase() === "sold") {
        $(obj).parent().fadeIn(0);
      }
    })
  } else if (status === "all") {
    $.each($('th[data-status]'), function(i, obj){
        $(obj).parent().fadeIn(0);
    })
  }
});

//Filter stock

$('#select-ticker').change(function(e) {
  var stock = $('#select-ticker option:selected').text().toLowerCase();
  if (stock === "all") {
    $.each($('td[data-ticker]'), function(i, obj) {
      $(obj).parent().fadeIn(0);
    })
  } else {
    $.each($('td[data-ticker]'), function(i, obj) {
      if ($(obj).text().toLowerCase() === stock) {
        $(obj).parent().fadeIn(0);
      } else {
        $(obj).parent().fadeOut(0);
      }
    })
  }
});

//Filter expired date

$('#select-expired-date').change(function(e) {
  dateExpired = new Date($(this).val());
  $.each($('td[data-sell-datetime]'), function(i, obj) {
    if (new Date($(obj).text()) >= dateExpired || $(obj).text() === "")
      $(obj).parent().fadeIn(0);
    else
      $(obj).parent().fadeOut(0);
  })
});

//Filter days open

$('#select-max-span').change(function(e) {
  maxSpan = Number($(this).val());
  $.each($('td[data-days-open]'), function(i, obj) {
    currentSpan = Number($(obj).text())
    if (currentSpan >= maxSpan)
      $(obj).parent().fadeIn(0);
    else
      $(obj).parent().fadeOut(0);
  });

});

// Shows buy and sell form

$('#buy-stock-header').click(function(e) {
  $('#buy-stock-form').fadeToggle(300)
});

$('#sell-stock-header').click(function(e) {
  $('#sell-stock-form').fadeToggle(300)
});










//

});



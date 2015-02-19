$(document).ready(function() {

function FilterController() {

  this.filterStatus = function() {
    var status = $('#select-status option:selected').text().toLowerCase();
    if (status === "open") {
      $.each($('th[data-status]'), function(i, obj){
        if ($(obj).text().toLowerCase() === "sold") {
          $(obj).parent().fadeOut(0);
        }
        // else if ($(obj).text().toLowerCase() === "open") {
        //   $(obj).parent().fadeIn(0);
        // }
      })
    } else if (status === "sold") {
      $.each($('th[data-status]'), function(i, obj){
        if ($(obj).text().toLowerCase() === "open") {
          $(obj).parent().fadeOut(0);
        }
        // else if ($(obj).text().toLowerCase() === "sold") {
        //   $(obj).parent().fadeIn(0);
        // }
      })
    }
    // else if (status === "all") {
    //   $.each($('th[data-status]'), function(i, obj){
    //       $(obj).parent().fadeIn(0);
    //   })
    // }
  },

  this.filterStock = function() {
    var stock = $('#select-ticker option:selected').text().toLowerCase();
    if (stock === "all") {
      // $.each($('td[data-ticker]'), function(i, obj) {
      //   $(obj).parent().fadeIn(0);
      // })
    } else {
      $.each($('td[data-ticker]'), function(i, obj) {
        if ($(obj).text().toLowerCase() === stock) {
          // $(obj).parent().fadeIn(0);
        } else {
          $(obj).parent().fadeOut(0);
        }
      })
    }
  },

  this.filterSpan = function() {
    var maxSpan = Number($('#select-max-span').val());
    $.each($('td[data-days-open]'), function(i, obj) {
      currentSpan = Number($(obj).text())
      if (currentSpan >= maxSpan) {
        // $(obj).parent().fadeIn(0);
      }
      else {
        $(obj).parent().fadeOut(0);
      }
    });
  },

  this.filterDate = function() {
    dateExpired = new Date($('#select-expired-date').val());
    $.each($('td[data-sell-datetime]'), function(i, obj) {
      if (new Date($(obj).text()) >= dateExpired || $(obj).text() === "") {
        // $(obj).parent().fadeIn(0);
      }
      else {
        $(obj).parent().fadeOut(0);
      }
    })
  },

  this.showAll = function() {
    console.log("here")
    $.each($('th[data-status]'), function(i, obj){
      $(obj).parent().fadeIn(0);
    })
  },

  this.filterAll = function() {
    var callbacks = $.Callbacks();
    callbacks.add(this.showAll());
    callbacks.add(this.filterStatus());
    callbacks.add(this.filterStock());
    callbacks.add(this.filterSpan());
    callbacks.add(this.filterDate());
    callbacks.fire();
  }

  this.eventHandlers = function() {
    $('#select-status').change(this.filterAll.bind(this));
    $('#select-ticker').change(this.filterAll.bind(this));
    $('#select-expired-date').change(this.filterAll.bind(this));
    $('#select-max-span').change(this.filterAll.bind(this));
  }

}

filters = new FilterController();
filters.eventHandlers();

//other animations
$('#buy-stock-header').click(function(e) {
  $('#buy-stock-form').fadeToggle(300)
});

$('#sell-stock-header').click(function(e) {
  $('#sell-stock-form').fadeToggle(300)
});



});



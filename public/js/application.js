$(document).ready(function() {

function Portfolio () {
  this.transactions = [],
  this.sortedTransactions = function() {
    return this.transactions.sort(function(a, b) {return b.buyDatetime - a.buyDatetime} )
  },
  this.create_transactions = function(transactions_array) {
    var portfolio = this
    portfolio.transactions = [];
    $.each(transactions_array, function(index, t){
      portfolio.transactions.push(new Transaction(t.id, t.buyQuantity, t.buyPrice, t.buyDatetime, t.sellQuantity, t.sellPrice, t.sellDatetime, t.stockTicker, t.latestQuote, t.daysOpen, t.stockId, t.sellPrice, t.createdAt, t.updatedAt))
    })
  }
}

function Transaction(id, buyQuantity, buyPrice, buyDatetime, sellQuantity, sellPrice, sellDatetime, stockTicker, latestQuote, daysOpen, stockId, sellPrice, createdAt, updatedAt) {
  this.id = id,
  this.buyQuantity = buyQuantity,
  this.buyPrice = buyPrice,
  this.buyDatetime = new Date(buyDatetime),
  this.sellQuantity = sellQuantity,
  this.sellDatetime = new Date(sellDatetime),
  this.stockTicker = stockTicker,
  this.latestQuote = latestQuote,
  this.daysOpen = daysOpen,
  this.stockId = stockId,
  this.sellPrice = sellPrice,
  this.createdAt = new Date(createdAt),
  this.updatedAt = new Date(updatedAt)
}

Transaction.prototype = {
  availableStock: function() { return this.buyQuantity - this.sellQuantity },
  sold: function() { return this.availableStock() === 0 },
  status: function() {
    if (this.sold())
      return "SOLD"
    else
      return "OPEN"
  },
  initialAmount: function() { return this.buyQuantity * this.buyPrice },
  finalAmount: function() {
    if (this.sold()) { return this.sellQuantity * this.sellPrice }
    else { return this.buyQuantity * this.latestQuote }
  },
  profitOrLoss: function() { return this.finalAmount() - this.initialAmount() },
  profit: function() {
    if(this.profitOrLoss() >= 0)
      return "profit"
    else
      return "loss"
  },
  valuation: function()  { return (this.profitOrLoss() / this.initialAmount()) * 100 },
  validQuote: function() {
    if (this.sold())
      return this.sellPrice
    else
      return this.latestQuote
  },
  validSellDatetime: function() {
    if (Number(this.sellDatetime) > 0 )
      return this.sellDatetime
    else
      return ""
  },
  color: function() {
    if (this.sold())
      return "#eee"
    else
      return "#fff"
  }
}

function View () {
  this.dateFormatter = function(d) {
    if (d instanceof Date) {
      var curr_date = d.getDate();
      var curr_month = d.getMonth();
      var curr_year = d.getYear() - 100;
      return curr_month + "/" + curr_date + "/" + curr_year
    } else {
      return ""
    }
  },


  this.renderTable = function(rows){
    //debugger
    $('tbody').empty();
    $('#sell-form-options').empty();
    var dateFormatter = this.dateFormatter
    console.log(rows)
    $.each(rows, function(index, transaction){
      $('tbody').append("<tr style='background-color:" + transaction.color() +"' data-transaction-id='" + transaction.id + "' > <th data-status>" + transaction.status() + "</th> <td data-ticker>" + transaction.stockTicker +"</td> <td data-quantity>" + transaction.buyQuantity +"</td> <td data-buy-price>" + transaction.buyPrice.toFixed(2) + "</td> <td data-sell-price>" + transaction.validQuote().toFixed(2) + "</td> <td data-initial-amount>" + transaction.initialAmount().toFixed(2) + "</td> <td data-profit-loss class=" + transaction.profit() + ">" + transaction.profitOrLoss().toFixed(2) +"</td> <td data-profit-loss class=" + transaction.profit() + ">" + transaction.valuation().toFixed(2) +"%</td> <td data-buy-datetime>" + dateFormatter(transaction.buyDatetime) + "</td> <td data-sell-datetime>" + dateFormatter(transaction.validSellDatetime()) +"</td> <td data-days-open>" + transaction.daysOpen +"</td> </tr>")
      $('#sell-form-options').append("<option value='" + transaction.stockId + "'>" + transaction.stockTicker +"</option>")
    });
  }
}

function Controller (portfolio, view) {
  this.portfolio = portfolio,
  this.view = view,
  this.updateQuotes = function(data) {
    this.portfolio.create_transactions(data)
    console.log(this.portfolio.sortedTransactions())
    this.view.renderTable(this.portfolio.sortedTransactions())
  }
}

var portfolio = new Portfolio();
var view = new View();
var controller = new Controller(portfolio, view);
var graphController = new GraphController();
$.ajax({url: "/api/v1/quotes"}).done(function(res){
  controller.updateQuotes(res);
  graphController.parse();
  updateTweets();
  updateNews();
})

//ajax updates

$('#buy-form').submit(function(event){
  event.preventDefault();
  serializedForm = $(this).serialize();
  $.ajax({
    url: "/api/v1/buy",
    type: "post",
    data: serializedForm,
  }).done(function(response){
    console.log("Sucessfully added operation")
    controller.updateQuotes(response);
    graphController.parse();
    updateTweets();
    updateNews();
  }).fail(function(error){
    console.log("Unable to add operation")
  });
});

$('#sell-form').submit(function(event){
  event.preventDefault();
  serializedForm = $(this).serialize();
  console.log(serializedForm)
  $.ajax({
    url: "/api/v1/sell",
    type: "post",
    data: serializedForm,
  }).done(function(response){
    console.log("Sucessfully closed operation")
    controller.updateQuotes(response);
    graphController.parse();
    updateTweets();
    updateNews();
  }).fail(function(error){
    console.log("Unable to close operation")
  });
});

});

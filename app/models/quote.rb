class Quote < ActiveRecord::Base

  belongs_to :stock

  def export
    [stock.ticker, comparison_index, datetime.strftime("%m-%d-%Y")]
  end

end

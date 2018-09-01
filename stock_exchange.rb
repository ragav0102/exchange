require 'csv'
Dir['stock_exchange/*.rb'].each { |file| require_relative file }

class StockExchange
  CSV_COLUMN_NAMES = %w[StockId Side Company Quantity].freeze

  def run
    file_path = 'files/input.csv'
    executor = StockOrderExecutor.new
    CSV.foreach(file_path, headers: true) do |row|
      stock_id, side, company, quantity = row.values_at(*CSV_COLUMN_NAMES)
      stock_order = StockOrder.new(stock_id, side, company, quantity)
      executor.execute_order(stock_order)
    end
    ExecutorStateOutputter.new(executor).print
  end
end

StockExchange.new.run

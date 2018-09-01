class ExecutorStateOutputter
  attr_accessor :executor

  def initialize(executor)
    @executor = executor
  end

  def print
    p StockOrder::OUTPUT_KEYS
    executor.stock_orders.each do |stock_order|
      result = [stock_order.stock_id, stock_order.side,
                stock_order.company, stock_order.status,
                stock_order.quantity, stock_order.remaining_qty]
      p result
    end
  end
end

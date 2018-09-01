class StockOrderExecutor
  attr_accessor :stock_orders

  def initialize(stock_orders = [])
    @stock_orders = stock_orders
  end

  def execute_order(new_order)
    @stock_orders.each do |old_order|
      next unless can_execute(old_order, new_order)
      buy_order, sell_order = find_buy_sell_orders(old_order, new_order)
      StockOrder.update_stock_orders(buy_order, sell_order)
      break unless new_order.open?
    end
    @stock_orders << new_order
  end

  private

  def can_execute(old_order, new_order)
    old_order.open? && old_order.company == new_order.company &&
      old_order.side != new_order.side
  end

  def find_buy_sell_orders(old_order, new_order)
    new_order.buying? ? [new_order, old_order] : [old_order, new_order]
  end
end

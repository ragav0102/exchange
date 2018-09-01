class StockOrder
  attr_accessor :stock_id, :side, :company, :quantity, :status, :remaining_qty

  OPEN = 0
  CLOSED = 1
  BUY = 0
  SELL = 1

  OUTPUT_KEYS = %w[stock_id side company status quantity remaining_qty].freeze

  def initialize(id, side, company, quantity, status = OPEN)
    @stock_id = id
    @side = side.to_i
    @company = company
    @quantity = quantity.to_i
    @status = status.to_i
    @remaining_qty = quantity.to_i
  end

  def open?
    @status == OPEN
  end

  def buying?
    @side == BUY
  end

  def bought(buy_qty)
    return unless buying?
    @remaining_qty = buy_qty >= remaining_qty ? 0 : remaining_qty - buy_qty
    @status = CLOSED if remaining_qty.zero?
  end

  def sold(sell_qty)
    return if buying?
    @remaining_qty = sell_qty >= remaining_qty ? 0 : remaining_qty - sell_qty
    @status = CLOSED if remaining_qty.zero?
  end

  def self.update_stock_orders(buy_order, sell_order)
    return unless buy_order.buying? && !sell_order.buying?
    buy_qty = buy_order.remaining_qty
    sell_qty = sell_order.remaining_qty
    buy_order.bought(sell_qty)
    sell_order.sold(buy_qty)
  end
end

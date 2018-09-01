require_relative '../stock_exchange/stock_order_executor.rb'

describe StockOrderExecutor do
  describe '#execute_order' do
    before do
      @executor = StockOrderExecutor.new
      order1 = StockOrder.new(1, 1, 'ABC', 10)
      order2 = StockOrder.new(2, 0, 'XYZ', 15)
      @executor.execute_order(order1)
      @executor.execute_order(order2)
    end

    it 'should check the initial state of the executor' do
      expect(@executor.stock_orders.length).to eq(2)
    end

    it 'should accept a buy order add it to the list and check no match' do
      order = StockOrder.new(3, 0, 'PNB', 18)
      @executor.execute_order(order)
      expect(@executor.stock_orders.length).to eq(3)
      expect(order.remaining_qty).to eq(18)
    end

    it 'should accept a sell order and execute it' do
      order = StockOrder.new(4, 1, 'XYZ', 10)
      @executor.execute_order(order)
      expect(@executor.stock_orders[1].remaining_qty).to eq(5)
      expect(order.remaining_qty).to eq(0)
      expect(@executor.stock_orders.length).to eq(3)
    end
  end
end

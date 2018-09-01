require_relative '../stock_exchange/stock_order.rb'

describe StockOrder do
  describe '#open?' do
    it 'should return true for an open stock order' do
      order = StockOrder.new(1, 0, 'ANC', 5)
      expect(order.open?).to eq(true)
    end

    it 'should return false for an closed stock order' do
      closed = 1
      order = StockOrder.new(1, 0, 'ANC', 5, StockOrder::CLOSED)
      expect(order.open?).to eq(false)
    end
  end

  describe '#buying?' do
    it 'should return true for buy order' do
      order = StockOrder.new(1, StockOrder::BUY, 'ANC', 5)
      expect(order.buying?).to eq(true)
    end

    it 'should return false for a sell order' do
      order = StockOrder.new(1, StockOrder::SELL, 'ANC', 5)
      expect(order.buying?).to eq(false)
    end
  end

  describe '#bought' do
    before(:each) do
      @order = StockOrder.new(4, StockOrder::BUY, 'BNB', 10)
    end

    it 'should contain 5 remaining stocks after buying 5' do
      @order.bought(5)
      expect(@order.remaining_qty).to eq(5)
      expect(@order.status).to eq(StockOrder::OPEN)
    end

    it 'should contain 0 remaining stocks and status closed after buying 10' do
      @order.bought(10)
      expect(@order.remaining_qty).to eq(0)
      expect(@order.status).to eq(StockOrder::CLOSED)
    end

    it 'should contain 0 remaining stocks and status closed after buying 20' do
      @order.bought(20)
      expect(@order.remaining_qty).to eq(0)
      expect(@order.status).to eq(StockOrder::CLOSED)
    end

    it 'should return without changes if called for sell order' do
      @sell_order = StockOrder.new(5, StockOrder::SELL, 'BNB', 10)
      @sell_order.bought(10)
      expect(@sell_order.remaining_qty).to eq(10)
      expect(@sell_order.status).to eq(StockOrder::OPEN)
    end
  end

  describe '#sold' do
    before(:each) do
      @order = StockOrder.new(4, StockOrder::SELL, 'BNB', 10)
    end

    it 'should contain 5 remaining stocks after selling 5' do
      @order.sold(5)
      expect(@order.remaining_qty).to eq(5)
      expect(@order.status).to eq(StockOrder::OPEN)
    end

    it 'should contain 0 remaining stocks and status closed after selling 10' do
      @order.sold(10)
      expect(@order.remaining_qty).to eq(0)
      expect(@order.status).to eq(StockOrder::CLOSED)
    end

    it 'should contain 0 remaining stocks and status closed after selling 20' do
      @order.sold(20)
      expect(@order.remaining_qty).to eq(0)
      expect(@order.status).to eq(StockOrder::CLOSED)
    end

    it 'should return without changes if called for buy order' do
      @sell_order = StockOrder.new(6, StockOrder::BUY, 'BNB', 10)
      @sell_order.sold(10)
      expect(@sell_order.remaining_qty).to eq(10)
      expect(@sell_order.status).to eq(StockOrder::OPEN)
    end
  end

  describe'#update_stock_orders' do
    it 'should update remaining_qty and status for both the orders with same quantity' do
      @sell_order = StockOrder.new(6, StockOrder::SELL, 'BNB', 10)
      @buy_order = StockOrder.new(4, StockOrder::BUY, 'BNB', 10)
      StockOrder.update_stock_orders(@buy_order, @sell_order)
      expect(@buy_order.remaining_qty).to eq(0)
      expect(@buy_order.status).to eq(StockOrder::CLOSED)
      expect(@sell_order.remaining_qty).to eq(0)
      expect(@sell_order.status).to eq(StockOrder::CLOSED)
    end

    it 'should update remaining_qty and status for both the orders with higher sell quantity' do
      @sell_order = StockOrder.new(6, StockOrder::SELL, 'BNB', 20)
      @buy_order = StockOrder.new(4, StockOrder::BUY, 'BNB', 10)
      StockOrder.update_stock_orders(@buy_order, @sell_order)
      expect(@buy_order.remaining_qty).to eq(0)
      expect(@buy_order.status).to eq(StockOrder::CLOSED)
      expect(@sell_order.remaining_qty).to eq(10)
      expect(@sell_order.status).to eq(StockOrder::OPEN)
    end

    it 'should update remaining_qty and status for both the orders with higher buy quantity' do
      @sell_order = StockOrder.new(6, StockOrder::SELL, 'BNB', 10)
      @buy_order = StockOrder.new(4, StockOrder::BUY, 'BNB', 20)
      StockOrder.update_stock_orders(@buy_order, @sell_order)
      expect(@buy_order.remaining_qty).to eq(10)
      expect(@buy_order.status).to eq(StockOrder::OPEN)
      expect(@sell_order.remaining_qty).to eq(0)
      expect(@sell_order.status).to eq(StockOrder::CLOSED)
    end

    it 'should not work for wrong order sides' do
      @sell_order = StockOrder.new(6, StockOrder::SELL, 'BNB', 10)
      @buy_order = StockOrder.new(4, StockOrder::SELL, 'BNB', 20)
      StockOrder.update_stock_orders(@buy_order, @sell_order)
      expect(@buy_order.remaining_qty).to eq(20)
      expect(@buy_order.status).to eq(StockOrder::OPEN)
      expect(@sell_order.remaining_qty).to eq(10)
      expect(@sell_order.status).to eq(StockOrder::OPEN)
    end    
  end
end

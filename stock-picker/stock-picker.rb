## Stock Picker Project ##
#
# Implement a method #stock_picker that takes in an array of stock prices,
# one for each hypothetical day. It should return a pair of days
# representing the best day to buy and the best day to sell.
# Days start at 0.
#

def stockpicker(prices)
  return [] if prices.length < 2

  min_price = prices[0]
  min_day = 0
  max_profit = 0
  best_days = [0, 0]

  prices.each_with_index do |price, day|
    # Skip first day since we need a buy-sell pair
    next if day == 0

    # Update profit and days if current price gives better profit
    current_profit = price - min_price
    if current_profit > max_profit
      max_profit = current_profit
      best_days = [min_day, day]
    end

    # Update minimum price and day if we find a lower price
    if price < min_price
      min_price = price
      min_day = day
    end
  end

  best_days
end

# Test 1
prices = [17, 3, 6, 9, 15, 8, 6, 1, 10]
puts stock_picker(prices).inspect

# Test 2
prices = [5, 4, 3, 2, 1]
puts stock_picker(prices).inspect

# Test 3
prices = [1, 2, 3, 4, 5]
puts stock_picker(prices).inspect

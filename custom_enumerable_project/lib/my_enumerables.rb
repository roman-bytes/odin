module Enumerable
  # Iterates through each element, yielding it to the block
  def my_each
    return self unless block_given?

    for i in 0...length
      yield(self[i])
    end
    self
  end

  # Iterates through each element with its index, yielding both to the block
  def my_each_with_index
    return self unless block_given?

    for i in 0...length
      yield(self[i], i)
    end
    self
  end

  # Returns a new array with elements for which the block returns true
  def my_select
    return to_a unless block_given?

    result = []
    my_each { |item| result << item if yield(item) }
    result
  end

  # Returns true if all elements satisfy the block condition
  def my_all?
    return true unless block_given?

    my_each { |item| return false unless yield(item) }
    true
  end

  # Returns true if any element satisfies the block condition
  def my_any?
    return false unless block_given?

    my_each { |item| return true if yield(item) }
    false
  end

  # Returns true if no elements satisfy the block condition
  def my_none?
    return true unless block_given?

    my_each { |item| return false if yield(item) }
    true
  end

  # Returns the count of elements (with optional block condition)
  def my_count(arg = nil)
    if block_given?
      count = 0
      my_each { |item| count += 1 if yield(item) }
      count
    elsif arg.nil?
      length
    else
      my_count { |item| item == arg }
    end
  end

  # Returns a new array with the results of running the block for each element
  def my_map
    return to_a unless block_given?

    result = []
    my_each { |item| result << yield(item) }
    result
  end

  # Applies a block to accumulate a result across all elements
  def my_inject(initial = nil)
    return nil unless block_given?

    accumulator = initial.nil? ? first : initial
    initial.nil? ? 1 : 0

    my_each_with_index do |item, index|
      next if initial.nil? && index.zero?

      accumulator = yield(accumulator, item)
    end
    accumulator
  end
end

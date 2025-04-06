## Bubble Sorting ##

def bubble_sort(array)
  # Create a copy of the array to avoid modifying the original
  arr = array.dup
  n = arr.length

  # Outer loop for number of passes
  (n - 1).times do
    # Flag to optimize by checking if any swaps occurred
    swapped = false

    # Inner loop to compare adjacent elements
    # We subtract 1 because we compare i with i+1
    (0...(n - 1)).each do |i|
      # Compare adjacent elements
      next unless arr[i] > arr[i + 1]

      # Swap them if they're in wrong order
      arr[i], arr[i + 1] = arr[i + 1], arr[i]
      swapped = true
    end

    # If no swapping occurred, array is already sorted
    break unless swapped
  end

  arr
end

# Test cases
puts bubble_sort([4, 3, 78, 2, 0, 2]).inspect
# Expected output: [0, 2, 2, 3, 4, 78]

puts bubble_sort([1, 2, 3, 4, 5]).inspect
# Expected output: [1, 2, 3, 4, 5] (already sorted)

puts bubble_sort([5, 4, 3, 2, 1]).inspect
# Expected output: [1, 2, 3, 4, 5] (reverse order)

puts bubble_sort([]).inspect
# Expected output: [] (empty array)

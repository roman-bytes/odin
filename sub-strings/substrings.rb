def substrings(text, dictionary)
  # Convert text to lowercase and split into words if it's a phrase
  words = text.downcase.split

  # Initialize an empty hash with default value of 0
  result = Hash.new(0)

  # For each word in the text
  words.each do |word|
    # Check each dictionary entry against the current word
    dictionary.each do |substring|
      # Count occurrences of substring in the word
      # scan returns an array of all matches, length gives us the count
      count = word.scan(substring).length
      # Add to result hash if there are any matches
      result[substring] += count if count > 0
    end
  end

  result
end

# Test cases
dictionary = %w[below down go going horn how howdy
                it i low own part partner sit]

# Test 1: Single word
puts substrings('below', dictionary).inspect
# Expected output: {"below"=>1, "low"=>1}

# Test 2: Multiple words
puts substrings("Howdy partner, sit down! How's it going?", dictionary).inspect
# Expected output: {"down"=>1, "go"=>1, "going"=>1, "how"=>2, "howdy"=>1,
# "it"=>2, "i"=>3, "own"=>1, "part"=>1, "partner"=>1, "sit"=>1}

## TODO: Does this loop around?

def caesar_cipher(string, shift)
  # Loop through passed string,
  results = []
  alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
  charArray = string.chars
  
  # Loop through each charcter in passed string
  for s in charArray

    # Check for spaces or non-alpha numeric charcters
    # Push those to final results array as is.
    if !s.match?(/[A-Za-z]/)
      results.push(s)
      next
    end

    # Set charcter to lowercase and grab the index
    charIndex = alphabet.each_with_index.select { |c, _i| c == s.downcase }.map(&:last)
    
    # Grab the letter based on how much we shift
    shifted_letter = alphabet[charIndex[0] + shift]

    # Set the charcter to uppercase if it was
    shifted_letter = shifted_letter.upcase if s == s.upcase

    # Finally push to resulting array
    results.push(shifted_letter)
  end
  # Send results back all together
  results.join
end

puts caesar_cipher('Jacob is a cool person', 5)

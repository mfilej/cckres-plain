#!/usr/bin/env ruby
# Usage: count_verbs.rb <dict> <input>
#
# Count main verbs in input text.
#
#   dict  : dictionary of words with morphosyntactic tags
#   input : input file on which to perform the verb count
#
# Example using morphosyntactic dictionary included with this repo:
#
#   $ ./count_verbs.rb ../morphosyntax_dict.txt /path/to/input.txt

require "set"

abort "Usage: #$0 dict.txt text.txt" if ARGV.size != 2

dict, text = ARGV

verbs = Set.new
File.open(dict) do |f|
  f.each_line do |line|
    word, type = line.split(" ")
    if type[0, 2] == "Gg"
      verbs.add(word.downcase)
    end
  end
end

File.open(text) do |f|
  f.each_line do |line|
    count = line.split(" ").count { |word|
      verbs.include?(word)
    }
    puts count
  end
end

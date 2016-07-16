#!/usr/bin/env ruby
# Usage  multiple_categories.rb <category>
#
# Find instances of words that can belong to both <category> and other parts
# of speech.
#
# See http://nl.ijs.si/jos/msd/html-sl/msd.specs.html for an explanation on
# cateogries.
#
# Example:
#
#   Print verbs (G = glagol, which is Slovene for verb) that could also be
#   other parts of speech:
#
#   $ ./multiple_categories.rb G
#
require "set"

DICT = File.expand_path("../../morphosyntax_dict.txt", __FILE__)
CATEGORIES = %w[S G P R Z K D V L M O N]
category = ARGV[0]

unless CATEGORIES.include?(category)
  abort "Category must be one of: #{CATEGORIES.join(" ")}"
end

words = Hash.new { |h, k| h[k] = Set.new }

File.open(DICT) do |f|
  f.each_line do |line|
    word, tag = line.split
    words[word.downcase].add(tag[0])
  end
end

words.each do |(word, tags)|
  next unless tags.include?("G")

  if tags.size > 1
    puts "#{word}: #{tags.to_a.join(' ')}"
  end
end

# frozen_string_literal: true

require './linked_list.rb'

# class HashMap that is made of an Array of LinkedList
class HashMap
  attr_accessor :buckets, :load_factor

  def initialize
    @buckets = Array.new(3, nil)
    @load_factor = @buckets.filter { |bucket| !bucket.nil? }.length / @buckets.length.to_f
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code % buckets.length
  end
end

p HashMap.new.hash('ron')

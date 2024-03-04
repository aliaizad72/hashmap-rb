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

  def set(key, value)
    bucket_index = hash(key)

    if @buckets[bucket_index].nil?
      @buckets[bucket_index] = LinkedList.new
      @buckets[bucket_index].append(bucket_index)
      @buckets[bucket_index].append([key, value])
    elsif key_already_exist?(bucket_index, key)
      change_node_value(bucket_index, key, value)
    else
      @buckets[bucket_index].append([key, value])
    end
  end

  def key_already_exist?(index, key)
    linked_list = @buckets[index]
    cursor = linked_list.head.next_node
    until cursor.nil?
      return true if cursor.value[0] == key

      cursor = cursor.next_node
    end
    false
  end

  def change_node_value(index, key, value)
    linked_list = @buckets[index]
    cursor = linked_list.head.next_node
    cursor = cursor.next_node until cursor.value[0] == key
    cursor.value[1] = value
  end
end

hash = HashMap.new
hash.set('Jon', 'Snow')
hash.set('Aemon', 'Targaryen')
hash.set('Jon', 'Targaryen')
p hash.load_factor

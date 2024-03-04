# frozen_string_literal: true

require './linked_list.rb'

# class HashMap that is made of an Array of LinkedList
class HashMap
  attr_accessor :buckets, :load_factor

  def initialize
    @buckets = Array.new(4, nil)
  end

  def grow_buckets
    load_factor = @buckets.filter { |bucket| !bucket.nil? }.length / @buckets.length.to_f
    return if load_factor < 0.75

    new_buckets = Array.new(@buckets.length * 2, nil)

    @buckets.each do |linked_list|
      next if linked_list.nil?

      cursor = linked_list.head.next_node
      until cursor.nil?
        add(cursor.value[0], cursor.value[1], new_buckets)
        cursor = cursor.next_node
      end
    end

    @buckets = new_buckets
  end

  def hash(key, table_size)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code % table_size
  end

  def add(key, value, array)
    bucket_index = hash(key, array.length)

    if array[bucket_index].nil?
      array[bucket_index] = LinkedList.new
      array[bucket_index].append(bucket_index)
      array[bucket_index].append([key, value])
    elsif key_already_exist?(bucket_index, key)
      change_node_value(bucket_index, key, value)
    else
      array[bucket_index].append([key, value])
    end
  end

  def set(key, value)
    grow_buckets
    add(key, value, @buckets)
  end

  def get(key)
    bucket_index = hash(key, @buckets.length)
    find_node_with_key(bucket_index, key).value[1]
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
    find_node_with_key(index, key).value[1] = value
  end

  def find_node_with_key(index, key)
    linked_list = @buckets[index]
    cursor = linked_list.head.next_node
    cursor = cursor.next_node until cursor.value[0] == key
    cursor
  end
end

hash = HashMap.new
hash.set('Jeor', 'Mormont')
hash.set('Theon', 'Greyjoy')
p hash.get('Jeor')

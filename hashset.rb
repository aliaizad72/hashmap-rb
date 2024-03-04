# frozen_string_literal: true

require './linked_list.rb'

# class HashMap that is made of an Array of LinkedList
class HashSet
  attr_accessor :buckets, :load_factor

  def initialize
    @buckets = Array.new(4, nil)
  end

  def grow_buckets # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    load_factor = @buckets.filter { |bucket| !bucket.nil? }.length / @buckets.length.to_f
    return if load_factor < 0.75

    new_buckets = Array.new(@buckets.length * 2, nil)

    @buckets.each do |linked_list|
      next if linked_list.nil?

      cursor = linked_list.head
      until cursor.nil?
        add(cursor.value, new_buckets)
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

  def add(key, array)
    bucket_index = hash(key, array.length)

    if array[bucket_index].nil?
      array[bucket_index] = LinkedList.new
      array[bucket_index].append(key)
    elsif key_in_array?(bucket_index, key, array)
      nil
    else
      array[bucket_index].append(key)
    end
  end

  def set(key)
    grow_buckets
    add(key, @buckets)
  end

  def has?(key)
    bucket_index = hash(key, @buckets.length)
    key_in_array?(bucket_index, key, @buckets)
  end

  def remove(key)
    return unless has?(key)

    bucket_index = hash(key, @buckets.length)
    node = find_node_with_key(bucket_index, key)
    node_index = @buckets[bucket_index].find(node.value)
    @buckets[bucket_index].remove_at(node_index)
    node
  end

  def length
    i = 0
    @buckets.each do |linked_list|
      next if linked_list.nil?

      i += linked_list.size
    end
    i
  end

  def keys
    array = []
    @buckets.each do |linked_list|
      next if linked_list.nil?

      cursor = linked_list.head
      until cursor.nil?
        array.push(cursor.value)
        cursor = cursor.next_node
      end
    end
    array
  end

  def clear
    @buckets = Array.new(4, nil)
  end

  def key_in_array?(index, key, array)
    linked_list = array[index]
    cursor = linked_list.head

    until cursor.nil?
      return true if cursor.value == key

      cursor = cursor.next_node
    end
    false
  end

  def find_node_with_key(index, key)
    linked_list = @buckets[index]
    cursor = linked_list.head
    cursor = cursor.next_node until cursor.value == key
    cursor
  end

  def to_s
    str = ''
    @buckets.each_with_index do |linked_list, i|
      str += if linked_list.nil?
               "#{i}: nil\n"
             else
               "#{i}: #{linked_list}\n"
             end
    end
    str
  end
end

set = HashSet.new

# frozen_string_literal: true

# class LinkedList; contains the whole list
class LinkedList # rubocop:disable Metrics/ClassLength
  attr_accessor :head

  def initialize
    @head = nil
  end

  def traverse(location = nil)
    cursor = @head
    cursor = cursor.next_node until cursor.next_node == location
    cursor
  end

  def traverse_with_count(location = nil, start = 0)
    i = start
    cursor = @head
    until cursor.next_node == location
      cursor = cursor.next_node
      i += 1
    end
    i
  end

  def append(value)
    if head.nil?
      @head = Node.new(value)
    else
      tail.next_node = Node.new(value)
    end
  end

  def prepend(value)
    if head.nil?
      @head = Node.new(value)
    else
      new_node = Node.new(value)
      new_node.next_node = @head
      @head = new_node
    end
  end

  def size
    if head.nil?
      0
    else
      traverse_with_count(nil, 1)
    end
  end

  def tail
    if size == 0 # rubocop:disable Style/NumericPredicate
      nil
    elsif size == 1
      @head
    else
      traverse(nil)
    end
  end

  def at(index)
    case index
    when 0
      @head
    when -1
      tail
    else
      cursor = @head
      index.times { cursor = cursor.next_node }
      cursor
    end
  end

  def pop
    to_delete = tail
    new_tail = traverse(to_delete)
    new_tail.next_node = nil
  end

  def contains?(value)
    cursor = @head
    until cursor.nil?
      return true if cursor.value == value

      cursor = cursor.next_node
    end
    false
  end

  def find(value)
    i = 0
    cursor = @head
    until cursor.nil?
      return i if cursor.value == value

      cursor = cursor.next_node
      i += 1
    end
    nil
  end

  def to_s
    return 'nil' if size.zero?

    output = ''
    cursor = @head
    until cursor.nil?
      output += "( #{cursor.value} ) -> "
      cursor = cursor.next_node
      output += 'nil' if cursor.nil?
    end
    output
  end

  def insert_at(value, index) # rubocop:disable Metrics/MethodLength
    if index >= size || index < -1
      puts 'No such index'
      return
    end

    case index
    when 0
      prepend(value)
    when -1
      append(value)
    else
      new_node = Node.new(value)

      old_node = at(index)
      new_node_left_neighbor = at(index - 1)

      new_node_left_neighbor.next_node = new_node
      new_node.next_node = old_node
    end
  end

  def remove_at(index) # rubocop:disable Metrics/MethodLength
    if index >= size || index < -1
      puts 'No such index'
      return
    end

    case index
    when -1
      pop
    when 0
      new_head = @head.next_node
      @head.next_node = nil
      @head = new_head
    else
      to_delete = at(index)
      left_neighbor = at(index - 1)
      right_neighbor = at(index + 1)

      to_delete.next_node = nil
      left_neighbor.next_node = right_neighbor
    end
  end
end

# class Node that contains a value and a link
class Node
  attr_accessor :value, :next_node

  def initialize(value = nil, next_node = nil)
    @value = value
    @next_node = next_node
  end

  def to_s
    value
  end
end

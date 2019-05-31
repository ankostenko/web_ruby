# frozen_string_literal: true

class RequestHolder
  def initialize(requests = [])
    @requests = requests
  end

  def add(request)
    @requests.push(request)
  end

  def remove(index)
    @requests.delete_at(index.to_i)
  end

  def empty?
    @requests.empty?
  end

  def length
    @requests.length
  end

  def each
    @requests.each { |request| yield(request) }
  end

  def sort!
    @requests.sort! { |a, b| yield(a, b) }
  end

  def each_with_index
    @requests.each_with_index { |request, index| yield(request, index) }
  end
end

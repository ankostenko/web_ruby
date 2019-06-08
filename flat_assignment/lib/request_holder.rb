# frozen_string_literal: true

# redundant comment
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

  def each
    @requests.each { |request| yield(request) }
  end

  def sort!
    @requests.sort! { |a, b| yield(a, b) }
  end
end

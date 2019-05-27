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

  def each_with_index
    @requests.each_with_index { |request, index| yield(request, index) }
  end
end

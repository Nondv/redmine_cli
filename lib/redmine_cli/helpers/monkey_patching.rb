class String
  #
  # If string doesnt fit in `max_chars` then it will cut it and add '...'
  #
  def cut(max_chars)
    return self if size <= max_chars

    self[0...max_chars - 3] + '...'
  end

  def numeric?
    Integer(self)
  rescue
    false
  end
end

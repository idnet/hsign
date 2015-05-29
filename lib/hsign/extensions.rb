class Object
  def to_hsign_string_values
    to_s
  end
end

class Array
  def to_hsign_string_values
    map(&:to_hsign_string_values)
  end
end

class Hash
  def to_hsign_string_values
    other = dup
    other.each do |k, v|
      other[k] = v.to_hsign_string_values
    end
  end
end

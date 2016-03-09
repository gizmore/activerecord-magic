class String
  
  # Substring until
  def substr_to(to, default=nil)
    i = self.index(to)
    i ? self[0..i-1] : default
  end
  def substr_to!(to, default=''); replace(substr_to(to, default)); end
  def rsubstr_to(to, default=nil)
    i = self.rindex(to)
    i ? self[0..i-1] : default
  end
  def rsubstr_to!(to, default=''); replace(rsubstr_to(to, default)); end
  
  # Substring from
  def substr_from(from, default=nil)
    i = self.index(from)
    i ? self[i+from.length..-1] : default
  end
  def substr_from!(from, default=''); replace(substr_from(from, default)); end
  def rsubstr_from(from, default=nil)
    i = self.rindex(from)
    i ? self[i+from.length..-1] : default
  end
  def rsubstr_from!(from, default=''); replace(rsubstr_from(from, default)); end
  def substr!(start=0, stop=-1); replace(self[start..stop]); end
  
  # Nibble from a string
  # Example: s = "this:is:nibbled"; b = s.nibble!(':') # => s becomes "is:nibbled". b becomes "this"
  def nibble!(token)
    back = substr_to(token);
    replace(substr_from(token)) unless back.nil?
    back
  end
  
  
  # Trimming, lovely trimming
  TRIM ||= "\r\n\t "
  def trim(chars=TRIM); ltrim(chars).rtrim(chars); end
  def trim!(chars=TRIM); replace(trim(chars)); end
  def ltrim!(chars=TRIM); replace(ltrim(chars)); end
  def rtrim!(chars=TRIM); replace(rtrim(chars)); end

  def ltrim(chars=TRIM)
    i = 0
    while (i < self.length)
      break if chars.index(self[i]).nil?
      i += 1
    end
    self[i..-1]
  end
  
  def rtrim(chars=TRIM)
    i = self.length - 1
    while (i >= 0)
      break if chars.index(self[i]).nil?
      i -= 1
    end
    self[0..i]
  end

end

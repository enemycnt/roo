# return formatted version of money
class FormattedScan
  def initialize(format_code, value)
    @value = replace_parts(format_code, value)
  end

  def to_s
    @value
  end

  # Quick lexical analys
  def replace_parts(format_code, value)

    # clear from backslashes
    if format_code.match(/\\/)
      format_code.gsub!(/\\/, '')
    end
    
    # insert single national money symbol (¥)
    if format_code.match(/\[\$(\W)\-.+?\]/)
      format_code.sub!(/\[\$(.).+?\]/, '\1')
    end

    # insert number with rounding
    if format_code.match(/\#,\#\#(0.\d+|0+|0$|)/)
      val = get_num(format_code, value)
      val = val.to_s.sub!('.',',') if val.is_a?(Float)
      format_code.sub!(/\#,\#\#(0.\d+|0+|0$|)/, val.to_s)
    end

    # insert national currency code or other 
    if format_code.match(/\"([[:word:]$]+)\"/)
      format_code.sub!(/\"([[:word:]$]+)\"/, '\1')
    end

    format_code
  end

  def get_num(format_code, value)
    if format_code.match(/\#\,\#\#(\d)\./)
      rounded_num(format_code, value)
    else
      value.round(0).to_i
    end
  end

  def rounded_num(raw_format, value)
    prec = raw_format.split(/0\.(\d+)/)[1].size.to_i
    value.round(prec)
  end

end
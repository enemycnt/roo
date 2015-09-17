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

    # # Percent hack
    if format_code.match(/\d%$/)
      val = get_percent(format_code, value)
      # puts val.inspect
      format_code = format_code.sub(/^(0.\d+|0+|0$|)/, val.to_s)
    end

    # clear from backslashes
    if format_code.match(/\\/)
      format_code.gsub!(/\\/, '')
    end

    # clear "red"
    if format_code.match(/;\[Red\].+$/)
      format_code.sub!(/;\[Red\].+$/, '')
    end

    
    # insert single national money symbol (¥)
    if format_code.match(/\[\$(\W)\-.+?\]/)
      format_code.sub!(/\[\$(.).+?\]/, '\1')
    end

    # insert number with rounding
    if format_code.match(/\#,\#\#(0.\d+|0+|0$|)/)
      val = get_num(format_code, value)
      format_code.sub!(/\#,\#\#(0.\d+|0+|0$|)/, val.to_s)
    end

    # insert national currency code or other 
    if format_code.match(/\"([[:word:]$]+)\"/)
      format_code.sub!(/\"([[:word:]$]+)\"/, '\1')
    end

    if value < 0
      format_code = format_code.prepend('-')
    end

    format_code
  end

  def get_num(format_code, value)
    if format_code.match(/\#\,\#\#(\d)\./)
      rounded_num(format_code, value.abs)
    else
      value.abs.round(0).to_i
    end
  end

  def get_percent(format_code, value)
    value = value * 100
    if format_code.match(/^(\d)\./)
      rounded_num(format_code, value.abs)
    else
      value.abs.round(0).to_i
    end
  end

  def rounded_num(raw_format, value)
    prec = raw_format.split(/0\.(\d+)/)[1].size.to_i
    value.round(prec)
  end

end
class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    if !valid_title(record.title)
      record.errors.add(:density, "has invalid title")
    end
  end

  def valid_title(title)
    elements = search_for_braces(title)
    is_valid?(elements)
  end

  def is_valid?(elements)
    check_braces = { "{" => "}", "[" => "]", "(" => ")" }

    return false if !elements || elements.size % 2 != 0
    check_braces.each do |k, v|
      brace_start = elements[k]
      brace_end = elements[v]

      next if brace_start.blank? && brace_end.blank?
      return false if !(brace_start && brace_end) || !((brace_end - brace_start) > 1)
    end
  end

  def search_for_braces(title)
    braces = ["{", "}", "[", "]", "(", ")"]
    elements = {}

    title.chars.each_with_index do |char, i|
      if braces.include?(char)
        return false if elements[char]
        elements[char] = i
      end
    end

    elements
  end
end

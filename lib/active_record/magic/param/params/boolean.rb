module ActiveRecord::Magic
  class Param::Boolean < Parameter
    
    def on_labels;  ['1', 'on', 'yes', 'true',  true_label.downcase]; end
    def off_labels; ['0', 'off','no',  'false', false_label.downcase]; end

    def true_label; t(:boolean_true); end
    def false_label; t(:boolean_false); end
    
    def display_example; "#{true_label}|#{false_label}"; end
    
    def input_to_value(label)
      label = label.to_s.downcase
      return true if on_labels.include?(label)
      return false if off_labels.include?(label)
      invalid!(:err_unknown_input)
    end

    def value_to_input(value)
      case value; when true; '1'; when false; '0'; else; invalid!(:err_unknown_input); end
    end
    
  end
end
module MembersHelper
    def format_change(change, unit)
        return content_tag(:span, "N/A", class: "text-muted") if change.nil?
    
        sign = change.positive? ? '+' : ''
        css_class = change.positive? ? 'text-green' : 'text-red'
        content_tag(:span, "(#{sign}#{change.round(1)}#{unit})", class: css_class)
      end
end

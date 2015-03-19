def link_to(label, url)
  "<a href=\"#{url}\">#{label}</a>"
end

def button_to(name, options, html_options)
  "<form action=\"#{options}\" method=\"POST\"><input type=\"hidden\" name=\"_method\" value=\"#{html_options[:method]}\"><input type=\"submit\" value=\"#{name}\"></form>"
end

module ApplicationHelper
  
  #display title on every pages
  def full_title page_title
  	base_title = 'MathPedia'
  	page_title = 'Olympiad Training' if page_title.empty?

  	"#{base_title} | #{page_title}"
  end

  #highlight current page  
  def is_active?(link_path)
  	current_page?(link_path) ? "active" : nil
  end

end

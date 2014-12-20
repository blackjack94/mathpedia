module ApplicationHelper
  
  #display titles on every pages
  def full_title page_title
  	base_title = 'MathPedia'
  	page_title = 'Olympiad Training' if page_title.empty?

  	"#{base_title} | #{page_title}"
  end

  #highlight current page
  def is_active(controller, action)
  	params[:action] == action && params[:controller] == controller ? "active" : nil
  end

end

module ApplicationHelper
  
  #display titles on every pages
  def full_title page_title
  	base_title = 'MathPedia'

  	if page_title.empty?
  	  page_title = 'Ideas in Olympiads'
  	end

  	"#{base_title} | #{page_title}"
  end

  #highlight current page
  def is_active(controller, action)
  	params[:action] == action && params[:controller] == controller ? "active" : nil
  end

end

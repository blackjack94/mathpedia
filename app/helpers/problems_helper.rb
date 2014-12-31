module ProblemsHelper

	def color_for title
		views = ['solution', 'master']

		if views.include?(params[:view])
			if title == params[:view]
				'primary'
			else
				'muted'
			end
		else
			if title == 'statement'
				'primary'
			else
				'muted'
			end
		end
	end

end

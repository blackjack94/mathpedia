module UsersHelper

	def title_for user
		if user.master?
			'Master'
		else
			'Newbie'
		end
	end

end

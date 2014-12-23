module UsersHelper

	def title_for user
		user.master? ? 'Master' : 'Newbie'
	end

	def action_links_for(filter, user)
		if user.master? && filter != 'master'
			return "MASTER Here!"
		else
			red_action, red_title, green_action, green_title =
			{ 'pending' => ['delete', 'XOÁ yêu cầu', 'approve', 'CHẤP NHẬN yêu cầu'],
				'approved' => ['block', 'KHÓA', 'promote', 'THĂNG CẤP'],
				'blocked' => ['delete', 'XOÁ', 'unblock', 'MỞ KHÓA'],
				'master' => ['demote', 'GIẢM CẤP'] }[filter]

			red_path = status_path(id: user.id, change: red_action, back: params[:status])
			result = "#{link_to red_title, red_path, method: :patch, class: 'btn btn-danger btn-sm', id: 'red-link'}"

			unless filter == 'master'
				green_path = status_path(id: user.id, change: green_action, back: params[:status])
				result += "#{link_to green_title, green_path, method: :patch, class: 'btn btn-success btn-sm', id: 'green-link'}" 
			end

			return result
		end
	end

end

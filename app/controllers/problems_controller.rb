class ProblemsController < ApplicationController

	before_action :must_signed_in, only: [:new, :create, :edit, :update, :destroy]
	before_action :must_be_master, only: [:new, :create, :edit, :update, :destroy]
	before_action :get_problem, only: [:show, :edit, :update, :destroy]

	def new
		@problem = Problem.new
		@difficulties = Problem.difficulties
		@domains = Domain.all.to_a
	end

	def create
		params[:problem][:difficulty]	= params[:problem][:difficulty].to_i
		@problem = current_user.problems.new(problem_params)		
		
		if @problem.save
			flash[:success] = "THANKS FOR SHARING!"
			redirect_to problem_path(@problem)
		else
			@difficulties = Problem.difficulties
			@domains = Domain.all.to_a
			render :new
		end
	end

	def show
		@domain = @problem.domain
		@author = @problem.author
	end

	def edit
	end

	def update
		if @problem.update_attributes(problem_params)
			flash[:success] = "Cập nhật thành công!"
			redirect_to problem_path(@problem)
		else
			render :edit
		end
	end

	def destroy
		@problem.destroy
		flash[:success] = 'Problem deleted!'
    redirect_to root_path
	end

	private
		def problem_params
			params.require(:problem).permit(:title, :statement, :solution, :difficulty, :domain_id, :status)
		end

		def get_problem
			@problem = Problem.find(params[:id])
		end

end

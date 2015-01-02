class ProblemsController < ApplicationController

	before_action :must_signed_in, only: [:new, :create, :edit, :update, :destroy]
	before_action :must_be_master, only: [:new, :create, :edit, :update, :destroy]
	before_action :get_problem, only: [:show, :edit, :update, :destroy]

	def index
		if params[:status]
			unless ['draft', 'ready', 'online'].include?(params[:status]) && is_master?
				flash[:info] = "Trang này không tồn tại!"
				redirect_to problems_path
			else
				@problems = Problem.try(params[:status]).paginate(page: params[:page], per_page: 9).includes(:author).includes(:domain)
			end
		else
			@problems = Problem.filter(params[:domain], params[:difficulty]).paginate(page: params[:page], per_page: 9).includes(:author).includes(:domain)	
		end
		
		@domains = Domain.all
		@difficulties = {"all" => "3"}.merge(Problem.difficulties)
	end

	def new
		@problem = Problem.new
		@difficulties = Problem.options_for(:difficulties)
		@domains = Domain.all.to_a
	end

	def create
		@problem = current_user.problems.build(problem_params)		
		
		if @problem.save
			flash[:success] = "THANKS FOR SHARING!"
			redirect_to problem_path(@problem)
		else
			@difficulties = Problem.options_for(:difficulties)
			@domains = Domain.all.to_a
			render :new
		end
	end

	def show
		@domain = @problem.domain
		@author = @problem.author
		@id = @problem.id
		
		template = { 'solution' => 'show_solution' }[params[:view]]
		template = 'show' if template.nil?
		render template
	end

	def edit
		get_info if params[:view] == 'master'

		template = { 'solution' => 'edit_solution', 'master' => 'edit_master' }[params[:view]]
		template = 'edit' if template.nil?
		render template
	end

	def update
		template, path = { 'solution' => ['edit_solution', problem_path(id: @problem.id, view: 'solution')],
											 'master' => ['edit_master'] }[params[:view]]
		template = 'edit' if template.nil?
		path = problem_path(@problem) if path.nil?

		if @problem.update_attributes(problem_params)
			flash[:success] = "Cập nhật thành công!"
			redirect_to path
		else
			get_info if params[:view] == 'master'
			render template
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

		def get_info
			@difficulties = Problem.options_for(:difficulties)
			@domains = Domain.all.to_a
			@statuses = Problem.options_for(:statuses)
			@id = @problem.id
		end

end

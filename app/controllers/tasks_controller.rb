class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :toggle]
  before_filter :find_card, :only => [:index]

  # GET /tasks
  # GET /tasks.json
  def index
  	@tasks = Task.overdue if params[:overdue].present?
  	@tasks = Task.upcoming if params[:upcoming].present?
  	@tasks = Task.incomplete if params[:incomplete].present?
  	@tasks = Task.today if params[:today].present?
    @tasks = Task.every if params[:all].present?
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.save
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_path(@task), notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

	def toggle 
		@task.toggle!(:completed)
		render :text => "success" 
	end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.fetch(:task, {}).permit(:name, :notes, :task_type, :due_date, :completed, :card_id, :subline, :user_id)
    end

    def find_card
      unless params[:card_id].blank?
        @card = Card.find(params[:card_id])
      end
  end
end

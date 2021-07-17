class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all.order(created_at: :desc)
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    if params[:redirection_happens].blank?
      redirect_to new_todo_path(redirection_happens: true)
    end
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
    if params[:redirection_happens].blank?
      redirect_to edit_todo_path(params[:id], redirection_happens: true)
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    if @todo.save
      notice = 'Todo was successfully created.'
      render turbo_stream: turbo_stream.append('todos', @todo)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    notice = 'Todo was successfully updated.'
    if @todo.update(todo_params)
      render @todo
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy
    notice = 'Todo was successfully destroyed.'
    render turbo_stream: turbo_stream.remove("todo-frame-#{ @todo.id}")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:title, :completed)
    end
end

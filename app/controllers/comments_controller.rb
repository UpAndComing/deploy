class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location

  def new
    @location = Location.new
    @comment = @location.comments.new
  end

  def create
    @comment = @location.comments.build(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    if @comment.save
      respond_to do |format|
        format.html { redirect_to @location }
        format.js
      end
    else
      redirect_to @location
      flash[:error] = "You cannot submit blank data"
    end
  end

  def edit
    @comment = @location.comments.find(params[:id])
  end

  def update
      @comment = @location.comments.find(params[:id])
      if @comment.user_id == current_user.id
        @comment.update(comment_params)
          redirect_to @plocation
      else
        redirect_to @location
        flash[:alert] = "You are not the correct user"
      end
  end

  def destroy
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_location
      @location = Location.find(params[:location_id])
    end

end

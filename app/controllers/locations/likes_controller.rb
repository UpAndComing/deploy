class Locations::LikesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_location

	def create
		@location.likes.where(user_id: current_user.id).first_or_create
		respond_to do |format|
			format.html {redirect_to @location}
			format.js
		end
	end

	def destroy
		@location.likes.where(user_id: current_user.id).destroy_all
		respond_to do |format|
			format.html {redirect_to @location}
			format.js
		end
	end

	private

	def set_location
		@location = Location.find(params[:location_id])
	end
end
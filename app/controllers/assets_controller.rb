class AssetsController < ApplicationController

	before_action :must_signed_in, only: [:create, :destroy]

	def create
		asset = Asset.new(image: params[:file])
	  asset.save
	  render json: asset.image.url(:original)
	end

	def destroy
		asset = Asset.find(params[:id])
		asset.destroy
		render nothing: true
	end

end

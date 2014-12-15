class StaticPagesController < ApplicationController
  def home
    fresh_when "static_home"
  end

  def training
    fresh_when "static_training"
  end

  def library
    fresh_when "static_library"
  end

  def about
    fresh_when "static_about"
  end
end

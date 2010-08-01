class ApplicationController < ActionController::Base
  #protect_from_forgery
  layout 'application'
  
  def paginate( model, options = {} )
    load_page
    model.paginate( { :page => @page, :per_page => @per_page }.merge(options) )
  end

  def load_page
    @page = params[:page] || '1'
    @per_page = params[:per_page].to_i
    if @per_page < 1 || @per_page > 10
      @per_page = 10
    end
  end
end

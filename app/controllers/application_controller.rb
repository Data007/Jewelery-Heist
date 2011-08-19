class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

private

  def current_user
    return nil unless session[:user_id]
    begin
      @current_user = User.find(session[:user_id])
    rescue; end
  end

  require 'will_paginate/collection'
  Array.class_eval do
    def paginate(options = {})
      raise ArgumentError, "parameter hash expected (got #{options.inspect})" unless Hash === options

      WillPaginate::Collection.create(
          options[:page] || 1,
          options[:per_page] || 30,
          options[:total_entries] || self.length
      ) { |pager|
        pager.replace self[pager.offset, pager.per_page].to_a
      }
    end
  end
end

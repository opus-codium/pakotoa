# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  around_action :apply_user_preferences

  def add_breadcrumb(title, url)
    @breadcrumb ||= []
    title = if title.is_a?(Symbol)
      send(title)
    else
      I18n.t(title)
    end
    if url.is_a?(Array)
      method, *args = url
      args.collect! { |arg| instance_variable_get(arg) }
      params = [method] + args
      url = send(*params)
    end
    @breadcrumb << [title, url]
  end

  def self.add_breadcrumb(title, url, options = {})
    before_action options do |controller|
      controller.send(:add_breadcrumb, title, url)
    end
  end

  def certificate_authority_title
    @certificate_authority.subject
  end

  def policy_title
    @policy.name
  end

  def apply_user_preferences
    if user_signed_in?
      Time.zone = current_user.time_zone
      # I18n.locale = current_user.locale
    end
    yield
  ensure
    Time.zone = Time.zone_default
    # I18n.locale = I18n.default_locale
  end
end

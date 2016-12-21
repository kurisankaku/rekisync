# Appliction controller.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  # Set locale.
  def set_locale
    I18n.locale = locale
    ActionMailer::Base.default_url_options[:locale] = locale
  end

  # Fetch locale.
  def locale
    @locale ||= params[:locale] || I18n.default_locale
  end

  # Default url options for rails url helpler.
  def default_url_options(options={})
    options.merge(locale: locale)
  end
end

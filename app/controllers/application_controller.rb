class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # before_action :set_currency
  before_action :check_is_profile_filled

  protect_from_forgery
  # layout Proc.new { |controller| controller.request.xhr? ? false : 'main'}

  protected
  # def set_currency
  #   if params[:currency]
  #     MoneyRails.default_currency = params[:currency]
  #     current_user.update_attribute(:preferred_currency, params[:currency]) if user_signed_in?
  #   end
  # end

  #redefine default devise methods
  def after_sign_in_path_for(resource_or_scope)
    if !resource_or_scope.is_a?(AdminUser) && current_user.preferred_currency
      MoneyRails.default_currency = current_user.preferred_currency
    end
    super
  end

  def stored_location_for(resource_or_scope)
    resource_or_scope.is_a?(AdminUser) ? super : nil
  end

  def check_is_profile_filled
    if current_user && !current_user.profile_filled?
      unless flash[:notice].to_s.match(/#{t(:"notice.fill_profile")}/)
        flash[:notice] = (flash[:notice] ? "#{flash[:notice]}<br/>" : '') + t(:"notice.fill_profile")
      end

      if !self.is_a?(RegistrationsController) && !request.fullpath.match(/sign_out/)
        redirect_to(edit_user_registration_path)
      end
    end
  end
end

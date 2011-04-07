#this code taken from https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation

class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter(:authenticate_user!)
  # PUT /resource/confirmation
  def update
    with_unconfirmed_confirmable do
      @confirmable.update_attributes(params[:user]) #update all their attributes, including password & profile info
      if @confirmable.valid?
        do_confirm
      else
        do_show
        @confirmable.errors.clear #so that we wont render :new
      end
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    with_unconfirmed_confirmable do
      if @confirmable.valid?
        do_confirm
      else
        do_show
      end
    end
    if !@confirmable.errors.empty?
      render_with_scope :new
    end
  end
  
  protected
  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    @confirmable.attributes = params[:user]
    if !@confirmable.new_record? && !@confirmable.confirmed?
      yield
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render_with_scope :show
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
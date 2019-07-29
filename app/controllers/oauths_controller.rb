class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def disconnect
    logout
    redirect_to root_path
  end

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if login_from(provider)
      redirect_to root_path
      return
    end

    create_from(provider) do |user, failure|
      if !user.valid?
        flash[:error] = user.errors.messages.values.join("\n")
        user.destroy
        redirect_to root_path
        return
      end
      if failure
        flash[:error] = "Impossible de se connecter via #{provider.titleize}!\n #{failure.inspect}"
        redirect_to root_path
        return
      end

      reset_session # protect from session fixation attack
      auto_login(user)
      redirect_to root_path
    end
  end

  # To be used in dev mode only
  def autologin
    user = User.find_or_create_by(name: 'The Dev', email: 'the.dev@documents.fr')
    auto_login(user)

    redirect_to root_path
  end
end

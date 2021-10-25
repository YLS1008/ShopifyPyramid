class InviteMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.invite.subject
  #
  def invite(email)
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

require 'mailgun'

module MailGun

  def send_password_token(email, token)
    RestClient.post "https://api:#{ENV['MAILGUN_API_KEY']}"\
    "@api.mailgun.net/v2/sandbox1f0bcbc4fcac405e903ba276916ba2b8.mailgun.org",
    from: "Bookmark Manager Team <postmaster@sandbox1f0bcbc4fcac405e903ba276916ba2b8.mailgun.org>",
    to: email,
    subject: "Reset your password",
    text: "Hey #{email},
           You requested to reset your password. Please follow this link:
           http://localhost:9292/users/reset_password#{token}

           All the best,

           Bookmark Manager Team"
  end

end

API_KEY = ENV['MAILGUN_API_KEY']
LOGIN   = ENV['MAILGUN_SMTP_LOGIN'].split('@')[1]
#API_URL = "https://api:#{API_KEY}@api.mailgun.net/v2/sandbox1f0bcbc4fcac405e903ba276916ba2b8.mailgun.org/messages"

def send_password_token(email, token)
  RestClient.post "https://api:#{API_KEY}@api.mailgun.net/v2/#{LOGIN}/messages",

  from:    "Bookmark Manager Team <me@samples.mailgun.org>",
  to:      email,
  subject: "Reset your password",
  text:    "Hey #{email},

You requested to reset your password.

Please use the following link:

http://localhost:9292/users/reset_password/#{token}
(this link will expire in one (1) hour)


All the best,

Bookmark Manager Team"

end

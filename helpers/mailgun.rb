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

https://ruthsbmmanager.herokuapp.com/users/reset_password/#{token}


All the best,

Bookmark Manager Team

Please note: the link will expire in one hour.
  "



end

require 'gmail'
 
gmail = Gmail.new('example@gmail.com', 'password')
mail_count = gmail.inbox.count(:unread)
puts mail_count == 0 ? "No mail" : "Mail: #{mail_count}"

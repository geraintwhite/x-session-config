require 'gmail'
 
gmail = Gmail.new('geraintwhite@gmail.com', 'shxtlfxfikhcwbje')
mail_count = gmail.inbox.count(:unread)
puts mail_count == 0 ? "No mail" : "Mail: #{mail_count}"
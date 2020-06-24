class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere

  routing /reply-(.+)@reply.example.com/i => :replies 
end

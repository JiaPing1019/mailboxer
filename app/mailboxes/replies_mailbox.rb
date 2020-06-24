class RepliesMailbox < ApplicationMailbox
  MATCHER = /reply-(.+)@reply.example.com/i
  # mail => Mail object
  # inbound_email => ActionMailbox::InboundEmail record
  # before_processing :ensure_user

  def process
    return if user.nil?

    discussion.comments.create(
      user: user,
      body: mail.decoded
    )
  end

  # Load the user email records from the DB
  def user
    @user ||= User.find_by(email: mail.from)
  end

  def discussion
    @discussion ||= Discussion.find(discussion_id)
  end

  def discussion_id
    recipient = mail.recipients.find{ |r| MATCHER.macth?(r) }
    recipient[MATCHER, 1]
  end

  def ensure_user
    if user.nil?
      bounce_with UserMailer.missing(inbound_email)
    end
  end
end

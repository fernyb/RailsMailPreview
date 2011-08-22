#
#  Message.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#
require 'base64'

class Message < FBDatabaseBase
  field :id,  :type => 'Integer'
  field :from
  field :subject
  field :date
  field :to
  field :cc
  field :reply_to
  field :html
  field :text
  field :timestamp
  has_many :attachments

  def setMessage(mail)
    self.from    = mail.from.to_a.join(" ,")
    self.to      = mail.to.to_a.join(", ")
    self.cc      = mail.cc.to_a.join(", ")
    self.subject = mail.subject.to_s
    self.date    = mail.date.to_s
    self.html    = mail.html_part.body.to_s
    self.text    = mail.text_part.body.to_s

    mail.attachments.each do |attch|
      attachment = Attachment.new
      attachment.filename  = attch.filename
      attachment.mime_type = attch.mime_type
      attachment.data      = attch.body.to_s
      self.attachments << attachment
    end
  end
end

#
#  Message.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

class Message < FBDatabaseBase
  field :id
  field :from
  field :subject
  field :date
  field :to
  field :cc
  field :reply_to
  field :html
  field :text

  def setMessage(mail)
    self.from    = mail.from.to_a.join(" ,")
    self.to      = mail.to.to_a.join(", ")
    self.cc      = mail.cc.to_a.join(", ")
    self.subject = mail.subject.to_s
    self.date    = mail.date.to_s
    self.html    = mail.html_part.body.to_s
    self.text    = mail.text_part.body.to_s
  end
end

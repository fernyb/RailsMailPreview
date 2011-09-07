#
#  ParseMailMessageOperation.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 9/6/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#


class ParseMailMessageOperation < NSOperation
  attr_accessor :message
  attr_accessor :controller

  def initWithMessage(msg)
    self.init
    self.message = msg
    self
  end

  def main
    self.controller.performSelectorOnMainThread(:"didBeginSaveOperation", withObject:nil, waitUntilDone:YES)

    begin
      mail = Mail.new(self.message)
      message = Message.new
      message.setMessage(mail)
      if message.save
        NSLog("*** Message Saved")
      else
        NSLog("*** Mesage did not save")
      end
    rescue Exception => e
      NSLog("* Caught Exception: #{e}")
    end

    self.controller.performSelectorOnMainThread(:"didCompleteSaveOperation", withObject:nil, waitUntilDone:YES)
  end
end

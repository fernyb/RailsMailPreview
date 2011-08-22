#
#  Attachment.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#
require "#{RESOURCE_PATH}/FBDatabaseBase.rb"

class Attachment < FBDatabaseBase
  field :id,         :type => 'Integer'
  field :message_id, :type => 'Integer'
  field :filename
  field :mime_type
  field :data,      :on_save => :on_save
  field :timestamp
  belongs_to :message

  def on_save
    Base64.encode64(self.data)
  end
end

#
#  Attachment.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/20/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

if File.exists?("#{RESOURCE_PATH}/FBDatabaseBase.rb")
require "#{RESOURCE_PATH}/FBDatabaseBase.rb"
elsif File.exists?("#{RESOURCE_PATH}/FBDatabaseBase.rbo")
require "#{RESOURCE_PATH}/FBDatabaseBase.rbo"
end

class Attachment < FBDatabaseBase
  field :id,         :type => 'Integer'
  field :message_id, :type => 'Integer'
  field :filename
  field :mime_type
  field :data,      :on_save => :on_save
  field :disposition
  field :timestamp
  belongs_to :message

  def on_save
    Base64.encode64(self.data)
  end
end

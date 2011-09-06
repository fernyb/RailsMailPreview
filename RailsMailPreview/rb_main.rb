#
#  rb_main.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/12/11.
#  Copyright (c) 2011 Fernando Barajas. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'
framework 'Webkit'
framework 'QuickLook'

require 'rubygems'
require 'mail'
require 'mail/fields/unstructured_field'
require 'mail/fields/structured_field'
require 'mail/fields/optional_field'
require 'mail/fields/bcc_field'
require 'mail/fields/cc_field'
require 'mail/fields/comments_field'
require 'mail/fields/content_description_field'
require 'mail/fields/content_disposition_field'
require 'mail/fields/content_id_field'
require 'mail/fields/content_location_field'
require 'mail/fields/content_transfer_encoding_field'
require 'mail/fields/content_type_field'
require 'mail/fields/date_field'
require 'mail/fields/from_field'
require 'mail/fields/in_reply_to_field'
require 'mail/fields/keywords_field'
require 'mail/fields/message_id_field'
require 'mail/fields/mime_version_field'
require 'mail/fields/received_field'
require 'mail/fields/references_field'
require 'mail/fields/reply_to_field'
require 'mail/fields/resent_bcc_field'
require 'mail/fields/resent_cc_field'
require 'mail/fields/resent_date_field'
require 'mail/fields/resent_from_field'
require 'mail/fields/resent_message_id_field'
require 'mail/fields/resent_sender_field'
require 'mail/fields/resent_to_field'
require 'mail/fields/return_path_field'
require 'mail/fields/sender_field'
require 'mail/fields/subject_field'
require 'mail/fields/to_field'



require 'sqlite3'
require 'erb'
require 'base64'
require 'time'

YES = true
NO  = false

SUPPORT_DIR = "~/Library/Application Support/RailsMailPreview".stringByExpandingTildeInPath
ATTACHMENTS_DIR = "#{SUPPORT_DIR}/attachments"


# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
RESOURCE_PATH = dir_path

Dir.glob(File.join(dir_path, '*.bridgesupport')).uniq.each do |path|
  load_bridge_support_file(path)
end

Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

FBDatabaseBase.create_support_path

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)

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

require 'rubygems'
require 'mail'
require 'sqlite3'
require 'cgi'

YES = true
NO  = false

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    require(path)
  end
end

FBDatabaseBase.create_support_path

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)

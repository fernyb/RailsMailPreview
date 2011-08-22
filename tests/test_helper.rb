CURRENT_PATH = File.dirname(__FILE__)
RESOURCE_PATH = "#{CURRENT_PATH}/../RailsMailPreview"

framework 'Cocoa'

require 'rubygems'
require 'mocha'
require 'cgi'
require 'sqlite3'
require 'mail'
require "#{RESOURCE_PATH}/FBDatabaseBase.rb"
require "#{RESOURCE_PATH}/Message.rb"
require "#{RESOURCE_PATH}/Attachment.rb"
YES = true
NO = false

gem 'minitest'
require 'minitest/autorun'

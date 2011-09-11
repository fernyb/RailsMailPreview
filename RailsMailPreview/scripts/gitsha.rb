#!/usr/bin/env ruby
require "rubygems"
require "plist"

plist = Plist::parse_xml(ENV['BUILT_PRODUCTS_DIR'] + "/" + ENV['WRAPPER_NAME'] + "/Contents/Info.plist")
gitsha = `git log -n 1 --oneline`.split(/\s/).first.strip

plist["CFBundleVersion"] = gitsha

plist.save_plist(ENV['BUILT_PRODUCTS_DIR'] + "/" + ENV['WRAPPER_NAME'] + "/Contents/Info.plist")

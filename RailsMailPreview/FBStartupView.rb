#
#  FBStartupView.rb
#  RailsMailPreview
#
#  Created by Fernando Barajas on 8/28/11.
#  Copyright 2011 Fernando Barajas. All rights reserved.
#

require "#{RESOURCE_PATH}/FRBSideView.rb"

class FBStartupView < FRBSideView
  def after_init(rect)
    super(rect)
    load_startup_html
  end

  def load_startup_html
    template_path = NSBundle.mainBundle.pathForResource("startup.html", ofType:"erb")
    template = File.open(template_path) {|f| f.read }
    rhtml = ERB.new(template)
    self.loadHTMLString(rhtml.result(binding))
  end

  def render_stylesheet
    css_path = NSBundle.mainBundle.pathForResource("startup", ofType:"css")
    %Q{<link href="file://#{css_path}" rel="stylesheet" type="text/css" />}
  end
end

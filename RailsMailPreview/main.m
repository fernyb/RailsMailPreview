//
//  main.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/12/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>
#import <MacRuby/MacRuby.h>
#import <QuickLook/QuickLook.h>

#import "HDArtificialBridge.h"
#import "INAppStoreWindow.h"
#import "NSData+Additions.h"
#import "NSString+Additions.h"
#import "NSImage+Additions.h"


int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}

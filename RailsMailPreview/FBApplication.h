//
//  FBApplication.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface FBApplication : NSApplication
{
  BOOL supressNextAttention;
}

@property(assign) BOOL supressNextAttention;

@end

//
//  MyTabWindowController.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "MyTabWindowController.h"

@implementation MyTabWindowController

- (id)init
{
  self = [self initWithWindowNibName:@"MyTabs" owner:self];
  [self window];
  return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end

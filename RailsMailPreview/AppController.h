//
//  AppController.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/12/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FBTabViewBar;

@interface AppController : NSWindowController
{
  IBOutlet NSSplitView * contentSplitView;
  IBOutlet NSSplitView * splitview;
  IBOutlet NSTabView * contentTabView;
  IBOutlet FBTabViewBar * tabviewBar;
}

- (IBAction)useSampleData:(id)sender;

@end

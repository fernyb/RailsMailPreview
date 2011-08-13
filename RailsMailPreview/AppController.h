//
//  AppController.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/12/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppController : NSWindowController
{
  IBOutlet NSSplitView * splitview;
  IBOutlet WebView * leftWebview;
  IBOutlet WebView * rightWebview;
}

@end

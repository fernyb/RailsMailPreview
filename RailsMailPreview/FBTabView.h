//
//  FBTabView.h
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "INAppStoreWindow.h"
@class FBTabViewBar;

@interface FBTabView : NSTabView <INTitlebarViewDelegateProtocol>
{
  FBTabViewBar * tabviewBar;
}

@end

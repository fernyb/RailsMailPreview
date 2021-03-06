//
//  FBApplication.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 9/1/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "FBApplication.h"

@implementation FBApplication
@synthesize supressNextAttention;


- (NSInteger)requestUserAttention:(NSRequestUserAttentionType)requestType
{
  if ([self supressNextAttention]) {
    [self setSupressNextAttention:NO];
    return 0;
  }
  return [super requestUserAttention:requestType];
}

- (IBAction)showHelp:(id)sender
{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.nufex.com/rails_mail_preview/faq"]];
}

@end

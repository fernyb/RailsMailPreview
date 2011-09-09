//
//  NSString+Additions.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/23/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//

#import "NSString+Additions.h"
#import "Base64Transcoder.h"

@implementation NSString (NSString_Additions)

- (NSDictionary *)fileType
{
  NSString * uti = [NSMakeCollectable(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                                            (CFStringRef)[self pathExtension],
                                                                            NULL)) autorelease];
  
  NSString * mimeType = [NSMakeCollectable(UTTypeCopyPreferredTagWithClass((CFStringRef)uti, kUTTagClassMIMEType)) autorelease];
  
  return [NSDictionary dictionaryWithObjectsAndKeys:[uti pathExtension], @"uti", mimeType, @"mimeType", nil];
}

- (NSData *)decode64
{
	@try
	{
		size_t base64DecodedLength = EstimateBas64DecodedDataSize([self length]);
		char base64Decoded[base64DecodedLength];
		const char * cStringValue = [self UTF8String];
		if(Base64DecodeData(cStringValue, strlen(cStringValue), base64Decoded, &base64DecodedLength))
		{
			NSData * base64DecodedData = [[NSData alloc] initWithBytes:base64Decoded length:base64DecodedLength];
			return [base64DecodedData autorelease];
		}
	}
	@catch (NSException * e)
	{
		//do nothing
		NSLog(@"exception: %@", [e reason]);
	}
	return nil;
}


- (NSString *)flattenHTML
{  
  NSScanner *theScanner;
  NSString *text = nil;
  NSString * html = self;
  
  theScanner = [NSScanner scannerWithString:html];
  
  while ([theScanner isAtEnd] == NO) 
  {
    // find start of tag
    [theScanner scanUpToString:@"<" intoString:NULL];
    // find end of tag
    [theScanner scanUpToString:@">" intoString:&text];

    // replace the found tag with a space
    //(you can filter multi-spaces out later if you wish)
    html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
  }
  return [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
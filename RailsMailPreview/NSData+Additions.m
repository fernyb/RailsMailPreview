//
//  NSData+Additions.m
//  RailsMailPreview
//
//  Created by Fernando Barajas on 8/23/11.
//  Copyright 2011 Fernando Barajas. All rights reserved.
//


#import "NSData+Additions.h"
#import "Base64Transcoder.h"


@implementation NSData (NSData_Additions)

- (NSString *)base64
{
	@try 
	{
		size_t base64EncodedLength = EstimateBas64EncodedDataSize([self length]);
		char base64Encoded[base64EncodedLength];
		if(Base64EncodeData([self bytes], [self length], base64Encoded, &base64EncodedLength))
		{
			NSData * encodedData = [NSData dataWithBytes:base64Encoded length:base64EncodedLength];
			NSString * base64EncodedString = [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
			return [base64EncodedString autorelease];
		}
	}
	@catch (NSException * e)
	{
		//do nothing
		NSLog(@"exception: %@", [e reason]);
	}
	return nil;
}

@end

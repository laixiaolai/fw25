//
//  ExtendNSDictionary.m
//  Futuan
//
//  Created by 陈 福权 on 11-12-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtendNSDictionary.h"

@implementation NSDictionary (util)

- (NSString *)toString:(NSString *)aKey
{
	if ([self isKindOfClass:[NSDictionary class]])
    {
		id idval = [self objectForKey:aKey];  
		
		if ([idval isKindOfClass:[NSNull class]] || idval == [NSNull null])
        {
			return @"";
		}		
		if (idval && idval != [NSNull null])
        {
			if ([idval respondsToSelector:@selector(length)])
            {
                return [self objectForKey:aKey];
            }
			else if ([idval respondsToSelector:@selector(intValue)])
            {
				return [NSString stringWithFormat:@"%d", [[self objectForKey:aKey] intValue]];
			}
		}
        else
        {
			return @"";
		}
		return @"";
	}
    else
    {
		return @"";
	}
}

- (int)toInt:(NSString *)aKey
{
	if ([self isKindOfClass:[NSDictionary class]])
    {
		id idval = [self objectForKey:aKey];  				
		if (idval && idval != [NSNull null] && [idval respondsToSelector:@selector(intValue)])
        {
			return [[self objectForKey:aKey] intValue];
		}
        else
        {
			return 0;
		}
		return 0;
	}
    else
    {
		return 0;
	}
}


- (float)toFloat:(NSString *)aKey
{
	if ([self isKindOfClass:[NSDictionary class]])
    {
		id idval = [self objectForKey:aKey];    
		if (idval && idval != [NSNull null] && [idval respondsToSelector:@selector(floatValue)])
        {
			return [[self objectForKey:aKey] floatValue];
		}
        else
        {
			return 0;
		}
		return 0;
	}
    else
    {
		return 0;
	}
}

//判断是否为整形： 
- (BOOL)isPureInt:(NSString*) string
{
    NSScanner* scan = [NSScanner scannerWithString:string];     
    int val;
    return [scan scanInt: &val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat:(NSString *) string
{
    NSScanner* scan = [NSScanner scannerWithString:string];    
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end

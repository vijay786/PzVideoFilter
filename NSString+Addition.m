//
//  NSString+Addition.m
//  PzVideoFilter
//
//  Created by necixy on 13/09/13.
//  Copyright (c) 2013 necixy. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end {
    NSRange startRange = [self rangeOfString:start];
    if (startRange.location != NSNotFound) {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [self length] - targetRange.location;
        NSRange endRange = [self rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound) {
            targetRange.length = endRange.location - targetRange.location;
            return [self substringWithRange:targetRange];
        }
    }
    return nil;
}
@end

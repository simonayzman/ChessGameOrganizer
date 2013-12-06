//
//  NSString+AYZNSStringUtilities.m
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/25/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import "NSString+AYZNSStringUtilities.h"

@implementation NSString (AYZNSStringUtilities)

NSMutableArray * removeEmptyEntries (id arrayWithEmptySpaces)
{
    NSMutableArray * newArray = [[NSMutableArray alloc] init];
    
    for ( id currObject in arrayWithEmptySpaces) {
        if (![currObject isEqualToString:@""])
            [newArray addObject:currObject];
    }
    
    return newArray;
}


void printString(NSString * string) {NSLog(@"The current string is: %@",string);}

- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2
{
    return [self splitStringIntoArrayBetweenString: string1 andString: string2 inclusive: YES widestPossible: NO];
}

- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2 inclusive: (BOOL) inclusive widestPossible: (BOOL) widestPossible
{
    return [self splitStringIntoArrayBetweenString: string1 andString: string2 beginInclusive: inclusive endInclusive: inclusive widestPossible: NO];
}

- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2 beginInclusive: (BOOL) beginInclusive endInclusive:(BOOL) endInclusive widestPossible: (BOOL) widestPossible
{
    if ([self isEqualToString:@""])
        return nil;
    
    unsigned long inputStringLength = self.length;
    NSRange beforeR, betweenR, afterR, helperRange;
    NSMutableArray *resultingStrings = [NSMutableArray array];

    betweenR = [self rangeOfString:string1];
    helperRange.location = betweenR.location + betweenR.length;
    helperRange.length = inputStringLength - betweenR.location - betweenR.length;
    if (widestPossible)
        afterR = [self rangeOfString:string2 options:NSBackwardsSearch];
    else
        afterR = [self rangeOfString:string2 options:NSLiteralSearch range:helperRange];

    if (betweenR.location == NSNotFound || afterR.location == NSNotFound)
        return nil;
    
    afterR.length = inputStringLength - afterR.location - (endInclusive * string2.length);
    afterR.location = inputStringLength - afterR.length;
    betweenR.location = betweenR.location + (!beginInclusive * string1.length);
    betweenR.length = afterR.location - betweenR.location;
    beforeR.location = 0; beforeR.length = betweenR.location;    
    
    [resultingStrings addObject:[self substringWithRange:beforeR]];
    [resultingStrings addObject:[self substringWithRange:betweenR]];
    [resultingStrings addObject:[self substringWithRange:afterR]];
    
    return resultingStrings;
}

- (unsigned long) numOccurencesOfString: (NSString *)searchString
{
    unsigned long numOccurences = 0;
    NSRange currentRange; currentRange.length = searchString.length;
    for (currentRange.location = 0; currentRange.location + currentRange.length <= self.length; currentRange.location++)
    {
        if ([[self substringWithRange:currentRange] isEqualToString:searchString])
            numOccurences++;
    }

    return numOccurences;
}


@end




























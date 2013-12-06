//
//  NSString+AYZNSStringUtilities.h
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/25/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AYZNSStringUtilities)

NSMutableArray * removeEmptyEntries (id arrayWithEmptySpaces);

void printString(NSString * string);

//Resulting array holds three strings
//String at index 0 returns everything before first instance of string1
//String at index 1 returns everything between and including first instance of string1 and first subsequent instance of string2
//String at index 2 returns everything after first instance of string2 (after first instance of string1)
//If nothing exists before or after the strings, the respective indices will be empty
//If neither of the prompt strings are found, then nil is returned
- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2;

- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2 inclusive: (BOOL) inclusive widestPossible: (BOOL) widestPossible;

//designated splitter
- (NSMutableArray *) splitStringIntoArrayBetweenString: (NSString *) string1 andString: (NSString *) string2 beginInclusive: (BOOL) beginInclusive endInclusive: (BOOL) endInclusive widestPossible: (BOOL) widestPossible;

- (unsigned long) numOccurencesOfString: (NSString *) searchString;


@end

//
//  ChessGame.m
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/24/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import "ChessGame.h"

@implementation ChessGame

//OVERRIDDEN METHODS
- (NSString *) description
{
    return [NSString stringWithFormat:@"\r\r*******************************************************\r*\r* %@ (%lu) v. %@ (%lu)  [%@ %lu, %lu]\r*\r*******************************************************\r\r%@",self.white, self.whiteElo, self.black, self.blackElo, self.monthNamePlayed, self.dayNumPlayed, self.yearNumPlayed, [self getFormattedMoveList]];
}

- (BOOL) isEqual: (ChessGame *) other
{
    return [self.white isEqualToString:other.white] &&
    [self.black isEqualToString:other.black] &&
    [self.result isEqualToString:other.result] &&
    (self.whiteElo == other.whiteElo) &&
    (self.blackElo == other.blackElo) &&
    [self.dayStringPlayed isEqualToString:other.dayStringPlayed] &&
    [self.monthStringPlayed isEqualToString:other.monthStringPlayed] &&
    (self.yearNumPlayed == other.yearNumPlayed) &&
    [self.moveList isEqualToString:other.moveList];
}

//OVERRIDDEN PROPERTY METHODS

- (void) setMoveList:(NSString *)moveList
{
    _moveList = [moveList stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

//CLASS METHODS

+ (NSArray *) propertySet
{
    return [NSArray arrayWithObjects:@"Event",@"Site",@"Date",@"White",@"Black",@"Result",@"WhiteElo",@"BlackElo",@"TimeControl",@"Termination",@"1.",nil];
}

//INTITIALIZATION METHODS

//Designated Initializer
- (id) initWithPGN: (NSString *) pgn asFavorite: (BOOL) isFavorite
{
    self = [super init];
    
    if (self)
    {
        self.gameDictionary = [NSMutableDictionary dictionary];
        self.moveListArray = [NSMutableArray array];
        self.isFavorite = isFavorite;
        
        if ([pgn numOccurencesOfString:@"Event"] > 1)
        {
            NSLog(@"Error. File contains multiple chess games.");
            return nil;
        }
        
        NSMutableString *nextFileSection = [pgn copy];
        self.gameDictionary = [NSMutableDictionary dictionary];
        NSArray *propertySet = [NSArray arrayWithObjects:@"Event",@"Site",@"Date",@"White",@"Black",@"Result",@"WhiteElo",@"BlackElo",@"TimeControl",@"Termination",@"1.",nil];
        
        for ( NSString *property in propertySet)
        {
            
            //nextHolderArray holds the entire property string at index 1
            NSMutableArray *nextHolderArray;
            
            if ([property isEqualToString:@"1."])
            {
                nextHolderArray = [nextFileSection splitStringIntoArrayBetweenString: property andString:self.result beginInclusive:YES endInclusive:YES widestPossible:NO];
                
                [self.gameDictionary setObject: [nextHolderArray objectAtIndex:1] forKey: @"MoveList"];
                self.moveList = [nextHolderArray objectAtIndex:1];
                [self resolveMoveList];
            }
            else
            {
                nextHolderArray = [nextFileSection splitStringIntoArrayBetweenString:property andString:@"]" beginInclusive:YES endInclusive:NO widestPossible:NO];
                
                //tempArray holds what is inside the " " for the property at index 1
                NSMutableArray *tempArray;
                
                if ([property isEqualToString:@"Date"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    
                    NSRange range;
                    range.location = 0;
                    range.length = 4;
                    self.yearNumPlayed = [[[tempArray objectAtIndex:1] substringWithRange:range] longLongValue];
                    [self.gameDictionary setObject: [NSNumber numberWithUnsignedLong: self.yearNumPlayed] forKey: @"Year"];
                    range.location = 5;
                    range.length = 2;
                    self.monthStringPlayed = [[tempArray objectAtIndex:1] substringWithRange:range];
                    [self.gameDictionary setObject: self.monthStringPlayed forKey: @"MonthNumberString"];
                    self.monthNumPlayed = [self.monthStringPlayed longLongValue];
                    [self.gameDictionary setObject: [NSNumber numberWithUnsignedLong: self.monthNumPlayed] forKey: @"MonthNumber"];
                    range.location = 8;
                    range.length = 2;
                    self.dayStringPlayed = [[tempArray objectAtIndex:1] substringWithRange:range];
                    [self.gameDictionary setObject: self.dayStringPlayed forKey: @"DayString"];
                    self.dayNumPlayed = [self.dayStringPlayed longLongValue];
                    [self.gameDictionary setObject: [NSNumber numberWithUnsignedLong: self.dayNumPlayed] forKey: @"Day"];
                    
                    switch (self.monthNumPlayed) {
                        case 1:
                            [self.gameDictionary setObject: @"January" forKey: @"Month"];
                            break;
                        case 2:
                            [self.gameDictionary setObject: @"February" forKey: @"Month"];
                            break;
                        case 3:
                            [self.gameDictionary setObject: @"March" forKey: @"Month"];
                            break;
                        case 4:
                            [self.gameDictionary setObject: @"April" forKey: @"Month"];
                            break;
                        case 5:
                            [self.gameDictionary setObject: @"May" forKey: @"Month"];
                            break;
                        case 6:
                            [self.gameDictionary setObject: @"June" forKey: @"Month"];
                            break;
                        case 7:
                            [self.gameDictionary setObject: @"July" forKey: @"Month"];
                            break;
                        case 8:
                            [self.gameDictionary setObject: @"August" forKey: @"Month"];
                            break;
                        case 9:
                            [self.gameDictionary setObject: @"September" forKey: @"Month"];
                            break;
                        case 10:
                            [self.gameDictionary setObject: @"October" forKey: @"Month"];
                            break;
                        case 11:
                            [self.gameDictionary setObject: @"November" forKey: @"Month"];
                            break;
                        case 12:
                            [self.gameDictionary setObject: @"December" forKey: @"Month"];
                            break;
                        default:
                            [self.gameDictionary setObject: @"NO_MONTH" forKey: @"Month"];
                    }
                    self.monthNamePlayed = [self.gameDictionary objectForKey:@"Month"];
                }
                else if ([property isEqualToString:@"Result"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.result = [tempArray objectAtIndex:1];
                    
                    if ([self.result isEqualToString:@"1/2-1/2"])
                    {
                        [self.gameDictionary setObject: @"Draw" forKey: @"ResultType"];
                        self.resultType = @"Draw";
                    }
                    else if ([self.result isEqualToString:@"1-0"])
                    {
                        [self.gameDictionary setObject: @"White Wins" forKey: @"ResultType"];
                        self.resultType = @"White Wins";
                    }
                    if ([self.result isEqualToString:@"0-1"])
                    {
                        [self.gameDictionary setObject: @"Black Wins" forKey: @"ResultType"];
                        self.resultType = @"Black Wins";
                    }
                }
                else if ([property isEqualToString:@"Event"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.event = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"Site"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.site = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"TimeControl"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.timeControl = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"Termination"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.termination = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"White"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.white = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"Black"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: property];
                    self.black = [tempArray objectAtIndex:1];
                }
                else if ([property isEqualToString:@"WhiteElo"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: @"WhiteElo"];
                    self.whiteElo = [[tempArray objectAtIndex:1] integerValue];
                }
                else if ([property isEqualToString:@"BlackElo"])
                {
                    tempArray = [[nextHolderArray objectAtIndex:1] splitStringIntoArrayBetweenString:@"\"" andString:@"\"" beginInclusive:NO endInclusive:NO widestPossible:YES];
                    [self.gameDictionary setObject: [tempArray objectAtIndex:1] forKey: @"BlackElo"];
                    self.blackElo = [[tempArray objectAtIndex:1] integerValue];
                }
                nextFileSection = [nextHolderArray objectAtIndex:2];
            }
        }
    }
    return self;
}

- (id) init
{
    NSError * error;
    NSURL *testGamePath = [[NSBundle mainBundle] URLForResource:@"testGame" withExtension: @"png" subdirectory:@"Supporting Files/"];
    return [self initWithPGN: [NSString stringWithContentsOfFile:(NSString *)testGamePath encoding:NSUTF8StringEncoding error:&error] asFavorite: NO];
}

//INSTANCE METHODS

- (NSString *) getPGNfromGame
{
    NSString *pgn = @"";
    NSArray *propSet = [ChessGame propertySet];
    for (int i = 0; i < propSet.count-1; i++)
    {
        NSString *currProperty =  [propSet objectAtIndex: i];
        NSString *currValueForProperty = [self.gameDictionary valueForKey:currProperty];
        NSString *pgnPieceToAdd = [NSString stringWithFormat:@"[%@ \"%@\"]\n", currProperty,currValueForProperty];
        pgn = [pgn stringByAppendingString:pgnPieceToAdd];
    }
    pgn = [pgn stringByAppendingString:[NSString stringWithFormat:@"\n%@",self.moveList]];
    return pgn;
}

- (void) resolveMoveList
{
    NSMutableArray *holderArray1, *holderArray2;
   // NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    for (unsigned long i=1;; i++)
    {
        NSString *currentMove = [NSString stringWithFormat:@"%lu.",i];
        NSString *nextMove = [NSString stringWithFormat:@"%lu.",i+1];

        if ([self.moveList rangeOfString:nextMove].location == NSNotFound)
        {
            self.numMoves = i;
            
            holderArray1 = [self.moveList splitStringIntoArrayBetweenString:currentMove andString:self.result beginInclusive:NO endInclusive:NO widestPossible:NO];
            holderArray2 = [[holderArray1 objectAtIndex:1] splitStringIntoArrayBetweenString:@" " andString:@" " beginInclusive:NO endInclusive:NO widestPossible:NO];
            if (holderArray2)
            {
                [self.moveListArray insertObject: [[holderArray2 objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:i*2-2];
                [self.moveListArray insertObject:[[holderArray2 objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:i*2-1];
            }
            else
                [self.moveListArray insertObject:[[holderArray1 objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:i*2-2];
            
            break;
        }
        else
        {
            holderArray1 = [self.moveList splitStringIntoArrayBetweenString:currentMove andString:nextMove beginInclusive:NO endInclusive:NO widestPossible:NO];
            holderArray2 = [[holderArray1 objectAtIndex:1] splitStringIntoArrayBetweenString:@" " andString:@" " beginInclusive:NO endInclusive:NO widestPossible:NO];
            [self.moveListArray insertObject:[[holderArray2 objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:i*2-2];
            [self.moveListArray insertObject:[[holderArray2 objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] atIndex:i*2-1];
        }

    }
}

- (NSString *) gameHeader
{
    return [NSString stringWithFormat:@"%@ (%lu) v. %@ (%lu)  [%@ %lu, %lu]",self.white, self.whiteElo, self.black, self.blackElo, self.monthNamePlayed, self.dayNumPlayed, self.yearNumPlayed];
}

- (NSString *) prettyGameHeader
{
        return [NSString stringWithFormat:@"\r\r*******************************************************\r*\r* %@ (%lu) v. %@ (%lu)  [%@ %lu, %lu]\r*\r*******************************************************\r\r",self.white, self.whiteElo, self.black, self.blackElo, self.monthNamePlayed, self.dayNumPlayed, self.yearNumPlayed];
}

- (NSString *) getFormattedMoveList
{
    NSMutableString *list = [NSMutableString string];
    
    for (unsigned long i=0; i < self.moveListArray.count; i+=2)
    {
        if (i+1 == self.moveListArray.count && self.moveListArray.count % 2 == 1)
        {
            [list appendString:[NSString stringWithFormat:@"\n%lu. %@", (i+2)/2, [self.moveListArray objectAtIndex:i]]];
        }
        else
            [list appendString:[NSString stringWithFormat:@"\n%lu. %@ %@", (i+2)/2, [self.moveListArray objectAtIndex:i], [self.moveListArray objectAtIndex:i+1]]];
    }
    return (NSString *) list;
}

- (BOOL) isMoveListEqualTo: (ChessGame *) other
{
    return [self.moveList isEqualToString:other.moveList];
}

- (NSString *) getNameOfPlayerOtherThan: (NSString *) player
{
    if ([self.white isEqualToString: player])
        return self.black;
    else if ([self.black isEqualToString: player])
        return self.white;
    else
    {
        NSLog(@"Player not found.");
        return nil;
    }
}

- (NSString *) getColorOfPlayer: (NSString *) player
{
    if ([self.white isEqualToString: player])
        return @"White";
    else if ([self.black isEqualToString: player])
        return @"Black";
    else
    {
        NSLog(@"Player not found.");
        return nil;
    }
}

- (unsigned long) getRatingOfPlayer: (NSString *) player
{
    if ([self.white isEqualToString: player])
        return self.whiteElo;
    else if ([self.black isEqualToString: player])
        return self.blackElo;
    else
    {
        NSLog(@"Player not found.");
        return -1;
    }
}

- (NSString *) getResultOfPlayer: (NSString *) player
{
    if (([self.white isEqualToString: player] && [self.resultType isEqualToString:@"White Wins"]) ||
        ([self.black isEqualToString: player] && [self.resultType isEqualToString:@"Black Wins"]) )
        return @"Won";
    else if (([self.white isEqualToString: player] && [self.resultType isEqualToString:@"Black Wins"]) ||
             ([self.black isEqualToString: player] && [self.resultType isEqualToString:@"White Wins"]) )
        return @"Lost";
    else if ([self.resultType isEqualToString:@"Draw"] && ([self.white isEqualToString: player] || [self.black isEqualToString: player]))
        return @"Draw";
    else
    {
        NSLog(@"Player not found.");
        return nil;
    }
}

- (NSString *) getColorOfPlayerOtherThan:(NSString *) player
{
    if ([self.white isEqualToString: player])
        return @"Black";
    else if ([self.black isEqualToString: player])
        return @"White";
    else
    {
        NSLog(@"Player not found.");
        return nil;
    }
}

- (unsigned long) getRatingOfPlayerOtherThan: (NSString *) player
{
    if ([self.white isEqualToString: player])
        return self.blackElo;
    else if ([self.black isEqualToString: player])
        return self.whiteElo;
    else
    {
        NSLog(@"Player not found.");
        return -1;
    }
}

- (NSString *) getResultOfPlayerOtherThan: (NSString *) player
{
    if (([self.white isEqualToString: player] && [self.resultType isEqualToString:@"White Wins"]) ||
        ([self.black isEqualToString: player] && [self.resultType isEqualToString:@"Black Wins"]) )
        return @"Lost";
    else if (([self.white isEqualToString: player] && [self.resultType isEqualToString:@"Black Wins"]) ||
             ([self.black isEqualToString: player] && [self.resultType isEqualToString:@"White Wins"]) )
        return @"Won";
    else if ([self.resultType isEqualToString:@"Draw"] && ([self.white isEqualToString: player] || [self.black isEqualToString: player]))
        return @"Draw";
    else
    {
        NSLog(@"Player not found.");
        return nil;
    }
}

/*
 - (id)initWithCoder: (NSCoder *) decoder
 {
 decoder
 }
*/

/*
 - (void)encodeWithCoder: (NSCoder *) encoder
 {
 
 }
 */

@end















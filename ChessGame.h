//
//  ChessGame.h
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/24/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+AYZNSStringUtilities.h"

@interface ChessGame : NSObject //<NSCoding>

@property (nonatomic, strong) NSString *white, *black, *result, *resultType, *monthNamePlayed, *monthStringPlayed, *dayStringPlayed, *moveList, *event, *site, *timeControl, *termination, *finalFileName;

@property unsigned long numMoves, dayNumPlayed, monthNumPlayed, yearNumPlayed, whiteElo, blackElo;
@property (nonatomic, strong) NSMutableArray *moveListArray;
@property (nonatomic, strong) NSMutableDictionary * gameDictionary;
@property (nonatomic) BOOL isFavorite;

+ (NSArray *) propertySet;

//Designated Initializer
- (id) initWithPGN: (NSString *) pgn asFavorite: (BOOL) isFavorite;
- (id) init;

- (void) resolveMoveList;
- (NSString *) gameHeader;
- (NSString *) prettyGameHeader;
- (NSString *) getFormattedMoveList;
- (NSString *) getPGNfromGame;
- (BOOL) isMoveListEqualTo: (id) other;

- (NSString *) getNameOfPlayerOtherThan: (NSString *) player;

- (NSString *) getColorOfPlayer: (NSString *) player;
- (unsigned long) getRatingOfPlayer: (NSString *) player;
- (NSString *) getResultOfPlayer: (NSString *) player;

- (NSString *) getColorOfPlayerOtherThan: (NSString *) player;
- (unsigned long) getRatingOfPlayerOtherThan: (NSString *) player;
- (NSString *) getResultOfPlayerOtherThan: (NSString *) player;

@end

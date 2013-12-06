//
//  ChessGameOrganizer.h
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/26/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessGameOrganizer : NSObject

@property (nonatomic) NSMutableArray *chessGames;

- (id) init;
- (id) initWithPGNFile: (NSString *) pgnFile asFavorite: (BOOL) isFavorite;

- (void) addPGNFile: (NSString *) pgnFile asFavorites: (BOOL) areFavorites;

- (void) clearOrganizer;
- (void) clearAllDirectories;
- (void) deleteAllCustomSorts;
- (void) deleteAllDirectories;
- (void) createDirectories;

- (void) placeGamesIn: (NSString *) directory;
- (void) sortGames;
- (void) customSortGamesBy: (NSArray *) sortFactors;


@end

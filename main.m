//
//  main.m
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/24/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChessGame.h"
#import "ChessGameOrganizer.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
        //Alternatively, use the line below and delete the above if you want a Chess directory in the home directory:
        //    NSString * CHESS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Chess/"];
        NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
       
        NSString * PAST_GAMES_DIR = [CHESS_DIR stringByAppendingPathComponent:@"PastGames/"];
        
        NSString * ALL_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"All/"];
        NSString * FAVORITES_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Favorites/"];
        NSString * UNSORTED_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Unsorted/"];
        NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
        NSString * CUSTOM_SORTS_DIR = [SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"];
        NSString * OTHER_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Other/"];
        
        NSString * UNSORTED_REMAINING_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Remaining/"];
        NSString * UNSORTED_FAVORITES_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Favorites/"];
        
        ChessGameOrganizer *organizer = [[ChessGameOrganizer alloc] init];
        
        if ([[[NSString stringWithCString:argv[1]encoding:NSUTF8StringEncoding] uppercaseString] isEqualToString:@"DELETE"])
            [organizer deleteAllDirectories];
        else if ([[[NSString stringWithCString:argv[1]encoding:NSUTF8StringEncoding] uppercaseString] isEqualToString:@"CLEAR"])
            [organizer clearAllDirectories];
        else if ([[[NSString stringWithCString:argv[1]encoding:NSUTF8StringEncoding] uppercaseString] isEqualToString:@"INIT"])
            [organizer createDirectories];
        else
        {
            [organizer createDirectories];
        
            NSDirectoryEnumerator *unsortedFavoritesDirectoryEnumerator = [fileManager enumeratorAtPath:UNSORTED_FAVORITES_GAMES_DIR];
            NSDirectoryEnumerator *unsortedRemainingDirectoryEnumerator = [fileManager enumeratorAtPath:UNSORTED_REMAINING_GAMES_DIR];

            NSString *file;

            while (file = [unsortedFavoritesDirectoryEnumerator nextObject])
            {
                if ([[file pathExtension] isEqualToString: @"pgn"])
                {
                    file = [UNSORTED_FAVORITES_GAMES_DIR stringByAppendingPathComponent:file];
                    [organizer addPGNFile:file asFavorites:YES];
                }
            }
        
            [organizer placeGamesIn:FAVORITES_GAMES_DIR];
        
            while (file = [unsortedRemainingDirectoryEnumerator nextObject])
            {
                if ([[file pathExtension] isEqualToString: @"pgn"])
                {
                    file = [UNSORTED_REMAINING_GAMES_DIR stringByAppendingPathComponent:file];
                    [organizer addPGNFile:file asFavorites:NO];
                }
            }
        
            [organizer placeGamesIn:ALL_GAMES_DIR];
        
            [organizer sortGames];
        
            if (argc > 1 && ![[[NSString stringWithCString:argv[1]encoding:NSUTF8StringEncoding] uppercaseString] isEqualToString:@"CLEAR"])
            {
                NSMutableArray *sortFactors = [NSMutableArray array];
                for (int i = 1; i < argc; i++)
                    [sortFactors addObject: [NSString stringWithCString:argv[i]encoding:NSUTF8StringEncoding]];
            
                [organizer customSortGamesBy:sortFactors];
            }
        }
        
        
    }
    return 0;
}


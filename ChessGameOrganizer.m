//
//  ChessGameOrganizer.m
//  ChessGameOrganizer
//
//  Created by Simon Ayzman on 6/26/13.
//  Copyright (c) 2013 simonayzman. All rights reserved.
//

#import "ChessGameOrganizer.h"
#import "ChessGame.h"

@interface ChessGameOrganizer()

- (void) addSingleChessGame: (ChessGame *) game;

@end

@implementation ChessGameOrganizer

- (id) init
{
    NSURL *testGamePath = [[NSBundle mainBundle] URLForResource:@"testGame" withExtension: @"png" subdirectory:@"Supporting Files/"];
    return [self initWithPGNFile: (NSString *)testGamePath asFavorite:NO];
}

- (id) initWithPGNFile: (NSString *) pgnFile asFavorite: (BOOL) isFavorite
{
    self = [super init];
    
    if (self)
    {
        self.chessGames = [NSMutableArray array];
        [self addPGNFile:pgnFile asFavorites: isFavorite];
    }
    return self;
}

- (void) clearOrganizer
{
    [self.chessGames removeAllObjects];
}

- (void) clearAllDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    [self createDirectories];
    
    NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    //Alternatively, use the line below and delete the above if you want a Chess directory in the home directory:
    //    NSString * CHESS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Chess/"];
    NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
    NSString * PAST_GAMES_DIR = [CHESS_DIR stringByAppendingPathComponent:@"PastGames/"];
    NSString * ALL_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"All/"];
    NSString * FAVORITES_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Favorites/"];
    NSString * UNSORTED_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Unsorted/"];
    NSString * UNSORTED_REMAINING_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Remaining/"];
    NSString * UNSORTED_FAVORITES_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Favorites/"];
    NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
    NSString * OTHER_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Other/"];
    
    [fileManager removeItemAtPath:ALL_GAMES_DIR error:&error];
    [fileManager createDirectoryAtPath:ALL_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager removeItemAtPath:FAVORITES_GAMES_DIR error:&error];
    [fileManager createDirectoryAtPath:FAVORITES_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager removeItemAtPath:UNSORTED_GAMES_DIR error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_FAVORITES_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_REMAINING_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];

    [fileManager removeItemAtPath:SORTS_DIR error:&error];
    [fileManager createDirectoryAtPath:SORTS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/Black/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/White/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Win"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Draw"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Loss"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"DatePlayed/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"HigherOpponentElo/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"LowerOpponentElo/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Opponents/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"PersonalRating/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"] withIntermediateDirectories:NO attributes:nil error:&error];
    

}

- (void) deleteAllCustomSorts
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
    NSString * PAST_GAMES_DIR = [CHESS_DIR stringByAppendingPathComponent:@"PastGames/"];
    NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
    NSString * CUSTOM_SORTS_DIR = [SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"];
    [fileManager createDirectoryAtPath:CUSTOM_SORTS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager removeItemAtPath:CUSTOM_SORTS_DIR error:&error];
    
}

- (void) deleteAllDirectories
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
    [fileManager createDirectoryAtPath:CHESS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager removeItemAtPath:CHESS_DIR error:&error];
}

- (void) createDirectories
{
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
    NSString * UNSORTED_REMAINING_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Remaining/"];
    NSString * UNSORTED_FAVORITES_GAMES_DIR = [UNSORTED_GAMES_DIR stringByAppendingPathComponent:@"Favorites/"];
    NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
    NSString * OTHER_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Other/"];
    
    [fileManager createDirectoryAtPath:DOCUMENTS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:CHESS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:PAST_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:ALL_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    //  [fileManager removeItemAtPath:ALL_GAMES_DIR error:&error];
    //  [fileManager createDirectoryAtPath:ALL_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:FAVORITES_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    //  [fileManager removeItemAtPath:FAVORITES_GAMES_DIR error:&error];
    //  [fileManager createDirectoryAtPath:FAVORITES_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_REMAINING_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:UNSORTED_FAVORITES_GAMES_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:SORTS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    //  [fileManager removeItemAtPath:SORTS_DIR error:&error];
    //  [fileManager createDirectoryAtPath:SORTS_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:OTHER_DIR withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/Black/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/White/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Win"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Draw"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/Loss"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"DatePlayed/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"HigherOpponentElo/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"LowerOpponentElo/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"Opponents/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"PersonalRating/"] withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager createDirectoryAtPath:[SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"] withIntermediateDirectories:NO attributes:nil error:&error];
    
}

- (void) addPGNFile: (NSString *) pgnFile asFavorites: (BOOL) areFavorites
{
    NSError *error = nil;
    NSMutableArray *multiplePGNFileHolder = [NSMutableArray array];
    NSString *currPGN = [NSString stringWithContentsOfFile:pgnFile encoding:NSUTF8StringEncoding error:&error];
    
    unsigned long numberOfChessGamesInFile = [currPGN numOccurencesOfString:@"[Event"];
    
    
    for (int i = 0; i < numberOfChessGamesInFile; i++)
    {
        multiplePGNFileHolder = [currPGN splitStringIntoArrayBetweenString:@"[Event" andString:@"[Event" beginInclusive:YES endInclusive:NO widestPossible:NO];
        
        if (multiplePGNFileHolder)
        {
            currPGN = [multiplePGNFileHolder objectAtIndex:1];
            
            [self addSingleChessGame:[[ChessGame alloc] initWithPGN:currPGN asFavorite: areFavorites]];

            currPGN = [multiplePGNFileHolder objectAtIndex:2];
        }
        else
            [self addSingleChessGame:[[ChessGame alloc] initWithPGN:currPGN asFavorite: areFavorites]];
    }
}

- (void) addSingleChessGame: (ChessGame *) game
{
    BOOL duplicateExists = NO;
    for (ChessGame *currGameInDatabase in self.chessGames)
    {
        if ([currGameInDatabase isMoveListEqualTo:game])
        {
            if ([currGameInDatabase isEqual:game]) {
                NSLog(@"This game already exists: %@", game.gameHeader);
                duplicateExists = YES;
                break;
            }
            else
                NSLog(@"\n%@\n&\n%@\n\nThese games have the same move list, but they were played under different circumstances:%@\n",currGameInDatabase.gameHeader, game.gameHeader, game.getFormattedMoveList);
        }
    }
    if (!duplicateExists)
        [self.chessGames addObject:game];
}

- (void) placeGamesIn: (NSString *) directory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    for (ChessGame *game in self.chessGames)
    {
        [fileManager changeCurrentDirectoryPath:directory];
        NSString *PGNOfGameInOrganizer = [game getPGNfromGame];
        NSString *gameToBeAddedName = [[game gameHeader] stringByAppendingPathExtension:@"pgn"];
        NSString *gameToBeAddedPath = [directory stringByAppendingPathComponent:gameToBeAddedName];
        
        if ([fileManager fileExistsAtPath:gameToBeAddedPath])
        {
            ChessGame * possibleGameDuplicate = [[ChessGame alloc] initWithPGN:[NSString stringWithContentsOfFile:gameToBeAddedPath encoding:NSUTF8StringEncoding error:&error] asFavorite:NO];
            
            //The two games are completely equal
            if ([game isEqual:possibleGameDuplicate])
            {
                NSLog(@"This game already exists: %@", gameToBeAddedName);
                game.finalFileName = [gameToBeAddedName lastPathComponent];
            }
            
            //The two games have the same game header, but they were played fundamentally differently
            else
            {
                NSData *gameData = [PGNOfGameInOrganizer dataUsingEncoding:NSUTF8StringEncoding];
                NSUInteger numGames= 1;
                NSString *numGamesString = [NSString stringWithFormat:@" {%lu}",numGames];
                
                NSString *correctedGamePath = [gameToBeAddedPath stringByDeletingPathExtension];
                correctedGamePath = [correctedGamePath stringByAppendingString:numGamesString];
                correctedGamePath = [correctedGamePath stringByAppendingPathExtension:@"pgn"];
                
                
                while ([fileManager fileExistsAtPath:correctedGamePath])
                {
                    numGames++;
                    numGamesString = [NSString stringWithFormat:@" {%lu}",numGames];
                    correctedGamePath = [gameToBeAddedPath stringByDeletingPathExtension];
                    correctedGamePath = [correctedGamePath stringByAppendingString:numGamesString];
                    correctedGamePath = [correctedGamePath stringByAppendingPathExtension:@"pgn"];
                    
                }
                [fileManager createFileAtPath:correctedGamePath contents:gameData attributes:nil];
                game.finalFileName = [correctedGamePath lastPathComponent];
            }
        }
        else
        {
            NSData *gameData = [PGNOfGameInOrganizer dataUsingEncoding:NSUTF8StringEncoding];
            [fileManager createFileAtPath:gameToBeAddedPath contents:gameData attributes:nil];
            game.finalFileName = [gameToBeAddedName lastPathComponent];
        }
    }
}

//Default sorts are by Color, Opponents, Result, HigherOpponentRating, LowerOpponentRating, DatePlayed, and PersonalRating 
- (void) sortGames;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    //Alternatively, use the line below and delete the above if you want a Chess directory in the home directory:
    //    NSString * CHESS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Chess/"];
    NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
    NSString * PAST_GAMES_DIR = [CHESS_DIR stringByAppendingPathComponent:@"PastGames/"];
    NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
    NSString * ALL_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"All/"];
    NSString * OTHER_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Other/"];
    NSString * CUSTOM_SORTS_DIR = [SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"];
    
    NSString *playerName = [[NSString stringWithContentsOfFile:[OTHER_DIR stringByAppendingPathComponent:@"Player.txt"] encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    for (ChessGame *game in self.chessGames)
    {
        //Sort by the color played by the player
        [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"Color/"]];
        if ([game.white isEqualToString: playerName])
            [fileManager createSymbolicLinkAtPath: [[[fileManager currentDirectoryPath] stringByAppendingPathComponent:@"White/"] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        else
            [fileManager createSymbolicLinkAtPath: [[[fileManager currentDirectoryPath] stringByAppendingPathComponent:@"Black/"] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        
        //Sort by the result of the game played by the player
        [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"Result/"]];
        if (([game.white isEqualToString: playerName] && [[game.gameDictionary objectForKey:@"ResultType"] isEqualToString:@"White Wins"]) ||
            ([game.black isEqualToString: playerName] && [[game.gameDictionary objectForKey:@"ResultType"] isEqualToString:@"Black Wins"])  )
        {
            [fileManager createSymbolicLinkAtPath: [[[fileManager currentDirectoryPath] stringByAppendingPathComponent:@"Win/"] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        }
        else if (([game.white isEqualToString: playerName] && [[game.gameDictionary objectForKey:@"ResultType"] isEqualToString:@"Black Wins"]) ||
                 ([game.black isEqualToString: playerName] && [[game.gameDictionary objectForKey:@"ResultType"] isEqualToString:@"White Wins"]))
        {
            [fileManager createSymbolicLinkAtPath: [[[fileManager currentDirectoryPath] stringByAppendingPathComponent:@"Loss/"] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        }
        else
            [fileManager createSymbolicLinkAtPath: [[[fileManager currentDirectoryPath] stringByAppendingPathComponent:@"Draw/"] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        
        //Sort by whether the opponent had a higher or lower Elo than the player
        if (([game.white isEqualToString: playerName] && (game.whiteElo > game.blackElo)) ||
            ([game.black isEqualToString: playerName] && (game.whiteElo < game.blackElo)))
        {
            [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"LowerOpponentElo/"]];
            [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        }
        else if (([game.white isEqualToString: playerName] && (game.whiteElo < game.blackElo)) ||
                 ([game.black isEqualToString: playerName] && (game.whiteElo > game.blackElo)))
        {
            
            [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"HigherOpponentElo/"]];
            [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        }
        
        //Sort by the opponent
        [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"Opponents/"]];
        NSString *currentOpponent;
        if ([game.white isEqualToString:playerName])
            currentOpponent = [NSString stringWithString: game.black];
        else if ([game.black isEqualToString:playerName])
            currentOpponent = [NSString stringWithString: game.white];
            
        [fileManager createDirectoryAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:currentOpponent] withIntermediateDirectories:NO attributes:nil error:&error];
        [fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:currentOpponent]];
        [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        
        //Sort by personal rating
        [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"PersonalRating/"]];
        NSString *eloRange;
        if ([game.white isEqualToString:playerName])
            eloRange = [NSString stringWithFormat:@"%lu-%lu", game.whiteElo / 100 * 100, game.whiteElo / 100 * 100 + 99];
        else if ([game.black isEqualToString:playerName])
            eloRange = [NSString stringWithFormat:@"%lu-%lu", game.blackElo / 100 * 100, game.blackElo / 100 * 100 + 99];
        [fileManager createDirectoryAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:eloRange] withIntermediateDirectories:NO attributes:nil error:&error];
        [fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:eloRange]];
        [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        
        //Sort by date
        [fileManager changeCurrentDirectoryPath:[SORTS_DIR stringByAppendingPathComponent:@"DatePlayed/"]];
        NSString *year = [NSString stringWithFormat:@"%lu", game.yearNumPlayed];
        NSString *month = game.monthNamePlayed;
        [fileManager createDirectoryAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:year] withIntermediateDirectories:NO attributes:nil error:&error];
        [fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:year]];
        [fileManager createDirectoryAtPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:month] withIntermediateDirectories:NO attributes:nil error:&error];
        [fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:month]];
        [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
        
    }
}

//*************************************
//CONSIDER ALTERING THIS FUNCTION IN THE FUTURE BY INCLUDING SOME FASTER ALGORITHM THAT COUNTS THE NUMBER OF ENTRIES OF THE FOLDER THAT THE CUSTOM SEARCH RELATED TO; I.E., IF SORTING BY BLACK, JANUARY 2013, AND OPPONENT>1300, THEN CHECKING EACH OF THESE FOLDERS TO SEE THE ONE WITH THE FEWEST ENTIRES WOULD BE THE STARTING POINT, AND ALL FILTRATION WOULD OCCUR BASED ON THE REMAINING ENTRIES

- (void) customSortGamesBy: (NSArray *) sortFactors
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
        
    NSString * DOCUMENTS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    //Alternatively, use the line below and delete the above if you want a Chess directory in the home directory:
    //    NSString * CHESS_DIR = [NSHomeDirectory() stringByAppendingPathComponent:@"Chess/"];
    NSString * CHESS_DIR = [DOCUMENTS_DIR stringByAppendingPathComponent:@"Chess/"];
    NSString * PAST_GAMES_DIR = [CHESS_DIR stringByAppendingPathComponent:@"PastGames/"];
    NSString * SORTS_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Sorts/"];
    NSString * ALL_GAMES_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"All/"];
    NSString * OTHER_DIR = [PAST_GAMES_DIR stringByAppendingPathComponent:@"Other/"];
    NSString * CUSTOM_SORTS_DIR = [SORTS_DIR stringByAppendingPathComponent:@"CustomSorts/"];
    
    [fileManager changeCurrentDirectoryPath:CUSTOM_SORTS_DIR];
    
    NSString *newCustomSortDirectoryName = [NSString stringWithFormat:@"%@", [sortFactors objectAtIndex: 0]];
    BOOL directoryNameCreated = NO;
    
    NSString *playerName = [[NSString stringWithContentsOfFile:[OTHER_DIR stringByAppendingPathComponent:@"Player.txt"] encoding:NSUTF8StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray *delimiters = [NSArray arrayWithObjects:@">=",@"<=",@"=",@">",@"<", nil];
    
    //Complicated sort factor array created so a new set of the exact same factors aren't created each time they are compared to a game
    //All in terms of mod 5
    // 0 = pre-delimiter factor
    // 1 = upper case predelimiter factor
    // 2 = delimiter
    // 3 = post-delimiter factor
    // 4 = upper case post-delimiter factor
    NSMutableArray *standardizedSortFactors = [NSMutableArray array];
    NSString *preDelimiterFactor;
    NSString *upperCasePreDelimiterFactor;
    NSString *delimiter;
    NSString *postDelimiterFactor;
    NSString *upperCasePostDelimiterFactor;
    
    for (int i = 0; i < sortFactors.count; i++)
    {
        //Directory needs to be only created during the first run; why repeat assignment?
        if (!directoryNameCreated && i > 0)
        {
            newCustomSortDirectoryName = [newCustomSortDirectoryName stringByAppendingFormat:@" | %@", [sortFactors objectAtIndex: i]];
            if (i == sortFactors.count - 1)
                directoryNameCreated = YES;
        }
        
        NSString *currentFactor = [sortFactors objectAtIndex:i];
        
        //Find delimiter
        NSString *delimiter;
        NSRange delimiterRange;
        for (int j = 0; j < delimiters.count; j++)
        {
            delimiterRange = [currentFactor rangeOfString:[delimiters objectAtIndex:j]];
            if (delimiterRange.location != NSNotFound)
            {
                delimiter = [delimiters objectAtIndex:j];
                //"Self" can be left out of the argument, so this corrects for that
                if (delimiterRange.location == 0)
                {
                    currentFactor = [NSString stringWithFormat:@"Self%@",currentFactor];
                    delimiterRange = [currentFactor rangeOfString:[delimiters objectAtIndex:j]];
                }
                break;
            }
            //If this loop has reached the last delimiter and still has not been found, then it proceeds to go to this code snippet
            if (j == delimiters.count - 1)
            {
                delimiter = @"=";
                currentFactor = [NSString stringWithFormat:@"Self%@%@",delimiter,currentFactor];
                delimiterRange = [currentFactor rangeOfString:delimiter];
            }
        }
        
        NSRange preDelimiterRange;
        preDelimiterRange.location = 0;
        preDelimiterRange.length = delimiterRange.location;
        NSRange postDelimiterRange;
        postDelimiterRange.location = delimiterRange.location + delimiterRange.length;
        postDelimiterRange.length = currentFactor.length - preDelimiterRange.length - delimiter.length;
        
        [standardizedSortFactors addObject: [currentFactor substringWithRange:preDelimiterRange]];
        [standardizedSortFactors addObject: [[currentFactor substringWithRange:preDelimiterRange] uppercaseString]];
        [standardizedSortFactors addObject: delimiter];
        [standardizedSortFactors addObject: [currentFactor substringWithRange:postDelimiterRange]];
        [standardizedSortFactors addObject: [[currentFactor substringWithRange:postDelimiterRange] uppercaseString]];
    }
    
   // NSLog(@"%@", standardizedSortFactors);
    
    NSUInteger numResultsFound = 0;
    [fileManager createDirectoryAtPath:newCustomSortDirectoryName withIntermediateDirectories:NO attributes:nil error:&error];
    [fileManager changeCurrentDirectoryPath:[[fileManager currentDirectoryPath] stringByAppendingPathComponent:newCustomSortDirectoryName]];
    
    NSString *currentPreDelimiterFactor;
    NSString *currentUpperCasePreDelimiterFactor;
    NSString *currentDelimiter;
    NSString *currentPostDelimiterFactor;
    NSString *currentUpperCasePostDelimiterFactor;
    
    BOOL correctArguments = YES;
    
    for (ChessGame *game in self.chessGames)
    {
        BOOL addGame = YES;
                
        for (int i = 0; i < sortFactors.count; i++)
        {
            typedef enum {COLOR,RESULT,RATING,OPPONENT,OPPONENT_COLOR,OPPONENT_RESULT,OPPONENT_RATING,DATE} TypeQuery;
            
            currentPreDelimiterFactor = [standardizedSortFactors objectAtIndex:i*5];
            currentUpperCasePreDelimiterFactor = [standardizedSortFactors objectAtIndex:i*5+1];
            currentDelimiter = [standardizedSortFactors objectAtIndex:i*5+2];
            currentPostDelimiterFactor = [standardizedSortFactors objectAtIndex:i*5+3];
            currentUpperCasePostDelimiterFactor = [standardizedSortFactors objectAtIndex:i*5+4];
           
            //NSLog(@"\n\n%@  %@\n\n%@\n\n%@  %@\n--------\n", currentPreDelimiterFactor, currentUpperCasePreDelimiterFactor,currentDelimiter,currentPostDelimiterFactor, currentUpperCasePostDelimiterFactor);
            
            //IMPLEMENT FILTERING INSIDE THESE BRACKETS
            
            TypeQuery currentQuery;
            
            if ( [currentUpperCasePreDelimiterFactor isEqualToString:@"DATE"] &&
                ([currentDelimiter isEqualToString:@">"]  ||
                 [currentDelimiter isEqualToString:@"<"]  ||
                 [currentDelimiter isEqualToString:@">="] ||
                 [currentDelimiter isEqualToString:@"<="] ))
            {
                unsigned long numDateFactors = [currentPostDelimiterFactor numOccurencesOfString:@"."];
                if (numDateFactors == 0)
                {
                    currentQuery = DATE;
                }
                else
                {
                    NSLog(@"Unrecognized arguments! Run the \"help\" argument for correct custom sorting arguments.");
                    correctArguments = NO;
                    break;
                }
            }
            else if ([currentUpperCasePreDelimiterFactor isEqualToString:@"SELF"])
            {
                if ([currentDelimiter isEqualToString:@"="] &&
                    ([currentUpperCasePostDelimiterFactor isEqualToString:@"WHITE"] ||
                     [currentUpperCasePostDelimiterFactor isEqualToString:@"BLACK"]))
                {
                    currentQuery = COLOR;
                    if (![[[game getColorOfPlayer:playerName] uppercaseString] isEqualToString:currentUpperCasePostDelimiterFactor])
                    {
                        addGame = NO;
                        break;
                    }
                }
                else if ([currentDelimiter isEqualToString:@"="] &&
                    ([currentUpperCasePostDelimiterFactor isEqualToString:@"WON"]  ||
                     [currentUpperCasePostDelimiterFactor isEqualToString:@"LOST"] ||
                     [currentUpperCasePostDelimiterFactor isEqualToString:@"DRAW"]))
                {
                    currentQuery = RESULT;
                    if (![[[game getResultOfPlayer:playerName] uppercaseString] isEqualToString:currentUpperCasePostDelimiterFactor])
                    {
                        addGame = NO;
                        break;
                    }
                }
                else if (([currentDelimiter isEqualToString:@">"] ||
                          [currentDelimiter isEqualToString:@"<"] ||
                          [currentDelimiter isEqualToString:@">="] ||
                          [currentDelimiter isEqualToString:@"<="]) &&
                         ([currentUpperCasePostDelimiterFactor integerValue] > 0))
                {
                    currentQuery = RATING;
                    if (([currentDelimiter isEqualToString:@">"] &&
                        ([game getRatingOfPlayer:playerName] <= [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@"<"] &&
                        ([game getRatingOfPlayer:playerName] >= [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@">="] &&
                        ([game getRatingOfPlayer:playerName] < [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@"<="] &&
                        ([game getRatingOfPlayer:playerName] > [currentUpperCasePostDelimiterFactor integerValue])))
                    {
                        addGame = NO;
                        break;
                    }
                }
                else
                {
                    NSLog(@"Unrecognized arguments! Run the \"help\" argument for correct custom sorting arguments.");
                    correctArguments = NO;
                    break;
                }
            }
            else if ([currentUpperCasePreDelimiterFactor isEqualToString:@"OPPONENT"])
            {
                if ([currentDelimiter isEqualToString:@"="] &&
                    ([currentUpperCasePostDelimiterFactor isEqualToString:@"WHITE"] ||
                     [currentUpperCasePostDelimiterFactor isEqualToString:@"BLACK"]))
                {
                    currentQuery = OPPONENT_COLOR;
                    if (![[[game getColorOfPlayerOtherThan:playerName] uppercaseString] isEqualToString:currentUpperCasePostDelimiterFactor])
                    {
                        addGame = NO;
                        break;
                    }
                }
                else if ([currentDelimiter isEqualToString:@"="] &&
                         ([currentUpperCasePostDelimiterFactor isEqualToString:@"WON"]  ||
                          [currentUpperCasePostDelimiterFactor isEqualToString:@"LOST"] ||
                          [currentUpperCasePostDelimiterFactor isEqualToString:@"DRAW"]))
                {
                    currentQuery = OPPONENT_RESULT;
                    if (![[[game getResultOfPlayerOtherThan:playerName] uppercaseString] isEqualToString:currentUpperCasePostDelimiterFactor])
                    {
                        addGame = NO;
                        break;
                    }
                }
                else if (([currentDelimiter isEqualToString:@">"] ||
                          [currentDelimiter isEqualToString:@"<"] ||
                          [currentDelimiter isEqualToString:@">="] ||
                          [currentDelimiter isEqualToString:@"<="]) &&
                         ([currentUpperCasePostDelimiterFactor integerValue] > 0))
                {
                    currentQuery = OPPONENT_RATING;
                    if (([currentDelimiter isEqualToString:@">"] &&
                         ([game getRatingOfPlayerOtherThan:playerName] <= [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@"<"] &&
                         ([game getRatingOfPlayerOtherThan:playerName] >= [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@">="] &&
                         ([game getRatingOfPlayerOtherThan:playerName] < [currentUpperCasePostDelimiterFactor integerValue])) ||
                        ([currentDelimiter isEqualToString:@"<="] &&
                         ([game getRatingOfPlayerOtherThan:playerName] > [currentUpperCasePostDelimiterFactor integerValue])))
                    {
                        addGame = NO;
                        break;
                    }
                }
                else
                {
                    NSRange test1 = [currentPostDelimiterFactor rangeOfString:@"\\"];
                    NSRange test2 = [currentPostDelimiterFactor rangeOfString:@"\\" options: NSBackwardsSearch];
                    if ([currentDelimiter isEqualToString:@"="] && test1.location != NSNotFound && test2.location != NSNotFound)
                    {
                        currentQuery = OPPONENT;
                        NSRange opponentRange;
                        opponentRange.location = 1;
                        opponentRange.length = currentUpperCasePostDelimiterFactor.length - 2;
                        NSString *opponent = [currentUpperCasePostDelimiterFactor substringWithRange:opponentRange];
                        if (![[game getNameOfPlayerOtherThan:playerName] isEqualToString:opponent])
                        {
                            addGame = NO;
                            break;
                        }
                    }
                    else
                    {
                        NSLog(@"Unrecognized arguments! Run the \"help\" argument for correct custom sorting arguments.");
                        correctArguments = NO;
                        break;
                    }
                    
                }
            }
            else
            {
                NSLog(@"Unrecognized arguments! Run the \"help\" argument for correct custom sorting arguments.");
                correctArguments = NO;
                break;
            }
        }
        if (addGame)
        {
            [fileManager createSymbolicLinkAtPath: [[fileManager currentDirectoryPath] stringByAppendingPathComponent:game.finalFileName] withDestinationPath: [ALL_GAMES_DIR stringByAppendingPathComponent:game.finalFileName] error:&error];
            numResultsFound++;
        }
        if (!correctArguments)
            break;
    }

    if (correctArguments)
    {
        if (numResultsFound == 0)
            NSLog(@"There were no results found!");
        else if (numResultsFound == 1)
            NSLog(@"There was 1 result found!");
        else
            NSLog(@"There were %lu results found!",numResultsFound);
    }

}


- (NSString *) description
{
    NSString *returnString = @"";
    for (ChessGame *game in self.chessGames)
        returnString = [returnString stringByAppendingString:[NSString stringWithFormat:@"%@",game]];
    return returnString;
}


@end







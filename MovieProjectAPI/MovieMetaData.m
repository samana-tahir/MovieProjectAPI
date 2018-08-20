//
//  QAMovieMetaData.m
//  MovieProject
//
//  Created by Samana Tahir on 20/08/2018.
//  Copyright © 2018 Samana Tahir. All rights reserved.
//

#import "MovieMetaData.h"

@implementation MovieMetaData

#pragma mark - Methods

-(void) parseAndFillData:(NSDictionary *)dict
{
    @try {
        
        NSMutableDictionary *mutableDict = [dict mutableCopy];
        //Eliminate all null objects
        for(NSString *key in mutableDict.allKeys)
        {
            id object = [mutableDict objectForKey:key];
            if([object isKindOfClass:[NSNull class]])
            {
                [mutableDict setObject:@"" forKey:key];
            }
        }
        
        self.id = [[mutableDict objectForKey:@"id"] intValue];
        self.adult = [[mutableDict objectForKey:@"adult"] intValue];
        self.backdrop_path = [mutableDict objectForKey:@"backdrop_path"];
        self.genre_ids = [mutableDict objectForKey:@"genre_ids"];
        self.original_language = [mutableDict objectForKey:@"original_language"];
        self.original_title = [mutableDict objectForKey:@"original_title"];
        self.title = [mutableDict objectForKey:@"title"];
        self.overview = [mutableDict objectForKey:@"overview"];
        self.popularity = [[mutableDict objectForKey:@"popularity"] floatValue];
        self.poster_path = [mutableDict objectForKey:@"poster_path"];
        self.release_date = [mutableDict objectForKey:@"release_date"];
        self.video = [[mutableDict objectForKey:@"video"] intValue];
        self.vote_average = [[mutableDict objectForKey:@"vote_average"] floatValue];
        self.vote_count = [[mutableDict objectForKey:@"vote_count"]  intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"Parsing Error: %@", [exception description]);
    }
}

-(id) initWithData:(NSDictionary *)dict
{
    self = [super init];
    if(self)
    {
        [self parseAndFillData:dict];
    }
    return self;
}

@end


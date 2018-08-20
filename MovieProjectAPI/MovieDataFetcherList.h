//
//  QADataFetcher.h
//  MovieProject
//
//  Created by Samana Tahir on 20/08/2018.
//  Copyright © 2018 Samana Tahir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieDataFetcherList.h"
#import "MovieMetaData.h"

@class MovieDataFetcherList;

@protocol MovieDataFetcherDelegate <NSObject>
@optional
-(void) MovieDataFetcher:(MovieDataFetcherList *)dataFetcher didExtractData:(NSArray *)dataArray forPageNo:(int)pageNo withMaxAvailablePages:(int)totalAvailablePages;
-(void) MovieDataFetcher:(MovieDataFetcherList *)dataFetcher failedToExtractDataWithError:(NSError *)error;
@end

@interface MovieDataFetcherList : NSObject

@property (nonatomic, assign) id <MovieDataFetcherDelegate> delegate;

-(void) searchTMDBForQuery:(NSString *)query withPageNo:(int)pageNo;
-(void) getImageFromPath:(NSString *)posterPath withSize:(int)imgSize withBlock:(void (^)(NSString *imagePath))block;

@end

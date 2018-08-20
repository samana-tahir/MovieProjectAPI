//
//  MovieDataFetcher.m
//  MovieProject
//
//  Created by Samana Tahir on 20/08/2018.
//  Copyright © 2018 Samana Tahir. All rights reserved.
//

#import "MovieDataFetcherList.h"
#import "MovieConstants.h"
#import "SortingAlgo.h"

@interface MovieDataFetcherList ()
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSMutableArray *completeArray2018;
@property (nonatomic, strong) NSMutableArray *completeArray2017;
@property  BOOL completed2017;
@property  BOOL completed2018;
@end

@implementation MovieDataFetcherList

@synthesize delegate;
-(NSString *) getParamStringForDictionary:(NSDictionary *)dict{
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *allKeys = dict.allKeys;
    for(NSString *key in allKeys){
        [arr addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
    }
    return [arr componentsJoinedByString:@"&"];
}
-(void) getImageFromPath:(NSString *)posterPath withSize:(int)imgSize withBlock:(void (^)(NSString *imagePath))block{
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@%@", IMAGE_BASE_URL, PosterSizeStr(imgSize), posterPath];
    block(imagePath);
}
-(void) parseDataAndDelegate2018:(NSData *)data searchString:(NSString*)searchstr{
    int pageNo,maxPages = 1;
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [_completeArray2018 addObjectsFromArray:[jsonDict objectForKey:@"results"]];
    pageNo   = [[jsonDict objectForKey:@"page"] intValue];
    maxPages = [[jsonDict objectForKey:@"total_pages"] intValue];
    if (pageNo<maxPages){
        [self searchTMDBForQuery2018:searchstr withPageNo:pageNo+1];
        
    }else{
        _completed2018 = YES;
        [self combineResults];
    }
}
-(void) parseDataAndDelegate2017:(NSData *)data searchString:(NSString*)searchstr{
    int pageNo,maxPages = 1;
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [_completeArray2017 addObjectsFromArray:[jsonDict objectForKey:@"results"]];
    pageNo   = [[jsonDict objectForKey:@"page"] intValue];
    maxPages = [[jsonDict objectForKey:@"total_pages"] intValue];
    if (pageNo<maxPages){
        [self searchTMDBForQuery2017:searchstr withPageNo:pageNo+1];
    }else{
        _completed2017 = YES;
        [self combineResults];
    }
}
-(void)combineResults {
    if (_completed2017 && _completed2018){
        NSMutableArray *array =[NSMutableArray array];
        NSMutableArray *arrayComplete =[NSMutableArray array];
        NSMutableArray *firstNItems =[NSMutableArray array];
        [array addObjectsFromArray:_completeArray2017];
        [array addObjectsFromArray:_completeArray2018 ];
        NSArray *sorted = [[[SortingAlgo alloc] init] sortMoviesArray:array];
        if(sorted.count>10){
            firstNItems = [NSMutableArray arrayWithArray:[sorted subarrayWithRange:NSMakeRange(0, 10)]];
        }else{
            firstNItems = [NSMutableArray arrayWithArray:sorted];
        }
        for(NSDictionary *dict in firstNItems){
            MovieMetaData *metaData = [[MovieMetaData alloc] initWithData:dict];
            [arrayComplete addObject:metaData];
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(MovieDataFetcher:didExtractData:forPageNo:withMaxAvailablePages:)]){
            [self.delegate MovieDataFetcher:self didExtractData:arrayComplete forPageNo:0 withMaxAvailablePages:0];
        }
    }
}
-(void) searchTMDBForQuery:(NSString *)query withPageNo:(int)pageNo{
    _completed2017 = NO;
    _completed2018 = NO;
    [self searchTMDBForQuery2017:query withPageNo:pageNo];
    [self searchTMDBForQuery2018:query withPageNo:pageNo];
}
-(void) searchTMDBForQuery2018:(NSString *)query withPageNo:(int)pageNo{
    if (pageNo == 1){
        _completeArray2018 = [NSMutableArray array];
    }
    NSURLRequest * request = [self createRequest:query withPageNo:pageNo year18:YES];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if(error){
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if(self.delegate && [self.delegate respondsToSelector:@selector(MovieDataFetcher:failedToExtractDataWithError:)]){
                                                            [self.delegate MovieDataFetcher:self failedToExtractDataWithError:error];
                                                        }
                                                    });
                                                }else{
                                                    [self parseDataAndDelegate2018:data searchString:query];
                                                }
                                            }];
    [task resume];
    self.dataTask = task;
}
-(NSURLRequest*)createRequest:(NSString *)query withPageNo:(int)pageNo year18:(BOOL)year18 {
    int year = 2017;
    if (year18){
        year = 2018;
    }
    NSString *adultContentSettingStr = @"false";
    NSDictionary *dict = @{@"api_key" : API_KEY, @"search_type": @"ngram", @"query" : [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"include_adult" : adultContentSettingStr, @"page" : @(pageNo), @"year" : @(year) };
    NSString *parameters = [self getParamStringForDictionary:dict];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/search/movie?%@", Base_URL, parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}
-(void) searchTMDBForQuery2017:(NSString *)query withPageNo:(int)pageNo{
    if (pageNo == 1){
        _completeArray2017 = [NSMutableArray array];
    }
    NSURLRequest * request = [self createRequest:query withPageNo:pageNo year18:NO];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if(error){
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if(self.delegate && [self.delegate respondsToSelector:@selector(MovieDataFetcher:failedToExtractDataWithError:)]){
                                                            [self.delegate MovieDataFetcher:self failedToExtractDataWithError:error];
                                                        }
                                                    });
                                                }else{
                                                    [self parseDataAndDelegate2017:data searchString:query];
                                                }
                                            }];
    [task resume];
    self.dataTask = task;
}
@end


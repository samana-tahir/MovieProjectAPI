//
//  MovieConstants.h
//  MovieProjectAPI
//
//  Created by Samana Tahir on 20/08/2018.
//  Copyright © 2018 Samana Tahir. All rights reserved.
//

#define MOVIES_DATA_URL             @"https://api.themoviedb.org/3/discover/movie?primary_release_date.gte=2017-01-01&primary_release_date.lte=2018-01-01&sort_by=vote_average.desc"
#define API_KEY                     @"19290403ace1561b3149dc75f51adfe5"
#define IMAGE_BASE_URL              @"https://image.tmdb.org/t/p/"
#define Base_URL                    @"https://api.themoviedb.org/3"


#define NoOfDaysAfterWhichToRefreshConfigurationData 5
#define NextPageReloadingMaxTryCount 5

enum {
    PosterSize_w92,
    PosterSize_w154,
    PosterSize_w185,
    PosterSize_w342,
    PosterSize_w500,
    PosterSize_w780,
    PosterSize_original,
    BackdropSize_w300,
    BackdropSize_w780,
    BackdropSize_w1280,
    BackdropSize_original,
    UnknownSize,
};
#define PosterSizesList @[@"w92", @"w154", @"w185", @"w342", @"w500", @"w780", @"original", @"w300", @"w780", @"w1280", @"original"]
#define PosterSizeStr(enumVal) (enumVal < UnknownSize) ? PosterSizesList[enumVal] : @"original"

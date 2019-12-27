//
//  RestaurantsDataRepository.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "RestaurantsDataRepository.h"

@implementation RestaurantsDataRepository
NSMutableArray* restaurantsNames;
NSMutableArray* restaurantsUrls;
+ (id)sharedManager {
    static RestaurantsDataRepository *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        restaurantsNames = [[NSMutableArray alloc] init];
        restaurantsUrls = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray*)getRestaurantNames
{
    return restaurantsNames;
}
- (NSMutableArray*)getRestaurantUrls
{
    return restaurantsUrls;
}

@end

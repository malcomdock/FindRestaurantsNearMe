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

- (NSMutableArray*)GetRestaurantNames
{
    return restaurantsNames;
}
- (NSMutableArray*)GetRestaurantUrls
{
    return restaurantsUrls;
}

-(void)UpdateRestaurantNames:(NSArray*)source
{
    restaurantsNames = [source mutableCopy];
}

-(void)UpdateRestaurantUrls:(NSArray*)source
{
    restaurantsUrls = [source mutableCopy];
}

@end

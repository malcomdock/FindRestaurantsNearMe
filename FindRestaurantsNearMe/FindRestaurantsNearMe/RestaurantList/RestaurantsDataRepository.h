//
//  RestaurantsDataRepository.h
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RestaurantsDataRepository : NSObject
+ (id)sharedManager;
- (id)init;
- (NSMutableArray*)GetRestaurantNames;
- (NSMutableArray*)GetRestaurantUrls;
-(void)UpdateRestaurantNames:(NSArray*)source;
-(void)UpdateRestaurantUrls:(NSArray*)source;
@end

NS_ASSUME_NONNULL_END


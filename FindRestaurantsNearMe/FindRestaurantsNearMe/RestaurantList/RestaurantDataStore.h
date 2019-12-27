//
//  RestaurantDataStore.h
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RestaurantDataStoreDelegate <NSObject>
- (void)ReloadView;
@end
@interface RestaurantDataStore : NSObject
@property (weak, nonatomic) id <RestaurantDataStoreDelegate> delegate;
-(void)InvokeGNaviAPIRequest:(NSString*)latitude :(NSString*)longitude;
@end

NS_ASSUME_NONNULL_END

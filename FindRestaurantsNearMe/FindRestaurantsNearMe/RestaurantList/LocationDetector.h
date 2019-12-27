//
//  LocationDetector.h
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN
@protocol LocationDetectorDelegate <NSObject>
-(void)InvokeDataRequest:(NSString*)latitude :(NSString*)longitude;
@end
@interface LocationDetector : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) id <LocationDetectorDelegate> delegate;
-(void)InitLocation;
@end

NS_ASSUME_NONNULL_END

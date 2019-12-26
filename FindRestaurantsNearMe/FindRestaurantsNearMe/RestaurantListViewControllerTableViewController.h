//
//  RestaurantListViewControllerTableViewController.h
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/26.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface RestaurantListViewControllerTableViewController : UITableViewController<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@end

NS_ASSUME_NONNULL_END

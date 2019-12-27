//
//  RestaurantListViewController.h
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/26.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>
NS_ASSUME_NONNULL_BEGIN

@interface RestaurantListViewController : UITableViewController<SFSafariViewControllerDelegate> {
    
}
-(void)ReloadView;
-(void)InvokeDataRequest:(NSString*)latitude :(NSString*)longitude;
@end

NS_ASSUME_NONNULL_END

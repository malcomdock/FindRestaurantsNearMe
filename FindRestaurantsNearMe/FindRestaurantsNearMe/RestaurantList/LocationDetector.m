//
//  LocationDetector.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "LocationDetector.h"

@implementation LocationDetector

-(void)InitLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    //NSLog(@"init location");
}

- (void)locationManager:(CLLocationManager*)manager
      didUpdateLocations:(NSArray*)locations {
    CLLocation* location = [locations lastObject];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    //NSLog(@"lati %@", latitude);
    //NSLog(@"long %@", longitude);
    //stop location manager to save battely
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    
    [self.delegate InvokeDataRequest:latitude :longitude];
}


@end

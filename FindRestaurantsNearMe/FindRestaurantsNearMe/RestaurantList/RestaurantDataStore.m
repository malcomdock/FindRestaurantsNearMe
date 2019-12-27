//
//  RestaurantDataStore.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/27.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "RestaurantDataStore.h"
#import <AFNetworking/AFNetworking.h>
#import "RestaurantsDataRepository.h"
#import "FindRestaurantsNearMeKeys.h"
@implementation RestaurantDataStore


-(void)InvokeGNaviAPIRequest:(NSString*)latitude :(NSString*)longitude
{
    #warning insert your gurunavi api key here or set it from cocoa pod install prompt
    FindRestaurantsNearMeKeys *keys = [[FindRestaurantsNearMeKeys alloc] init];
    NSString *apiKey = keys.apiKey;
    //range 2 = 500 meter around the location
    NSString *range = @"2";
    //Restaurants name order
    NSString *sort = @"1";
    //100 is limit
    NSString *hitPerPage = @"100";
    [self getGNaviData:apiKey :latitude :longitude :range :sort :hitPerPage];
}

-(void)getGNaviData:(NSString*)apiKey :(NSString*)latitude :(NSString*)longitude :(NSString*)range :(NSString*)sort :(NSString*)hitPerPage
{
    NSString *gNaviRequestStr = @"https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=VALUE0&latitude=VALUE1&longitude=VALUE2&range=VALUE3&sort=VALUE4&hit_per_page=VALUE5";
    
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE0"
    withString:apiKey];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE1"
                                         withString:latitude];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE2"
    withString:longitude];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE3"
    withString:range];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE4"
    withString:sort];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE5"
    withString:hitPerPage];
    
    //NSLog(@"api,%@",gNaviRequestStr);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:gNaviRequestStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary *responseDict = responseObject;
            NSArray* restaurantsNames = [responseDict valueForKeyPath:@"rest.name"];
            NSArray* restaurantsUrls = [responseDict valueForKeyPath:@"rest.url"];
            [[RestaurantsDataRepository sharedManager] UpdateRestaurantNames:restaurantsNames];
            [[RestaurantsDataRepository sharedManager] UpdateRestaurantUrls:restaurantsUrls];
            
            [self.delegate ReloadView];
        }
    }];
    [dataTask resume];
}


@end

//
//  RestaurantListViewControllerTableViewController.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/26.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "RestaurantListViewControllerTableViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface RestaurantListViewControllerTableViewController ()

@end

@implementation RestaurantListViewControllerTableViewController
NSMutableArray* restaurantsData;
- (void)viewDidLoad {
    [super viewDidLoad];
    restaurantsData = [[NSMutableArray alloc]init];
    [self initLocation];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager*)manager
      didUpdateLocations:(NSArray*)locations {
    CLLocation* location = [locations lastObject];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSLog(@"lati %@", latitude);
    NSLog(@"long %@", longitude);
    //stop location manager to save battely
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    //insert your gnavi api key here
    NSString *apiKey = @"";
    //range 1 = 300 meter around the location
    NSString *range = @"2";
    [self getGNaviData:apiKey :latitude :longitude :range];
}

-(void)getGNaviData:(NSString*)apiKey :(NSString*)latitude :(NSString*)longitude :(NSString*)range
{
    NSString *gNaviRequestStr = @"https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=VALUE0&latitude=VALUE1&longitude=VALUE2&range=VALUE3";
    
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE0"
    withString:apiKey];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE1"
                                         withString:latitude];
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE2"
    withString:longitude];
    
    gNaviRequestStr = [gNaviRequestStr stringByReplacingOccurrencesOfString:@"VALUE3"
    withString:range];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:gNaviRequestStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"%@ %@", response, responseObject);
            NSDictionary *responseDict = responseObject;
            NSLog(@"dict %@", responseDict);
        }
    }];
    [dataTask resume];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return restaurantsData.count;//[restaurantsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    /*if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }*/
    
    cell.textLabel.text = @"";
    if (restaurantsData.count > 0)
    {
        cell.textLabel.text = restaurantsData[indexPath.row];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

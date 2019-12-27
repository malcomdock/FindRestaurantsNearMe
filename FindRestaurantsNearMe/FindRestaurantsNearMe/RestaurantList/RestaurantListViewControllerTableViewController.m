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
NSMutableArray* restaurantsNames;
NSMutableArray* restaurantsUrls;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"近くのレストラン一覧画面";
    restaurantsNames = [[NSMutableArray alloc]init];
    restaurantsUrls = [[NSMutableArray alloc]init];
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
    [self InvokeGNaviAPIRequest:latitude :longitude];
}

-(void)InvokeGNaviAPIRequest:(NSString*)latitude :(NSString*)longitude
{
    //insert your gnavi api key here
    NSString *apiKey = @"";
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
            restaurantsNames = [responseDict valueForKeyPath:@"rest.name"];
            restaurantsUrls = [responseDict valueForKeyPath:@"rest.url"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return restaurantsNames.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"";
    if (restaurantsNames.count > 0)
    {
        cell.textLabel.text = restaurantsNames[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSString *urlString = restaurantsUrls[row];
    //deal strings like "","error"
    int minimumLength = 6;
    if([urlString length] > minimumLength && [urlString rangeOfString:@"http"].location != NSNotFound)
    {
        [self OpenRestaurantPageWithSafari:urlString];
    }
    else
    {
        [self ShowAlertForNoRestaurantsURL];
    }
    
}

-(void)OpenRestaurantPageWithSafari :(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
    safari.delegate = self;
    [self presentViewController:safari animated:YES completion:nil];
}

-(void)ShowAlertForNoRestaurantsURL
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"ページエラー"
                                 message:@"お店のページ情報がありません。"
                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:nil];
    
    [alert addAction:okButton];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
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

//
//  RestaurantListViewController.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/26.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "RestaurantListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "RestaurantDataStore.h"
#import "RestaurantsDataRepository.h"
#import "LocationDetector.h"
@interface RestaurantListViewController () <RestaurantDataStoreDelegate,LocationDetectorDelegate>
@property (strong, nonatomic) RestaurantDataStore *restaurantDataStore;
@property (strong, nonatomic) LocationDetector *locationDetector;
@end

@implementation RestaurantListViewController

//NSMutableArray* restaurantsNames;
//NSMutableArray* restaurantsUrls;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"近くのレストラン一覧画面";
    //restaurantsNames = [[NSMutableArray alloc]init];
    //restaurantsUrls = [[NSMutableArray alloc]init];
    self.locationDetector = [[LocationDetector alloc] init];
    self.locationDetector.delegate = self;
    [self.locationDetector InitLocation];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)ReloadView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView setNeedsDisplay];
    });
}

-(void)InvokeDataRequest:(NSString*)latitude :(NSString*)longitude;
{
    self.restaurantDataStore = [[RestaurantDataStore alloc] init];
    self.restaurantDataStore.delegate = self;
    [self.restaurantDataStore InvokeGNaviAPIRequest:latitude :longitude];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [[RestaurantsDataRepository sharedManager] GetRestaurantNames].count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"";
    if ([[RestaurantsDataRepository sharedManager] GetRestaurantNames].count > 0)
    {
        cell.textLabel.text = [[RestaurantsDataRepository sharedManager] GetRestaurantNames][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = [indexPath row];
    NSString *urlString = [[RestaurantsDataRepository sharedManager] GetRestaurantUrls][row];
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

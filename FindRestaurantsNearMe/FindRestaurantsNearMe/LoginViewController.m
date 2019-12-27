//
//  ViewController.m
//  FindRestaurantsNearMe
//
//  Created by Yasuo Nakamura on 2019/12/26.
//  Copyright © 2019 Yasuo Nakamura. All rights reserved.
//

#import "LoginViewController.h"
#import "RestaurantListViewControllerTableViewController.h"
@interface LoginViewController()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    
}

- (void)buildUI {
    self.navigationItem.title = @"ログイン画面";
    ASAuthorizationAppleIDButton *loginButton = [ASAuthorizationAppleIDButton new];
    loginButton.frame =  CGRectMake(.0, .0, CGRectGetWidth(self.view.frame) - 40.0, 100.0);
    CGPoint origin = CGPointMake(20.0, CGRectGetMidY(self.view.frame));
    CGRect frame = loginButton.frame;
    frame.origin = origin;
    loginButton.frame = frame;
    loginButton.cornerRadius = CGRectGetHeight(loginButton.frame) * 0.25;
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)logIn:(id)sender {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    [request setRequestedScopes:@[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail]];

    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    [controller performRequests];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(nonnull ASAuthorization *)authorization
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RestaurantListViewControllerTableViewController *restaunrantViewController = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantListViewControllerTableViewController"];
    [[self navigationController] pushViewController:restaunrantViewController animated:true];
}

- (void) authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
{
    NSLog(@"sign in error");
}


@end

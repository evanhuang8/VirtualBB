//
//  ViewController.m
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "ViewController.h"
#import "VBBClient.h"

@interface ViewController () <VBBClientDelegate, FBLoginViewDelegate>

@property VBBClient *client;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginButton;

@end


@implementation ViewController

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    if (type == VBBLogin || type == VBBFBLogin){
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            // Login successful, save the access token
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [response objectForKey:@"token"];
            if (token == nil) {
                NSLog(@"Error getting token!");
            }
            [defaults setObject:token forKey:@"token"];
            [defaults synchronize];
            // Clear password
            self.passwordField.text = @"";
            // Show dashboard
            self.navigationController.navigationBarHidden = YES;
            [self performSegueWithIdentifier:@"toDashboard" sender:self];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:[response objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toRegister"]) {
        self.navigationController.title = @"Login";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize client
    self.client = [[VBBClient alloc] init];
    self.client.delegate = self;
    // Dismiss keyboards when tapping outside
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    dismissTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:dismissTap];
    // Navigation bar style
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // FB Login
    self.fbLoginButton.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"VirtualBB";
    // Check if the access token is set
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"] != nil) {
        // Jump to dashboard directly
        [self performSegueWithIdentifier:@"toDashboard" sender:self];
    }
}

- (void)dismissKeyboard {
    if (self.emailField.isFirstResponder) {
        [self.emailField resignFirstResponder];
    }
    if (self.passwordField.isFirstResponder) {
        [self.passwordField resignFirstResponder];
    }
}

- (IBAction)login:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    if (email.length > 0 && password.length > 0) {
        [self.client loginWithEmail:email andPassword:password];
    }
}

- (IBAction)register:(id)sender {
    self.title = @"Back";
    [self performSegueWithIdentifier:@"toRegister" sender:self];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    NSString *fbID = user.id;
    [self.client loginWithFacebookUserID:fbID];
}

@end

//
//  RegisterVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "RegisterVC.h"
#import "VBBClient.h"

@interface RegisterVC () <VBBClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property VBBClient *client;

@end

@implementation RegisterVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
        // Login successful, save the access token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [response objectForKey:@"token"];
        [defaults setObject:token forKey:@"token"];
        [defaults synchronize];
        // Clear passwords
        self.passwordField.text = @"";
        self.confirmPasswordField.text = @"";
        // Show dashboard
        [self performSegueWithIdentifier:@"toDashboard" sender:self];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:[response objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [[VBBClient alloc] init];
    self.client.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [super viewWillDisappear:animated];
}

- (IBAction)register:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    if (email.length > 0 && password.length > 0) {
        if (![password isEqualToString:confirmPassword]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:@"Your passwords do not match, please double check!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [self.client registerWithEmail:email andPassword:password];
    }
}

@end

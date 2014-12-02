//
//  ViewController.m
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "ViewController.h"
#import "HomepageViewController.h"
#import "VBBClient.h"

@interface ViewController()<VBBClientDelegate>

@property VBBClient *client;

@end


@implementation ViewController
@synthesize txtUsername, txtPassword,client;

- (void)requestForType:(VBBRequestType)type withResponse:(NSDictionary *)response {
    if (type == VBBLogin){
        NSString *result=[response valueForKey:@"status"];
        if ([result isEqualToString:@"OK"] ){
            //push the homepage vc to the navi controller.
            HomepageViewController *homepage =[[HomepageViewController alloc]init];
            [self.navigationController pushViewController:homepage animated:YES];
        }
        else {
            //prop the user to try again
            //could split the error string and customize error handling & pop message. All error msg
            //starts with a Failed.
            [self popMsg:result :@"Please try again" :1];
        }
    }
}

- (IBAction)signIn:(id)sender {
    NSLog(@"The user name is: %@ and the password is %@",txtUsername.text,txtPassword.text);
    [client loginWithEmail:txtUsername.text andPassword:txtPassword.text];
}


- (void) popMsg:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [[VBBClient alloc] init];
    self.client.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

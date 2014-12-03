//
//  RetrieveSnapShotVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RetrieveSnapShotVC.h"
#import "VBBClient.h"

@interface RetrieveSnapShotVC () <AVCaptureMetadataOutputObjectsDelegate, VBBClientDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property VBBClient *client;

@end

@implementation RetrieveSnapShotVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // Create client
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    self.client = [[VBBClient alloc] initWithToken:token];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}


@end

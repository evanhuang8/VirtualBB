//
//  RetrieveSnapShotVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "RetrieveSnapShotVC.h"
#import "SnapShotListVC.h"
#import "VBBClient.h"

@interface RetrieveSnapShotVC () <AVCaptureMetadataOutputObjectsDelegate, VBBClientDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property VBBClient *client;
@property NSArray *snapshots;

@end

@implementation RetrieveSnapShotVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    if (type == VBBRetrieveSnapShots) {
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            // SnapShots retrieved
            self.snapshots = [response objectForKey:@"snapshots"];
            NSLog(@"Total of %ld snapshots retrieved.", self.snapshots.count);
            [self performSegueWithIdentifier:@"toList" sender:self];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:@"This is not a valid VBB tag, please try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Restart the reader
        [self startReadingTag];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toList"]) {
        SnapShotListVC *listVC = (SnapShotListVC *)segue.destinationViewController;
        listVC.assets = self.snapshots;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    // Create client
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    self.client = [[VBBClient alloc] initWithToken:token];
    self.client.delegate = self;
    // Initialize camera
    self.captureSession = nil;
    self.previewLayer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    [self startReadingTag];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopReadingTag:NO];
    [super viewWillDisappear:animated];
}

- (BOOL)startReadingTag {
    if (self.captureSession == nil) {
        // Initialize camera
        NSError *error;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (!input) {
            NSLog(@"%@", [error localizedDescription]);
            return NO;
        }
        // Create capture session
        self.captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:input];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:output];
        // Run it in a separate thread
        dispatch_queue_t queue = dispatch_queue_create("capture", NULL);
        [output setMetadataObjectsDelegate:self queue:queue];
        [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        // Show the camera
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.preview.bounds;
        [self.preview.layer addSublayer:self.previewLayer];
        // Start capturing
        [self.captureSession startRunning];
        return YES;
    }
    return NO;
}

- (void)stopReadingTag:(BOOL)preserve {
    // Stop the session if exists
    if (self.captureSession) {
        [self.captureSession stopRunning];
        self.captureSession = nil;
    }
    // Remove the layer
    if (self.previewLayer != nil && !preserve) {
        [self.previewLayer removeFromSuperlayer];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self stopReadingTag:YES];
                NSString *tag = [metadataObj stringValue];
                [self.client retrieveSnapShotsForTag:tag];
            });
        }
    }
}

@end

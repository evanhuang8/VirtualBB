//
//  UploadSnapShotVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "UploadSnapShotVC.h"
#import "VBBClient.h"

@interface UploadSnapShotVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, VBBClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property UIImage *image;

@property VBBClient *client;

@property BOOL uploadSuccessful;

@end

@implementation UploadSnapShotVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    if (type == VBBCreateSnapShot) {
        if ([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            NSLog(@"SnapShot created!");
            self.uploadSuccessful = YES;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:@"Your snapshot has been created!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Virtual BB" message:@"Upload failed, please try again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.uploadSuccessful && buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)upload:(id)sender {
    if (self.image != nil) {
        NSData *image = UIImageJPEGRepresentation(self.image, 0.5);
        NSString *caption = self.captionField.text;
        [self.client createSnapshotForTag:self.tag withImage:image andCaption:caption];
    }
}

- (IBAction)retake:(id)sender {
    [self takePicture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preview.contentMode = UIViewContentModeScaleAspectFit;
    // Create client
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    self.client = [[VBBClient alloc] initWithToken:token];
    self.client.delegate = self;
    // Dismiss keyboards when tapping outside
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    dismissTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:dismissTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.uploadSuccessful = NO;
    if (self.shouldShowCamera) {
        [self takePicture];
    }
}

- (void)dismissKeyboard {
    if (self.captionField.isFirstResponder) {
        [self.captionField resignFirstResponder];
    }
}

- (void)takePicture {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeImage];
        camera.allowsEditing = NO;
        double delay = 0.1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:camera animated:YES completion:^{
            }];
            self.shouldShowCamera = NO;
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.preview.image = image;
    self.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end

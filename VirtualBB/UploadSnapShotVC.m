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

@interface UploadSnapShotVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VBBClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *preview;

@end

@implementation UploadSnapShotVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preview.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldShowCamera) {
        [self takePicture];
    }
}

- (void)takePicture {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeImage];
        camera.allowsEditing = NO;
        [self presentViewController:camera animated:YES completion:nil];
        self.shouldShowCamera = NO;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.preview.image = image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end

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



@end

@implementation UploadSnapShotVC

- (void)requestForType:(VBBRequestType)type withResponse:(id)response {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self takePicture];
}

- (void)takePicture {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeImage];
        camera.allowsEditing = YES;
        [self presentViewController:camera animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
}

@end

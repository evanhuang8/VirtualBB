//
//  VBBClient.m
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "VBBClient.h"
#import <AFHTTPRequestOperationManager.h>

@interface VBBClient()

@property (copy) NSString *token;
@property NSString *baseUrl;

@property AFHTTPRequestOperationManager *manager;

@end

@implementation VBBClient

- (id)init {
    self = [super init];
    self.baseUrl = @"http://104.236.43.91/";
    self.manager = [AFHTTPRequestOperationManager manager];
    return self;
}

- (id)initWithToken:(NSString *)token {
    self = [super init];
    self.baseUrl = @"http://104.236.43.91/";
    self.manager = [AFHTTPRequestOperationManager manager];
    self.token = token;
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    NSString *url = [NSString stringWithFormat:@"%@login/", self.baseUrl];
    dispatch_queue_t queue = dispatch_queue_create("vbbclient", NULL);
    dispatch_async(queue, ^{
        [self.manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBLogin withResponse:responseObject];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.delegate) {
                NSDictionary *response = @{@"status": @"FAIL",
                                           @"message": @"Unknown error has occurred!"};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBLogin withResponse:response];
                });
            }
        }];
    });
}

- (void)loginWithFacebookUserID:(NSString *)fbID {
    NSDictionary *params = @{@"fbid": fbID};
    NSString *url = [NSString stringWithFormat:@"%@fblogin/", self.baseUrl];
    dispatch_queue_t queue = dispatch_queue_create("vbbclient", NULL);
    dispatch_async(queue, ^{
        [self.manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBFBLogin withResponse:responseObject];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.delegate) {
                NSDictionary *response = @{@"status": @"FAIL",
                                           @"message": @"Unknown error has occurred!"};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBFBLogin withResponse:response];
                });
            }
        }];
    });
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    NSString *url = [NSString stringWithFormat:@"%@register/", self.baseUrl];
    dispatch_queue_t queue = dispatch_queue_create("vbbclient", NULL);
    dispatch_async(queue, ^{
        [self.manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBRegister withResponse:responseObject];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.delegate) {
                NSDictionary *response = @{@"status": @"FAIL",
                                           @"message": @"Unknown error has occurred!"};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBRegister withResponse:response];
                });
            }
        }];
    });
    
}

- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image andCaption:(NSString *)caption {
    NSDictionary *params = @{@"tag": tag,
                             @"caption": caption,
                             @"token": self.token};
    NSString *url = [NSString stringWithFormat:@"%@create/", self.baseUrl];
    dispatch_queue_t queue = dispatch_queue_create("vbbclient", NULL);
    dispatch_async(queue, ^{
        AFHTTPRequestOperation *request = [self.manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSString *imageName = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            imageName = [NSString stringWithFormat:@"%@.jpg", imageName];
            [formData appendPartWithFileData:image name:@"image" fileName:imageName mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBCreateSnapShot withResponse:responseObject];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.delegate) {
                NSDictionary *response = @{@"status": @"FAIL",
                                           @"message": @"Unknown error has occurred!"};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBCreateSnapShot withResponse:response];
                });
            }
        }];
        [request start];
    });
}

- (void)retrieveSnapShotsForTag:(NSString *)tag {
    NSDictionary *params = @{@"tag": tag, @"token": self.token};
    NSString *url = [NSString stringWithFormat:@"%@list/", self.baseUrl];
    dispatch_queue_t queue = dispatch_queue_create("vbbclient", NULL);
    dispatch_async(queue, ^{
        [self.manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (self.delegate) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBRetrieveSnapShots withResponse:responseObject];
                });
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.delegate) {
                NSDictionary *response = @{@"status": @"FAIL",
                                           @"message": @"Unknown error has occurred!"};
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate requestForType:VBBRetrieveSnapShots withResponse:response];
                });
            }
        }];
    });
}

- (void)getCommentsForSnapshot:(NSString *)snapshot {
    
}

@end

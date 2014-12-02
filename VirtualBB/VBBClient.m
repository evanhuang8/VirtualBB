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

- (id)initWithToken:(NSString *)token {
    self = [super init];
    self.token = token;
    self.baseUrl = @"http://dev.virtualbb.com/";
    self.manager = [AFHTTPRequestOperationManager manager];
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *response = @{@"status": @"OK", @"token": @"token"};
    if (self.delegate) {
        [self.delegate requestForType:VBBLogin withResponse:response];
    }
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *response = @{@"status": @"OK", @"token": @"token"};
    if (self.delegate) {
        [self.delegate requestForType:VBBRegister withResponse:response];
    }
    
}

- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image {
    
}

- (void)retrieveSnapShotsForTag:(NSString *)tag {
    
}

- (void)getCommentsForSnapshot:(NSString *)snapshot {
    
}

@end

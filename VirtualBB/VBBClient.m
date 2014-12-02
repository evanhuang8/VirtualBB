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
    self.baseUrl = @"http://dev.virtualbb.com:8080/";
    self.manager = [AFHTTPRequestOperationManager manager];
    return self;
}

- (id)initWithToken:(NSString *)token {
    self = [super init];
    self.baseUrl = @"http://dev.virtualbb.com:8080/";
    self.manager = [AFHTTPRequestOperationManager manager];
    self.token = token;
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    NSString *url = [NSString stringWithFormat:@"%@login/", self.baseUrl];
    [self.manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            [self.delegate requestForType:VBBLogin withResponse:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate) {
            NSDictionary *response = @{@"status": @"FAIL",
                                       @"message": @"Unknown error has occurred!"};
            [self.delegate requestForType:VBBLogin withResponse:response];
        }
    }];
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password {
    NSDictionary *params = @{@"email": email,
                             @"password": password};
    NSString *url = [NSString stringWithFormat:@"%@register/", self.baseUrl];
    [self.manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.delegate) {
            [self.delegate requestForType:VBBRegister withResponse:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.delegate) {
            NSDictionary *response = @{@"status": @"FAIL",
                                       @"message": @"Unknown error has occurred!"};
            [self.delegate requestForType:VBBRegister withResponse:response];
        }
    }];
    
}

- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image {
    
}

- (void)retrieveSnapShotsForTag:(NSString *)tag {
    
}

- (void)getCommentsForSnapshot:(NSString *)snapshot {
    
}

@end

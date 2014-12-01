//
//  VBBClient.m
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "VBBClient.h"

@interface VBBClient()

@property (copy) NSString *token;

@end

@implementation VBBClient

- (id)initWithToken:(NSString *)token {
    self = [super init];
    self.token = token;
    return self;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
    
}

- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password {
    
}

- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image {
    
}

- (void)retrieveSnapShotsForTag:(NSString *)tag {
    
}

- (void)getCommentsForSnapshot:(NSString *)snapshot {
    
}

@end

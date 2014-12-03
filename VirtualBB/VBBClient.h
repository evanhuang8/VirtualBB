//
//  VBBClient.h
//  VirtualBB
//
//  Created by Evan Huang on 12/1/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VBBRequestType) {
    VBBLogin,
    VBBFBLogin,
    VBBRegister,
    VBBCreateSnapShot,
    VBBRetrieveSnapShots,
    VBBGetComments
};

@protocol VBBClientDelegate <NSObject>

- (void)requestForType:(VBBRequestType)type withResponse:(id)response;

@end

@interface VBBClient : NSObject

@property id<VBBClientDelegate> delegate;

- (id)initWithToken:(NSString *)token;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)loginWithFacebookUserID:(NSString *)fbID;
- (void)registerWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)createSnapshotForTag:(NSString *)tag withImage:(NSData *)image andCaption:(NSString *)caption;
- (void)retrieveSnapShotsForTag:(NSString *)tag;
- (void)getCommentsForSnapshot:(NSString *)snapshot;

@end

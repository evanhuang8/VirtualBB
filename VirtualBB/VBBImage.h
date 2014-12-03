//
//  VBBImage.h
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VBBImageDelegate <NSObject>

- (void)imageGotTapped:(id)image;

@end

@interface VBBImage : UIView

@property NSDictionary *data;
@property UIImage *image;

- (id)initWithFrame:(CGRect)frame andWithData:(NSDictionary *)data andWithDelegate:(id<VBBImageDelegate>)delegate;

@end

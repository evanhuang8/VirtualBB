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

@property (copy) NSString *url;
@property UIImage *image;

@end

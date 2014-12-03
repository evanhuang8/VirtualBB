//
//  VBBImage.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "VBBImage.h"

@interface VBBImage ()

@property UITapGestureRecognizer *recognizer;

@property id<VBBImageDelegate> delegate;

@end

@implementation VBBImage

- (id)initWithUrl:(NSString *)url andWithDelegate:(id<VBBImageDelegate>)delegate {
    self = [super init];
    self.url = url;
    self.delegate = delegate;
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:self.recognizer];
    [self loadImage];
    return self;
}

- (void)loadImage {
    
}

- (void)tap {
    [self.delegate imageGotTapped:self];
}

@end

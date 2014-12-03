//
//  VBBImage.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <AFNetworking/UIKit+AFNetworking.h>
#import "VBBImage.h"

@interface VBBImage ()

@property UITapGestureRecognizer *recognizer;
@property UIImageView *imageView;

@property id<VBBImageDelegate> delegate;

@property NSString *baseUrl;

@end

@implementation VBBImage

- (id)initWithFrame:(CGRect)frame andWithData:(NSDictionary *)data andWithDelegate:(id<VBBImageDelegate>)delegate {
    self = [super init];
    self.baseUrl = @"http://104.236.43.91/static/media/";
    self.frame = frame;
    self.data = data;
    self.delegate = delegate;
    // Tap listener
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    self.recognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.recognizer];
    // Initialize image view
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imageView];
    // Load the image
    [self loadImage];
    return self;
}

- (void)loadImage {
    NSString *imageUrl = [[self.data objectForKey:@"fields"] objectForKey:@"image"];
    NSString *url = [NSString stringWithFormat:@"%@%@", self.baseUrl, imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:url]];
}

- (void)tap {
    [self.delegate imageGotTapped:self];
}

@end

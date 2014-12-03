//
//  SnapShotVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <AFNetworking/UIKit+AFNetworking.h>
#import "SnapShotVC.h"

@interface SnapShotVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SnapShotVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set title
    NSString *caption = [[self.data objectForKey:@"fields"] objectForKey:@"caption"];
    if (caption.length == 0) {
        caption = @"SnapShot";
    }
    self.title = caption;
    // Create at
    NSString *createdAt = [[self.data objectForKey:@"fields"] objectForKey:@"created_at"];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *creationDate = [inputFormatter dateFromString:createdAt];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    self.dateLabel.text = [NSString stringWithFormat:@"Posted at %@", [outputFormatter stringFromDate:creationDate]];
    // Load image
    NSString *imageUrl = [[self.data objectForKey:@"fields"] objectForKey:@"image"];
    NSString *url = [NSString stringWithFormat:@"http://104.236.43.91/static/media/%@", imageUrl];
    [self.imageView setImageWithURL:[NSURL URLWithString:url]];
}

@end

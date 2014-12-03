//
//  SnapShotListVC.h
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBBImage.h"

@interface SnapShotListVC :UIViewController <VBBImageDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, copy) NSArray *assets;

@end

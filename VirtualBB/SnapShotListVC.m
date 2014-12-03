//
//  SnapShotListVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "SnapShotListVC.h"
#import "SnapShotVC.h"


@interface SnapShotListVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation SnapShotListVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSnapShot"]) {
        VBBImage *image = (VBBImage *)sender;
        SnapShotVC *snapshotVC = (SnapShotVC *)segue.destinationViewController;
        snapshotVC.data = image.data;
    }
}

- (void)imageGotTapped:(id)image{
    [self performSegueWithIdentifier:@"toSnapShot" sender:image];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackboard.jpg"]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
     return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[cView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    NSDictionary *data = self.assets[indexPath.row];
    VBBImage *image = [[VBBImage alloc] initWithFrame: cell.bounds andWithData:data andWithDelegate:self];
    [image setUserInteractionEnabled:YES];
    // Add to cell
    [cell addSubview:image];
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end

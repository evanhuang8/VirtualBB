//
//  SnapShotListVC.m
//  VirtualBB
//
//  Created by Evan Huang on 12/2/14.
//  Copyright (c) 2014 Washington University. All rights reserved.
//

#import "SnapShotListVC.h"
#import "SnapShotVC.h"


@interface SnapShotListVC ()
@end

@implementation SnapShotListVC
@synthesize collectionView,dataArray;
@synthesize assets;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSnapShot"]) {
        SnapShotVC *snapshot = (SnapShotVC *)segue.destinationViewController;
    }
}

- (void)imageGotTapped:(id)image{
    [self performSegueWithIdentifier:@"toSnapshot" sender:image];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImages];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];

    // Do any additional setup after loading the view.
}
-(void)loadImages {
    assets =[[NSMutableArray alloc]init];
    NSMutableArray *section =[[NSMutableArray alloc]init];
    
    NSString *testURL=@"http://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.apple.com%2Fhome%2Fimages%2Fog.jpg%253F201410151148&imgrefurl=https%3A%2F%2Fwww.apple.com%2Fmac%2F&h=1200&w=1200&tbnid=DV49ugmyPgIGVM%3A&zoom=1&docid=1LaqRtmy_UxbDM&ei=kpJ-VK6FI4OOyATG1oGwAg&tbm=isch&iact=rc&uact=3&dur=0&page=1&ved=0CDQQMygBMAE";
    
    VBBImage *testImage = [[VBBImage alloc]initWithUrl:testURL andWithDelegate:self];
                           
    [section addObject:testImage];
    [assets addObject:section];
}

 -(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
        return [self.assets count];
}
                           
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *sectionArray = [self.assets objectAtIndex:section];
    return [sectionArray count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    UIView *asset = self.assets[indexPath.row];
    
    
    cell.backgroundColor = [UIColor redColor];
    [cell addSubview:asset];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

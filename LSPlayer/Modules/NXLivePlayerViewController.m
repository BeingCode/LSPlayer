//
//  NXLivePlayerViewController.m
//  LSPlayer
//
//  Created by next on 2020/5/4.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import "NXLivePlayerViewController.h"
#import "NXLiveVideoCoverCell.h"
#import "NTESLivePlayer.h"
//屏幕大小
#define SCREEN_W  [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height

@interface NXLivePlayerViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NTESLivePlayer *player;
/**
 初始化视频列表
 */
@property (nonatomic, strong) NSMutableArray *defaultVideoList;


@property (nonatomic, assign) NSInteger currentIndex;


@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end





@implementation NXLivePlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.defaultVideoList = @[@"rtmp://pili-live-rtmp.weipaitang.com/wpt-live/1903071518cLDgDW",         @"rtmp://liveplay2.weipaitang.com/live/1507210206GEWpac",
                             @"rtmp://pili-live-rtmp.weipaitang.com/wpt-live/1902182204aa3nbj", @"rtmp://pili-live-rtmp.weipaitang.com/wpt-live/1801261324ODHYMV"];
    [self moveToIndex:2];
    
//    self.navigationBar.hidden = YES;
//    self.navigationBar.backgroundColor = [UIColor clearColor];
//    [self.navigationBar setBottomLineHidden:YES];
//
//    [self.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.statusView setBackgroundColor:[UIColor clearColor]];
//
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//
//
//    [self.view bringSubviewToFront:self.navigationBar];
//    [self.view bringSubviewToFront:self.statusView];
    
    
    self.navigationView.hidden = YES;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}



- (NSMutableArray *)defaultVideoList {
    if (!_defaultVideoList) {
        _defaultVideoList = @[].mutableCopy;
    }
    return _defaultVideoList;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.defaultVideoList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NXLiveVideoCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NXLiveVideoCoverCell" forIndexPath:indexPath];
    cell.coverUrl = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3468747996,929246054&fm=26&gp=0.jpg";
    return cell;
}



#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (!self.isLoading) {
//        NSLog(@"???????????????????????????????????");
//    }
//}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self endDisplayingCell:(NXLiveVideoCoverCell *)cell forItemAtIndexPath:indexPath];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showCurrentVideo];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height + 20 && self.defaultVideoList.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"已经是最后一个视频了");
        });
    }
}


- (void)endDisplayingCell:(NXLiveVideoCoverCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"...");
}


- (void)showAtIndex:(NSInteger)index cell:(NXLiveVideoCoverCell *)cell {
    if (self.currentIndex != index) {
        self.currentIndex = index;
        if (cell) {
            [self.player releasePlayer];
            [self.player removeFromSuperview];
            self.player = [[NTESLivePlayer alloc] init];
            [self.player startPlay:_defaultVideoList[index] inView:cell.containerView isFull:YES];
        }
    }
    
   
    
    
    //如果是当前视频 return
    
//    NTESLiveRoomModel *rModel = self.defaultVideoList[index];
//    if (self.currentLiveId == rModel.liveId) {
//        return;
//    }
//
////    if (self.playerManager.currentIndex == index ) {
////        return;
////    }
////    if(cell) {
////        [self.playerManager removePlayView];
////        [cell addPlayer:self.playerManager.listPlayer];
////        [self.playerManager playAtIndex:index];
////    }
//
//    if (cell) {
////        NTESLiveRoomModel *rModel = self.defaultVideoList[index];
//        self.currentLiveId = rModel.liveId;
//
//        [self.playerView releasePlayer];
//        [self.playerView removeFromSuperview];
//        self.playerView = [[NTESLivePlayerView alloc] init];
//        self.playerView.delegate = self;
//        [self.playerView startPlay:rModel.pullUrl];
//        [cell addPlayerView:self.playerView];
//        [self requesRoomInfosWithId:rModel.liveId];
//    }

}


- (void)showCurrentVideo {
    NSInteger index = self.collectionView.contentOffset.y / SCREEN_H;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    NXLiveVideoCoverCell *cell = (NXLiveVideoCoverCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self showAtIndex:index cell:cell];
}



//视图移动到哪个位置
- (void)moveToIndex:(NSInteger)index {
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    if (self.defaultVideoList.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            } completion:^(BOOL finished) {
                [self showCurrentVideo];
            }];
        });
    }
}


- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGestureRecognizer.cancelsTouchesInView = YES;
    }
    return _tapGestureRecognizer;
}



- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.view.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backImageView.image = [UIImage imageNamed:@"icon_live_bg"];
        _collectionView.backgroundView = backImageView;

        [_collectionView registerClass:[NXLiveVideoCoverCell class] forCellWithReuseIdentifier:@"NXLiveVideoCoverCell"];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _collectionView;
}

@end


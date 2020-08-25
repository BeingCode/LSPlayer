//
//  NXLiveVideoCoverCell.h
//  LSPlayer
//
//  Created by next on 2020/5/4.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NXLiveVideoCoverCell : UICollectionViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, copy) NSString *coverUrl;
- (void)addPlayerView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

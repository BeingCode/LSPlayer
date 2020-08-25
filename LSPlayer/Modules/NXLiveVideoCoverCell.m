//
//  NXLiveVideoCoverCell.m
//  LSPlayer
//
//  Created by next on 2020/5/4.
//  Copyright © 2020 ysscw. All rights reserved.
//

#import "NXLiveVideoCoverCell.h"

@interface NXLiveVideoCoverCell ()
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIView *effectView;
@end

@implementation NXLiveVideoCoverCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews {
    [self.contentView addSubview:self.coverImgView];
    [self.contentView addSubview:self.effectView];
    [self.contentView addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    
    [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.coverImgView);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)setCoverUrl:(NSString *)coverUrl {
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
}

- (void)addPlayerView:(UIView *)view {
    view.frame = self.contentView.bounds;
    [self.contentView addSubview:view];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = UIView.new;
        _containerView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [[UIImageView alloc] init];
        _coverImgView.clipsToBounds = YES;
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        [_coverImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _coverImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    }
    return _effectView;
}

@end

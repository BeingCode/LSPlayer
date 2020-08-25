//
//  UIView+MBPHUD.h
//  ysscw_ios
//
//  Created by next on 2018/8/27.
//  Copyright © 2018年 ysscw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, MBPHUDProgressStyle) {
    /// UIActivityIndicatorView.
    MBPHUDModeIndeterminate,
    /// A round, pie-chart like, progress view.
    MBPHUDModeDeterminate,
    /// Horizontal progress bar.
    MBPHUDModeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    MBPHUDModeAnnularDeterminate
};

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MBPHUD)

@property (weak, nonatomic) MBProgressHUD *hud;

- (void)showHUD;
- (void)showHUDWithMessage:(nullable NSString *)message;
- (void)showHUDMessage:(NSString *)message delay:(NSTimeInterval)delay completion:(nullable void(^)(void))completion;
- (void)showHUDMessage:(NSString *)message;
- (void)showHUDMessage:(NSString *)message inView:(UIView *)view;

- (void)showHUDWithImage:(UIImage *)image;
- (void)showHUDWithImage:(UIImage *)image message:(nullable NSString *)message;

- (void)showHUDProgressHUD;
- (void)showHUDProgressInView:(UIView *)view;
- (void)showHUDProgressWithAlpha:(CGFloat)alpha;
- (void)showHUDProgressWithMessage:(nullable NSString *)message;
- (void)showHUDProgressWithMessage:(nullable NSString *)message style:(MBPHUDProgressStyle)style;
- (void)updateHUDProgress:(CGFloat)progress;

- (void)hideHUD;
- (void)hideHUDInView:(UIView *)view;
- (void)hideHUDCompletion:(nullable void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END


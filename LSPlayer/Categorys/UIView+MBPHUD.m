//
//  UIView+MBPHUD.m
//  ysscw_ios
//
//  Created by next on 2018/8/27.
//  Copyright © 2018年 ysscw. All rights reserved.
//

#import "UIView+MBPHUD.h"

#define MBPHUD_EXECUTE(...) \
__weak typeof(self) wself = self; \
[self hideHUDCompletion:^{ \
[wself.hud removeFromSuperview]; \
    __VA_ARGS__ \
}];

CGFloat const MBPHUDFontSize = 14;
CGFloat const MBPHUDDelayTime = 1.5f;

@implementation UIView (MBPHUD)

@dynamic hud;

-(MBProgressHUD *)hud{
    
     return [MBProgressHUD HUDForView:self];
}

- (MBProgressHUD *)instanceHUD {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = UIColor.whiteColor;
    hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.8];
    hud.label.font = RegularFont(MBPHUDFontSize);
    return hud;
}

- (void)showHUD {
    [self showHUDWithMessage:nil];
}

- (void)showHUDWithMessage:(nullable NSString *)message {
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
    })
}

- (void)showHUDMessage:(NSString *)message delay:(NSTimeInterval)delay completion:(nullable void(^)(void))completion {
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 12.0;
        hud.label.numberOfLines = 3;
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:delay];
        [hud setCompletionBlock:^{
            completion();
        }];
    })
}

- (void)showHUDMessage:(NSString *)message {
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 12.0;
        hud.label.numberOfLines = 3;
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:MBPHUDDelayTime];
    })
}

- (void)showHUDMessage:(NSString *)message inView:(UIView *)view {
    __block UIView *tView = nil;
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 12.0;
        hud.label.numberOfLines = 3;
        hud.label.text = message;
        tView = view ? view : UIApplication.sharedApplication.keyWindow;
        [tView addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:MBPHUDDelayTime];
    })
}


- (void)showHUDWithImage:(UIImage *)image {
    
    [self showHUDWithImage:image message:nil];
}


- (void)showHUDWithImage:(UIImage *)image message:(nullable NSString *)message {
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:MBPHUDDelayTime];
    })
}

- (void)showHUDProgressHUD {
    [self showHUDProgressWithMessage:nil];
}

- (void)showHUDProgressInView:(UIView *)view {
    __block UIView *tView = nil;
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        tView = view ? view : UIApplication.sharedApplication.keyWindow;
        [tView addSubview:hud];
        [hud showAnimated:YES];
    })
}


- (void)showHUDProgressWithAlpha:(CGFloat)alpha {
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself instanceHUD];
        hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:alpha];
        [self addSubview:hud];
        [hud showAnimated:YES];
    })
}


- (void)showHUDProgressWithMessage:(nullable NSString *)message {
    [self showHUDProgressWithMessage:message style:MBPHUDModeIndeterminate];
}


- (void)showHUDProgressWithMessage:(nullable NSString *)message style:(MBPHUDProgressStyle)style{
    MBPHUD_EXECUTE({
        MBProgressHUDMode mode = MBProgressHUDModeIndeterminate;
        if (style == MBPHUDModeIndeterminate) mode = MBProgressHUDModeIndeterminate;
        if (style == MBPHUDModeDeterminate) mode = MBProgressHUDModeDeterminate;
        if (style == MBPHUDModeDeterminateHorizontalBar) mode = MBProgressHUDModeDeterminateHorizontalBar;
        if (style == MBPHUDModeAnnularDeterminate) mode = MBProgressHUDModeAnnularDeterminate;
        MBProgressHUD *hud = [wself instanceHUD];
        hud.mode = mode;
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
    })
    
}

- (void)updateHUDProgress:(CGFloat)progress {
    self.hud.progress = progress;
}


- (void)hideHUD {
    [self hideHUDCompletion:nil];
}


- (void)hideHUDInView:(UIView *)view {
    if (!view) {
        view = UIApplication.sharedApplication.keyWindow;
    }
    [view hideHUDCompletion:nil];
}


- (void)hideHUDCompletion:(nullable void(^)(void))completion {
    if (!self.hud) { if (completion) completion(); return; }
    self.hud.completionBlock = completion;
    [self.hud hideAnimated:YES];
}
@end

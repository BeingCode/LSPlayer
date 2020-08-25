//
//  UIView+NTESHud.m
//  ysscw_ios
//
//  Created by next on 2019/11/23.
//  Copyright © 2019 ysscw. All rights reserved.
//

#import "UIView+NTESHud.h"

#define MBPHUD_EXECUTE(...) \
__weak typeof(self) wself = self; \
[self hideLoadingHUDCompletion:^{ \
[wself.hud removeFromSuperview]; \
__VA_ARGS__ \
}];

CGFloat const NTESHUDFontSize = 14;
CGFloat const NTESHUDDelayTime = 1.5f;

@implementation UIView (NTESHud)

//- (MBProgressHUD *)hud {
//
//    return [MBProgressHUD HUDForView:self];
//}

- (MBProgressHUD *)shareHUD {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.contentColor = UIColor.whiteColor;
    hud.bezelView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0];
    hud.label.font = RegularFont(NTESHUDFontSize);
    return hud;
}

- (void)showLoadingHUD {
    
   [self showLoadingHUDWithMessage:nil];
}

- (void)showLoadingHUDWithMessage:(nullable NSString *)message {
    [self showLoadingHUDWithMessage:message style:MBPHUDModeIndeterminate];
}

- (void)showLoadingHUDWithMessage:(nullable NSString *)message style:(MBPHUDProgressStyle)style{
    MBPHUD_EXECUTE({
        MBProgressHUD *hud = [wself shareHUD];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = message;
        [wself addSubview:hud];
        [hud showAnimated:YES];
    })
}

- (void)hideLoadingHUD {
    [self hideLoadingHUDCompletion:nil];
}

- (void)hideLoadingHUDCompletion:(nullable void(^)(void))completion {
    if (!self.hud) { if (completion) completion(); return; }
    self.hud.completionBlock = completion;
    [self.hud hideAnimated:YES];
}

@end

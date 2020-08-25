//
//  UIView+NTESHud.h
//  ysscw_ios
//
//  Created by next on 2019/11/23.
//  Copyright © 2019 ysscw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (NTESHud)
- (void)showLoadingHUD;
- (void)showLoadingHUDWithMessage:(nullable NSString *)message;
- (void)hideLoadingHUD;
- (void)hideLoadingHUDCompletion:(nullable void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END

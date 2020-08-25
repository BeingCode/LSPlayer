//
//  NTESAutoRemoveNotification.h
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//


#import <Foundation/Foundation.h>

//使用这个类进行NSNotificaiton的传送，取消其他方法
@interface NTESAutoRemoveNotification : NSObject

+ (void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender;

@end

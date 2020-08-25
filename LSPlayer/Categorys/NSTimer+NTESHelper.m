//
//  NSTimer+NTESHelper.m
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//


#import "NSTimer+NTESHelper.h"

@implementation NSTimer (NTESHelper)

+ (NSTimer *)ntes_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)())inBlock repeats:(BOOL)inRepeats {
    void(^block)() = [inBlock copy];
    NSTimer *timer = [self scheduledTimerWithTimeInterval:inTimeInterval
                                                   target:self
                                                 selector:@selector(__excuteTimerBlock:)
                                                 userInfo:block
                                                  repeats:inRepeats];
    return timer;
}

+ (NSTimer *)ntes_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats {
    void (^block)() = [inBlock copy];
    NSTimer *timer = [self timerWithTimeInterval:inTimeInterval
                                          target:self
                                        selector:@selector(__excuteTimerBlock:)
                                        userInfo:block
                                         repeats:inRepeats];
    return timer;
}

+ (void)__excuteTimerBlock:(NSTimer *)inTimer {
    if ([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end

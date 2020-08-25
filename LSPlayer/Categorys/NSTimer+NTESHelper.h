//
//  NSTimer+NTESHelper.h
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSTimer (NTESHelper)

+ (NSTimer *)ntes_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void(^)())inBlock repeats:(BOOL)inRepeats;

+ (NSTimer *)ntes_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;



@end

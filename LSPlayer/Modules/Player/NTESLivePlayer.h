//
//  NTESLivePlayer.h
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RealReachability/RealReachability.h>
#import <NMCLiveStreaming/NMCLiveStreaming.h>
#import <NELivePlayerFramework/NELivePlayer.h>
#import <NELivePlayerFramework/NELivePlayerController.h>
//NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NTESPlayType) {
    
    NTESPlayTypeNone = 0,
    NTESPlayTypeVideo,
    NTESPlayTypeAudio,
    NTESPlayTypeVideoAndAudio
};


typedef NS_ENUM(NSInteger, NTESPlayError) {
    /**
     * 播放器初始化失败导致结束
     */
    NTESPlayErrorPlayerError,
    
    /**
     * 视频文件初始化失败导致结束
     */
    NTESPlayErrorPreparedError,
    
    /**
     * 网络重连失败导致结束
     */
    NTESPlayErrorNetRetryFail,
    
    /**
     * 网络已连接
     */
    NTESPlayErrorNetConnected,
    
    /**
     * 正常播放结束
     */
    NTESPlayErrorPlaybackEnded,

    /**
     * 播放发生错误导致结束
     */
    NETSPlayErrorPlaybackError
};


@interface NTESLivePlayer : UIView
@property (nonatomic, readonly) id <NELivePlayer> player;

@property (nonatomic, assign) NTESPlayType playType; //播放类型

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, assign) BOOL isPaused;

@property (nonatomic, assign) NSInteger currentIndex; //当前正在播放

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view isFull:(BOOL)isFull;
- (void)updatePlayInView:(UIView *)view;
- (void)releasePlayer;
- (void)retry;


//子类重载
- (void)doStartPlay;
- (void)doPlayViaWWAN;
- (void)doPlayComplete:(NSError *)error;
//- (void)doPlayUrlType: (NTESPlayType)playType;
@end

//NS_ASSUME_NONNULL_END

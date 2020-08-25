//
//  NTESLivePlayer.m
//  LSPlayer
//
//  Created by next on 2019/10/18.
//  Copyright © 2019 ysscw. All rights reserved.
//

#import "NTESLivePlayer.h"
#import "UIView+NTESHud.h"
#import "UIView+Toast.h"
#import "NTESAutoRemoveNotification.h"

@interface NTESLivePlayer ()
@property (nonatomic, assign) BOOL needRecoverPlay;

@property (nonatomic, copy) NSString *playUrl;

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, strong) NELivePlayerController *player;

@end

NSString *const NTESPlayErrorDomain = @"NTESPlayErrorDomain";

@implementation NTESLivePlayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isFullScreen = YES;
        
        _isMute = NO;
        
        [NTESAutoRemoveNotification addObserver:self
                                       selector:@selector(livePlayerDidPreparedToPlay:)
                                           name:NELivePlayerDidPreparedToPlayNotification
                                         object:nil];
        
        [NTESAutoRemoveNotification addObserver:self
                                       selector:@selector(livePlayerPlayBackFinished:)
                                           name:NELivePlayerPlaybackFinishedNotification
                                         object:nil];
        
        [NTESAutoRemoveNotification addObserver:self
                                       selector:@selector(livePlayerloadStateChanged:)
                                           name:NELivePlayerLoadStateChangedNotification
                                         object:nil];
        
        [NTESAutoRemoveNotification addObserver:self
                                       selector:@selector(livePlayerSeekComplete:)
                                           name:NELivePlayerMoviePlayerSeekCompletedNotification
                                         object:nil];
        //网络监听
        [NTESAutoRemoveNotification addObserver:self
                                       selector:@selector(onNetwokingChanged:)
                                           name:kRealReachabilityChangedNotification
                                         object:nil];
        //[self setupUI];
        
        [self initData];
    }
    return self;
}


- (void)dealloc {

    [self releasePlayer];
}


- (void)initData {
    
    self.currentIndex = -1;
}


//- (void)setupUI {
//
//    [self addSubview:self.player.view];
//}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//    __weak typeof(self) wself = self;
//    [self.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(wself);
//    }];
//}

#pragma mark - 通知
//开始播放
- (void)livePlayerDidPreparedToPlay:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //取消菊花
    [self.player.view hideLoadingHUD];
    
    //判断类型
    [self doPlayUrlType:[self playType]];
    
    [self.player play];
    
    [self doStartPlay];
}

//结束播放
- (void)livePlayerPlayBackFinished:(NSNotification*)notification
{
    //取消菊花
    [self.player.view hideLoadingHUD];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
        {
            NSLog(@"播放结束");
            NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorPlaybackEnded userInfo:@{NTES_ERROR_MSG_KEY: @"播放结束"}];
            [self doPlayComplete:error];
            break;
        }
        case NELPMovieFinishReasonPlaybackError:
        {
            NSLog(@"playback error, will retry in 5 sec.");
            
            NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NETSPlayErrorPlaybackError userInfo:@{NTES_ERROR_MSG_KEY: @"播放出错"}];
            
            [self doPlayComplete:error];
            
            break;
        }
        case NELPMovieFinishReasonUserExited:
            
            break;
            
        default:
            break;
    }
}

//缓冲状态改变
- (void)livePlayerloadStateChanged:(NSNotification *)notification
{
    NSLog(@"缓冲状态改变");
    
    NELPMovieLoadState nelpLoadState = self.player.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        NSLog(@"finish buffering");
        [self.player.view hideLoadingHUD];
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        //缓冲中
        [self.player.view showLoadingHUD];
        //这里保险一下，主播后台视频停止后并异常退出后，播放端不会收到结束通知，这里根据状态强行结束一下。
        NSError *error = [[NSError alloc] initWithDomain:NTESPlayErrorDomain code:NTESPlayErrorPlaybackEnded userInfo:nil];
        [self performSelector:@selector(doPlayComplete:) withObject:error afterDelay:30];
    }
}

//seek完成
- (void)livePlayerSeekComplete:(NSNotification *)notification
{
    if (_isPaused == NO)
    {
        [self.player play];
        [self doStartPlay];
    }
    else
    {
        [self.player pause];
    }
}


- (void)onNetwokingChanged:(NSNotification *)notification
{
    RealReachability *reachability = [RealReachability sharedInstance];
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    
    [self.player.view hideLoadingHUD];
    if (status == RealStatusNotReachable) //没有网络
    {
        //销毁
        [self.player shutdown];
        
        //重连标记
        _needRecoverPlay = YES;
        
        //10秒后重新连接
        [self.player.view showLoadingHUDWithMessage:@"重连中..."];
        [self performSelector:@selector(retryWhenNetchanged) withObject:nil afterDelay:10];
    }
    else if (status == RealStatusViaWiFi) //wifi网络
    {
        NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorNetConnected userInfo:@{NTES_ERROR_MSG_KEY: @"网络已连接"}];
        [self doPlayComplete:error];
        
        if ([reachability previousReachabilityStatus] == RealStatusNotReachable) //无 -> wifi
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(retryWhenNetchanged) object:nil];
            
            if (_needRecoverPlay)
            {
                [self retry];
            }
        }
    }
    else if (status == RealStatusViaWWAN) //3/4G网络
    {
        NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorNetConnected userInfo:@{NTES_ERROR_MSG_KEY: @"网络已连接"}];
        [self doPlayComplete:error];
        //__weak typeof(self) wself = self;
        if ([reachability previousReachabilityStatus] == RealStatusNotReachable) //无 -> 3/4G网络
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(retryWhenNetchanged) object:nil];
            
            if (_needRecoverPlay)
            {
                [self doPlayViaWWAN];
                //提示用户
                /*
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"在使用手机流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [wself doPlayComplete:nil];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [wself retry];
                }];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [self presentViewController:alertController animated:YES completion:nil];
                */
                
            }
        }
        else if ([reachability previousReachabilityStatus] == RealStatusViaWiFi) //wifi -> 3/4G网络
        {
            NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorNetConnected userInfo:@{NTES_ERROR_MSG_KEY: @"网络已连接"}];
            [self doPlayComplete:error];
            
            [self.player.view hideHUD];
            //停止播放
            [self.player shutdown];
            
            [self doPlayViaWWAN];
            
            //提示用户
            /*
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"在使用手机流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [wself doPlayComplete:nil];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [wself retry];
            }];
            [alertController addAction:action1];
            [alertController addAction:action2];
            [self presentViewController:alertController animated:YES completion:nil];
            */
        }
    }
}

#pragma mark - 网络切换逻辑
- (void)retryWhenNetchanged
{
    [self.player.view hideLoadingHUD];
    
    //关闭恢复标志
    //_needRecoverPlay = NO;
    
    //NSString *toast = [NSString stringWithFormat:@"重连失败"];
    //[self makeToast:toast duration:2.0 position:CSToastPositionCenter];
    
    NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorNetRetryFail userInfo:@{NTES_ERROR_MSG_KEY : @"网络重连失败"}];
    
    [self doPlayComplete:error];
}


- (void)retry
{
    if ([RealReachability sharedInstance].currentReachabilityStatus == RealStatusViaWWAN ||
        [RealReachability sharedInstance].currentReachabilityStatus == RealStatusViaWiFi)
    {
        //销毁
        [self releasePlayer];
        
        //开始
        [self startPlay:_playUrl inView:_containerView isFull:YES];
        
        //关闭恢复标志
        _needRecoverPlay = NO;
    }
    else
    {
//        NSString *toast = [NSString stringWithFormat:@"重连失败"];
//        [self makeToast:toast duration:2.0 position:CSToastPositionCenter];
        NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorNetRetryFail userInfo:@{NTES_ERROR_MSG_KEY : @"网络重连失败"}];
        [self doPlayComplete:error];
    }
}


#pragma mark - Private
- (NELivePlayerController *)makePlayer:(NSString *)streamUrl
{
    NELivePlayerController *player;
    [NELivePlayerController setLogLevel:NELP_LOG_DEFAULT];
    NSError *error = nil;
    player = [[NELivePlayerController alloc] initWithContentURL:[NSURL URLWithString:streamUrl] error:&error];
//    NSLog(@"error:%@, code:%ld",error.localizedDescription, (long)error.code);
//    NSLog(@"live player start version %@",[NELivePlayerController getSDKVersion]);
//    player.view.backgroundColor = UIColor.blueColor;
    [player setBufferStrategy:NELPLowDelay];
    [player setHardwareDecoder:YES];
    [player setPauseInBackground:NO];
    [player setScalingMode:NELPMovieScalingModeAspectFill];
    [player setShouldAutoplay:YES];
    [player setMute:_isMute];
    [player setPlaybackTimeout:10000];
//    [UIApplication sharedApplication].idleTimerDisabled = YES;
    return player;
}


- (void)releasePlayer
{
    [_player.view removeFromSuperview];
    [_player shutdown];
    _player = nil;
    self.currentIndex = -1;
//    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (NTESPlayType)playType
{
    BOOL isAudio = NO;
    BOOL isVideo = NO;
    NELPAudioInfo audioInfo;
    [_player getAudioInfo:&audioInfo];
    NELPVideoInfo videoInfo;
    [_player getVideoInfo:&videoInfo];
    
    isAudio = (audioInfo.sample_rate != 0);
    isVideo = !(videoInfo.width == 0 && videoInfo.height == 0);
    
    if (isAudio && isVideo)
    {
        _playType = NTESPlayTypeVideoAndAudio;
    }
    else if (isAudio && !isVideo)
    {
        _playType = NTESPlayTypeAudio;
    }
    else if (!isAudio && isVideo)
    {
        _playType = NTESPlayTypeVideo;
    }
    else
    {
        _playType = NTESPlayTypeNone;
    }
    return _playType;
}


#pragma mark - Public
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view isFull:(BOOL)isFull {

    _playUrl = streamUrl;
    _containerView = view;
    
    [self.player.view removeFromSuperview];
    self.player = [self makePlayer:streamUrl];
    [self.player setScalingMode:NELPMovieScalingModeAspectFill];
    
//    if (isFull) {
//        [self.player setScalingMode:NELPMovieScalingModeAspectFill];
//    } else {
//        [self.player setScalingMode:NELPMovieScalingModeAspectFit];
//    }
  
    if (self.player) {
        [view addSubview:self.player.view];
        [self.player.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
        //播放
        if (![self.player isPreparedToPlay]) {
            
            [self.player.view showLoadingHUD];
            NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorPreparedError userInfo:@{NTES_ERROR_MSG_KEY: @"播放出错"}];
            [self performSelector:@selector(doPlayComplete:) withObject:error afterDelay:30];
            //准备播放
            [self.player prepareToPlay];
        }
        
    } else {
        [self.player.view showLoadingHUD];
        NSError *error = [NSError errorWithDomain:NTESPlayErrorDomain code:NTESPlayErrorPlayerError userInfo:@{NTES_ERROR_MSG_KEY: @"播放出错"}];
        [self performSelector:@selector(doPlayComplete:) withObject:error afterDelay:1];
    }
}


- (void)updatePlayInView:(UIView *)view {
    if (self.player) {
        [self.player.view removeFromSuperview];
        [view addSubview:self.player.view];
        [self.player.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
}


#pragma mark - 子类重载
- (void)doPlayComplete:(NSError *)error {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
};

- (void)doPlayUrlType: (NTESPlayType)playType {};

- (void)doStartPlay {};

- (void)doPlayViaWWAN {};

@end


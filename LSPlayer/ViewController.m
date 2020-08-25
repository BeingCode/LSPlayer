//
//  ViewController.m
//  LSPlayer
//
//  Created by next on 2020/8/24.
//  Copyright © 2020 next. All rights reserved.
//

#import "ViewController.h"
#import "NXLivePlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"直播框架" forState:UIControlStateNormal];
    [testButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    testButton.titleLabel.font = [UIFont systemFontOfSize:16];
    testButton.backgroundColor = UIColor.redColor;
    testButton.layer.cornerRadius = 4.0;
    testButton.clipsToBounds = YES;
    [testButton addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
   
}

- (void)testBtnClick {
    NXLivePlayerViewController *playerVC = NXLivePlayerViewController.new;
    [self.navigationController pushViewController:playerVC animated:YES];
}


@end

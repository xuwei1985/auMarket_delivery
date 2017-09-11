//
//  YPStartPageViewController.m
//  PGY
//
//  Created by zhanghe on 15/8/21.
//  Copyright (c) 2015年 com.xuwei. All rights reserved.
//

#import "AdPageViewController.h"


@interface AdPageViewController ()

@end

@implementation AdPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
    
    
    
}

-(void)initData{

}

-(void)initUI{
    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN, HEIGHT_SCREEN)];
    [self.imageView setImage:self.image];
    [self.view addSubview:self.imageView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

//
//  SPTabBarController.m
//  superenglish
//
//  Created by Mrc.cc on 16/10/13.
//  Copyright © 2016年 com.xuwei. All rights reserved.
//

#import "SPTabBarController.h"

@interface SPTabBarController ()

@end

@implementation SPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (BOOL)shouldAutorotate{
    BOOL a = self.selectedViewController.shouldAutorotate;
    return a;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIInterfaceOrientationMask o = self.selectedViewController.supportedInterfaceOrientations;;
    return o;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIInterfaceOrientation o = self.selectedViewController.preferredInterfaceOrientationForPresentation;;
//    DebugLog(@"target: %@ action : %s value : %ld",NSStringFromClass(self.selectedViewController.class),__func__,(long)o);
    return o;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

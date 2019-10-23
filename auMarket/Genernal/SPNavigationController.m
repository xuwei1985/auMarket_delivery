//
//  TBCNavigationController.m
//  TBClient
//
//  Created by Nick on 13-7-3.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "SPNavigationController.h"
//#import "YPOrderSuccessViewController.h"
#define kFloatDelayEnableLockTime (0.15f)

@interface SPNavigationController ()

/**
 *  正在滑动返回的动画
 */
@property (atomic, assign) BOOL isPopAnimating;

@end

@implementation SPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
       if (self) {
           self.delegate = self;
       }
       return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.isPopAnimating = NO;
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(handlePopGesture:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //在iOS7里面 present与pop或者push如果同时开始，不会调到navigationController delegate的willShowViewController与didShowViewController,所以会造成这几个属性不准确.
    if (![self canDoAction]) {
        [self delayConstantTimeEnableLock];
    }
}

//处理滑动返回手势 识别状态
- (void)handlePopGesture:(UIGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan)
    {
        self.isPopAnimating = YES;
    }
    else if (ges.state == UIGestureRecognizerStateChanged)
    {
        self.isPopAnimating = YES;
    }
    else
    {
        [self delayConstantTimeEnableLock];
    }
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count == 1 || self.isPopAnimating || self.isPopping || self.isPushing)
    {
        return nil;
    }
    
    self.isPopping = YES;
    return [super popViewControllerAnimated:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController || self.viewControllers.lastObject == viewController ||
        self.isPopAnimating || self.isPushing || self.isPopping)
    {
        return;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    self.isPushing = YES;
    
    [super pushViewController:viewController animated:animated];
}

- (BOOL)canDoAction
{
    return !(self.isPopAnimating || self.isPushing || self.isPopping);
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count == 1 || self.isPopAnimating || self.isPopping || self.isPushing)
    {
        return nil;
    }
    self.isPopping = YES;
    
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToTopViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        return [super popToViewController:[self.viewControllers safeObjAtIndex:0] animated:animated];
    }
    else {
        return nil;
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count == 1 || self.isPopAnimating || self.isPopping || self.isPushing)
    {
        return nil;
    }
    self.isPopping = YES;
    
    return [super popToViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //ios7、要显示顶级viewcontoller 不是滑动返回（用户点击按钮或者代码返回） 这个时候禁用滑动返回手势
    if(navigationController.topViewController == viewController && !self.isPopAnimating)
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
   
    self.interactivePopGestureRecognizer.enabled = YES;
    [self delayConstantTimeEnableLock];
}

- (void)delayConstantTimeEnableLock
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enableLock) object:nil];
    [self performSelector:@selector(enableLock) withObject:nil afterDelay:kFloatDelayEnableLockTime];
}

//恢复所有状态
- (void)enableLock
{
    self.isPushing = NO;
    self.isPopping = NO;
    self.isPopAnimating = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer)
    {
        //正在pop push 滑动返回操作、顶级viewcontroller时候 不让滑动返回手势开始。
        if (self.viewControllers.count != 1 && !self.isPopping && !self.isPushing && !self.isPopAnimating) {
            return YES;
        }
        else
        {
//            if([self.navigationController.topViewController isKindOfClass:[YPOrderSuccessViewController class]])
//            {
//                return NO;
//            }

        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer  shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - Orientation
- (BOOL)shouldAutorotate{
//    BOOL a;
//    if (![self.visibleViewController isBeingDismissed]) {
//        a = self.visibleViewController.shouldAutorotate;
//    }else{
//        a = self.viewControllers.lastObject.shouldAutorotate;
//    }
//    DebugLog(@"target: %@ auto value : %d",NSStringFromClass(self.visibleViewController.class),a);
//    return a;
    return self.topViewController.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
//    UIInterfaceOrientationMask o;
//    if (![self.visibleViewController isBeingDismissed]) {
//        o = self.visibleViewController.supportedInterfaceOrientations;
//        DebugLog(@"target: %@ orientation value : %ld from visible",NSStringFromClass(self.visibleViewController.class),o);
//    }else{
//        o = self.viewControllers.lastObject.supportedInterfaceOrientations;
//        DebugLog(@"target: %@ orientation value : %ld from top",NSStringFromClass(self.visibleViewController.class),o);
//    }
//    // portrait 2
//    // landscape 24
//    // UIInterfaceOrientationMaskAllButUpsideDown 26
//    //    DebugLog(@"target: %@ action : %s value : %ld",NSStringFromClass(self.visibleViewController.class),__func__,o);
//    return o;
    return self.topViewController.supportedInterfaceOrientations;
    
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIInterfaceOrientation o;
    if (![self.visibleViewController isBeingDismissed]) {
        o = self.visibleViewController.preferredInterfaceOrientationForPresentation;
    }else{
        o = self.viewControllers.lastObject.preferredInterfaceOrientationForPresentation;
    }
//    DebugLog(@"target: %@ action : %s value : %ld",NSStringFromClass(self.visibleViewController.class),__func__,(long)o);
    return o;
}
@end

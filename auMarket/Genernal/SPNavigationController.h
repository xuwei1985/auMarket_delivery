//
//  SPNavigationController.h
//  Youpin
//
//  Created by Nick on 13-7-3.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNavigationController : UINavigationController<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

/**
 *  是不是正在push
 */
@property (atomic,assign) BOOL isPushing;

/**
 *  是不是正在pop
 */
@property (atomic, assign) BOOL isPopping;


- (BOOL)canDoAction;

- (NSArray *)popToTopViewControllerAnimated:(BOOL)animated;

- (void)delayConstantTimeEnableLock;
@end

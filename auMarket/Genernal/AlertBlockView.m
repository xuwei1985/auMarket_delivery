//
//  AlertBlockView.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/2/17.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "AlertBlockView.h"
#define EOCMyAlertViewKey @"EOCMyAlertViewKey"
#define TIPTITLE @"提示"

@implementation AlertBlockView

DEF_SINGLETON(AlertBlockView);
- (void)showTipAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIPTITLE message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)showTipAlert:(NSString *)message completion:(choiceCompletionBlock)completion
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIPTITLE message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    objc_setAssociatedObject(alert, EOCMyAlertViewKey, completion, OBJC_ASSOCIATION_COPY);
    [alert show];
    
    
}

- (void)showChoiceAlert:(NSString *)message completion:(choiceCompletionBlock)completion
{
    [self showChoiceAlert:message doneTitle:@"确定" completion:completion];
}

- (void)showChoiceAlert:(NSString *)message doneTitle:(NSString *)doneTitile completion:(choiceCompletionBlock)completion
{
    [self showChoiceAlert:message title:TIPTITLE doneTitle:doneTitile completion:completion];
}

- (void)showChoiceAlert:(NSString *)message title:(NSString *)title doneTitle:(NSString *)doneTitle completion:(choiceCompletionBlock)completion {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:doneTitle, nil];
    objc_setAssociatedObject(alert, EOCMyAlertViewKey, completion, OBJC_ASSOCIATION_COPY);
    [alert show];
}

- (void)showChoiceAlert:(NSString *)message button1Title:(NSString *)title1 button2Title:(NSString *)title2 completion:(choiceCompletionBlock)completion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIPTITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:title1, title2, nil];
    objc_setAssociatedObject(alert, EOCMyAlertViewKey, completion, OBJC_ASSOCIATION_COPY);
    [alert show];
}

- (void)showChoiceAlert:(NSString *)message title:(NSString *)title button1Title:(NSString *)button1Title button2Title:(NSString *)button2Title completion:(choiceCompletionBlock)completion {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:button1Title, button2Title, nil];
    objc_setAssociatedObject(alert, EOCMyAlertViewKey, completion, OBJC_ASSOCIATION_COPY);
    [alert show];
}


- (void)showChoiceAlert:(NSString *)message button1Title:(NSString *)title1 button2Title:(NSString *)title2 button3Title:(NSString *)title3 completion:(choiceCompletionBlock)completion
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TIPTITLE message:message delegate:self cancelButtonTitle:nil otherButtonTitles:title1, title2, title3, nil];
    objc_setAssociatedObject(alert, EOCMyAlertViewKey, completion, OBJC_ASSOCIATION_COPY);
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    choiceCompletionBlock block = objc_getAssociatedObject(alertView, EOCMyAlertViewKey);
    if (block) {
        block((int)buttonIndex);
    }
}

@end

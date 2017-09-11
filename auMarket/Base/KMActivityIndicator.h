//
//  KMActivityIndicator.h
//  Yodablog
//
//  Created by Kevin Mindeguia on 19/08/2013.
//  Copyright (c) 2013 iKode Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface KMActivityIndicator : UIView
{
}

@property (nonatomic) BOOL hidesWhenStopped;
@property (nonatomic, strong) UIColor *color;

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color;
-(void)startAnimating;
-(void)stopAnimating;
-(BOOL)isAnimating;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

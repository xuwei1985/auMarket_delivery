//
//  YPWebViewController.h
//  Youpin
//
//  Created by douj on 15/4/29.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : SPBaseViewController{
    UILabel *_titleLbl;
    UIButton *_leftButton;
    UINavigationItem *_navigationItem;
}
@property (nonatomic,strong) NSString* url;

- (void)load;

@end

//
//  GoodsListViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/15.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"

@interface GoodsListViewController : SPBaseViewController
{
    NSString *_tid;
    NSString *_sortType;
    NSString *_keyword;
}

@property(nonatomic,retain) NSString *categoryId;
@property(nonatomic,retain) NSString *categoryName;
@property(nonatomic,retain) NSString *keyword;
@end

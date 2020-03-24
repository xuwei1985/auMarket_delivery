//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "BankCell.h"
#import "PaymentViewController.h"

@interface BankListViewController : SPBaseViewController<UINavigationControllerDelegate>
{
    NSMutableArray *_itemArr;
}
@property(nonatomic,retain) TaskItemEntity *task_entity;
@property(nonatomic,retain) NSString *order_sn;
@property(nonatomic,assign) int payment_type;
@end

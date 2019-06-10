//
//  TaskListViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/11.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "OrderDetailViewController.h"
#import "TaskItemCell.h"
#import "GoodsListItemCell.h"

@interface TaskListViewController : SPBaseViewController{
    UIButton *btn_workState;
    NSArray *taskCategory;
    UIButton *btn_waitDelivery;
    UIButton *btn_failedDelivery;
    UIButton *btn_successDelivery;
    Delivery_Status list_status_modal;//列表模式
}
@property(nonatomic,retain) NSMutableArray<TaskItemEntity *>* taskArr;
@end

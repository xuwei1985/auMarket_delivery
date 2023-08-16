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
#import "TaskConciseItemCell.h"
#import "GoodsListItemCell.h"

@interface TaskListViewController : SPBaseViewController{
    NSArray *taskCategory;
    UIButton *btn_r;
    UIButton *btn_waitDelivery;
    UIButton *btn_failedDelivery;
    UIButton *btn_successDelivery;
    Delivery_Status list_status_modal;//列表模式
    int list_show_model;//列表显示模式：0：详细视图 1：简洁视图
    int first_serial_row;//第一条有订单排序值的列表行
}
@property(nonatomic,retain) NSMutableArray<TaskItemEntity *>* taskArr;
@end

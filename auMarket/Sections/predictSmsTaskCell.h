//
//  PickOrderCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2018/5/21.
//  Copyright © 2018 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEntity.h"

typedef void(^SelDataBlock)(NSString *id,int action);

@interface predictSmsTaskCell : UITableViewCell
{
    UIButton *btn_select;
    UILabel *lbl_order_sn;
    UILabel *lbl_order_contact;
    UILabel *lbl_order_region;
    UILabel *lbl_order_tel;
    UILabel *lbl_order_address;
    UIImageView *send_mark;
    UILabel *lbl_predict_time;
    
    UILabel *lbl_order_sn_value;
    UILabel *lbl_order_contact_value;
    UILabel *lbl_order_region_value;
    UILabel *lbl_order_tel_value;
    UILabel *lbl_order_address_value;
}

@property(nonatomic,retain) TaskItemEntity *entity;
@property (nonatomic, copy) SelDataBlock selDataBlock;
@property (nonatomic, assign) int list_model;//0:待发送 1：已发送

-(void)selDataId:(SelDataBlock)block;
-(void)toggleDataSel;
@end

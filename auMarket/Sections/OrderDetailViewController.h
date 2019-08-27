//
//  UserCenterViewController.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "SPBaseViewController.h"
#import "UserLoginViewController.h"
#import "OrderDetailCell.h"
#import "PaymentViewController.h"
#import "TaskModel.h"
#import "OrderPriceChangeViewController.h"
#import "ReturnProofViewController.h"

@interface OrderDetailViewController : SPBaseViewController<UIActionSheetDelegate>
{
    UIImageView *orderInfoView;
    UILabel *lbl_payType;
    UILabel *lbl_returnPrice;
    UILabel *lbl_changePrice;
    UILabel *lbl_orderSum;
    UILabel *lbl_orderSum2;
    UILabel *lbl_orderNo;
    UILabel *lbl_contact;
    UILabel *lbl_mobile;
    UILabel *lbl_address;
    UILabel *lbl_address_replenish;//地址补充
    UILabel *lbl_deliverytime;
    UILabel *lbl_putType;
    UILabel *lbl_packagenote;
    UILabel *lbl_upstairs;
    UILabel *lbl_state;
    UILabel *lbl_box;
    UILabel *lbl_picker;
    UILabel *lbl_pick_time;
    UILabel *lbl_packer;
    UILabel *lbl_pack_time;
    UIButton *_btn_doneAction;
    UIButton *_btn_returnAction;
    CLLocationCoordinate2D coordinate;
    float return_price;
    BOOL isGotoOrderChangeView;
    Boolean isGotoReturnProofView;
}
@property(nonatomic,retain) NSString *order_id;
@property(nonatomic,retain) TaskItemEntity *task_entity;
@property(nonatomic,retain) TaskModel *model;
@end

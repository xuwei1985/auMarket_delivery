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
#import "BankListViewController.h"

@interface OrderDetailViewController : SPBaseViewController<UIActionSheetDelegate>
{
    UIImageView *orderInfoView;
    UILabel *lbl_packageNum;
    UILabel *lbl_payType;
    UILabel *lbl_returnPrice;
    UILabel *lbl_changePrice;
    UILabel *lbl_shippingPrice;
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
    UILabel *lbl_servicenote;
    UILabel *lbl_freeze_packagenote;
    UILabel *lbl_food_packagenote;
    UILabel *lbl_service_title;
    UILabel *lbl_package_title;
    UILabel *lbl_freeze_package_title;
    UILabel *lbl_food_package_title;
    UILabel *lbl_upstairs;
    UILabel *lbl_state;
    UILabel *lbl_box;
    UILabel *lbl_picker;
    UILabel *lbl_pick_time;
    UILabel *lbl_packer;
    UILabel *lbl_pack_time;
    UIButton *_btn_doneAction;
    UIButton *_btn_returnAction;
    UIView *blockView_0;
    UIView *blockView_1;
    UIView *blockView_2;
    UIView *blockView_3;
    UIView *blockView_4;
    UIView *blockView_5;
    
    UIView *blockView_21;
    UIView *blockView_22;
    UIView *blockView_23;
    CLLocationCoordinate2D coordinate;
    float return_price;
    BOOL isGotoOrderChangeView;
    Boolean isGotoReturnProofView;
}
@property(nonatomic,retain) NSString *order_id;
@property(nonatomic,assign) int goods_model;//商品模式（上货那边传值）0：加载全部商品 1：加载普通商品 2：加载冷冻商品
@property(nonatomic,retain) TaskItemEntity *task_entity;
@property(nonatomic,retain) TaskModel *model;
@end

//
//  MemberCell.h
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell
{
    UIImageView *_iconImageView;
    UILabel *_itemLbl;
    UILabel *_numLbl;
    UILabel *_priceLbl;
    UILabel *_promoteMarkLbl;
}

@property(nonatomic,retain) NSString *itemImage;
@property(nonatomic,retain) NSString *itemName;
@property(nonatomic,retain) NSString *itemNum;
@property(nonatomic,assign) float itemPrice;
@property(nonatomic,assign) BOOL isPromote;
@end

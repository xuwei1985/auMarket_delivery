//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (_iconImageView==nil) {
            _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 22, 22)];
            [self.contentView addSubview:_iconImageView];
        }
        if (_itemLbl==nil) {
            _itemLbl=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-100, 12, 90, 22)];
            _itemLbl.textAlignment=NSTextAlignmentRight;
            _itemLbl.textColor=COLOR_MAIN;
            _itemLbl.font=FONT_SIZE_MIDDLE;
            _itemLbl.hidden=YES;
            [self.contentView addSubview:_itemLbl];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.frame=CGRectMake(12, 0, 100, 44);
    self.textLabel.text=self.itemName;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

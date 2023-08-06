//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "PredictSettingCell.h"

@implementation PredictSettingCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (_iconImageView==nil) {
            _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 44, 44)];
            [self.contentView addSubview:_iconImageView];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.frame=CGRectMake(64, 10, 200, 44);
    self.textLabel.text=self.itemName;
    _iconImageView.image=self.iconImage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MemberCell.m
//  XiaoYa
//
//  Created by XuWei on 15/1/3.
//  Copyright (c) 2015年 xuwei. All rights reserved.
//

#import "MemberCell.h"

@implementation MemberCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        if (_iconImageView==nil) {
//            _iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(18, 12, 22, 22)];
//            [self.contentView addSubview:_iconImageView];
//        }
        if (_itemLbl==nil) {
            _itemLbl=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH_SCREEN-125, 12, 90, 22)];
            _itemLbl.textAlignment=NSTextAlignmentRight;
            _itemLbl.textColor=COLOR_MAIN;
            _itemLbl.font=FONT_SIZE_MIDDLE;
            _itemLbl.hidden=YES;
            [self.contentView addSubview:_itemLbl];
        }
        
        if (_mySwitch==nil) {
            _mySwitch=[[ UISwitch alloc]initWithFrame:CGRectMake(WIDTH_SCREEN-58,6.0,80.0,22.0)];
            [_mySwitch setOn:NO animated:YES];
            _mySwitch.hidden=YES;
            _mySwitch.onTintColor=COLOR_MAIN;
            [_mySwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            [self.contentView addSubview:_mySwitch];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.frame=CGRectMake(12, 0, 100, 44);
    self.textLabel.text=self.itemName;
    if(self.itemPrice==nil||self.itemPrice.length<=0){
        _itemLbl.hidden=YES;
        _mySwitch.hidden=NO;
        [_mySwitch setOn:APP_DELEGATE.isWorking animated:YES];
    }
    else{
        _itemLbl.hidden=NO;
        _mySwitch.hidden=YES;
        _itemLbl.text=self.itemPrice;
    }
}

- (void)switchValueChanged:(id)sender{
    UISwitch* control = (UISwitch*)sender;
    if(control == _mySwitch){
        BOOL on = control.on;
        //添加自己要处理的事情代码
        [APP_DELEGATE.booter handlerWorkingState:on];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

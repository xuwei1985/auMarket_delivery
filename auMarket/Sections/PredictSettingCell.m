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
        
    }
    return self;
}

-(void)initUI{
    @weakify(self);
    
    if (beginTxt==nil){
        beginTxt = [[UITextField alloc] init];
        beginTxt.delegate=self;
        beginTxt.font=DEFAULT_FONT(16);
        beginTxt.textColor=RGBCOLOR(22, 22, 22);
        beginTxt.backgroundColor=[UIColor whiteColor];
        beginTxt.returnKeyType =UIReturnKeyDone;
        beginTxt.keyboardType= UIKeyboardTypeDefault;
        beginTxt.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        beginTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
        beginTxt.layer.cornerRadius=3;
        beginTxt.clipsToBounds=YES;
        [beginTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
        [beginTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
        [self.contentView addSubview:beginTxt];
        
        @strongify(self);
        [beginTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo((self.frame.size.width-30-40)/2);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(beginArrow==nil){
        beginArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        [beginTxt addSubview:beginArrow];
        
        @strongify(self);
        [beginArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(beginTxt.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
    }
    
    if (linkLbl==nil) {
        linkLbl=[[UILabel alloc] init];
        linkLbl.font=DEFAULT_FONT(16);
        linkLbl.textColor=RGBCOLOR(22, 22, 22);
        linkLbl.text=@"-";
        linkLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:linkLbl];
        
        @strongify(self);
        [linkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(30, 36));
        }];
    }
    
    if (endTxt==nil){
        endTxt = [[UITextField alloc] init];
        endTxt.delegate=self;
        endTxt.font=DEFAULT_FONT(16);
        endTxt.textColor=RGBCOLOR(22, 22, 22);
        endTxt.backgroundColor=[UIColor whiteColor];
        endTxt.returnKeyType =UIReturnKeyDone;
        endTxt.keyboardType= UIKeyboardTypeDefault;
        endTxt.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
        endTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
        endTxt.layer.cornerRadius=3;
        endTxt.clipsToBounds=YES;
        [endTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
        [endTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
        [self.contentView addSubview:endTxt];
        
        @strongify(self);
        [endTxt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo((self.frame.size.width-30-40)/2);
            make.height.mas_equalTo(36);
        }];
    }
    
    if(endArrow==nil){
        endArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
        [endTxt addSubview:endArrow];
        
        @strongify(self);
        [endArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(endTxt.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(16);
        }];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self initUI];
    [self showData];
}

-(void)showData{
    beginTxt.text=self.begin_time;
    endTxt.text=self.end_time;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

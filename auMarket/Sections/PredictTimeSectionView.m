//
//  PredictTimeSectionView.m
//  auMarket
//
//  Created by 吴绪伟 on 2023/8/7.
//  Copyright © 2023 daao. All rights reserved.
//

#import "PredictTimeSectionView.h"

@implementation PredictTimeSectionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)initData{
    [self loadData];
}

-(void)initUI{
    timeSectionTxt = [[UITextField alloc] init];
    timeSectionTxt.delegate=self;
    timeSectionTxt.font=DEFAULT_FONT(16);
    timeSectionTxt.textColor=RGBCOLOR(22, 22, 22);
    timeSectionTxt.backgroundColor=[UIColor whiteColor];
    timeSectionTxt.returnKeyType =UIReturnKeyDone;
    timeSectionTxt.keyboardType= UIKeyboardTypeDefault;
    timeSectionTxt.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    timeSectionTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
    timeSectionTxt.layer.cornerRadius=3;
    timeSectionTxt.clipsToBounds=YES;
    timeSectionTxt.tag=5001;
    timeSectionTxt.text=@"时间段";
    [timeSectionTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    [timeSectionTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
    [self addSubview:timeSectionTxt];
    
    [timeSectionTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo((self.frame.size.width-215));
        make.height.mas_equalTo(36);
    }];
    

    confirmBtm = [[UIButton alloc] init];
    [confirmBtm addTarget:self action:@selector(requestTask) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtm setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtm setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    [confirmBtm setTitleColor:COLOR_WHITE forState:UIControlStateHighlighted];
    confirmBtm.backgroundColor = COLOR_MAIN;
    confirmBtm.layer.cornerRadius=4;
    confirmBtm.clipsToBounds=YES;
    confirmBtm.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    confirmBtm.titleLabel.textAlignment=NSTextAlignmentCenter;
    
    [self addSubview:confirmBtm];
    
    [confirmBtm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-12);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(36);
    }];
    
    requestNumTxt  = [[UITextField alloc] init];
    requestNumTxt.delegate=self;
    requestNumTxt.font=DEFAULT_FONT(16);
    requestNumTxt.textColor=RGBCOLOR(22, 22, 22);
    requestNumTxt.backgroundColor=[UIColor whiteColor];
    requestNumTxt.returnKeyType =UIReturnKeyDone;
    requestNumTxt.keyboardType= UIKeyboardTypeDefault;
    requestNumTxt.contentVerticalAlignment= UIControlContentVerticalAlignmentCenter;
    requestNumTxt.autocapitalizationType=UITextAutocapitalizationTypeNone;
    requestNumTxt.layer.cornerRadius=3;
    requestNumTxt.clipsToBounds=YES;
    requestNumTxt.tag=5002;
    requestNumTxt.text=@"20";
    [requestNumTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    [requestNumTxt setValue:[NSNumber numberWithInt:10] forKey:@"paddingRight"];
    [self addSubview:requestNumTxt];
    
    [requestNumTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(confirmBtm.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(36);
    }];
    
    requestNumLbl=[[UILabel alloc] init];
    requestNumLbl.font=DEFAULT_FONT(16);
    requestNumLbl.textColor=RGBCOLOR(22, 22, 22);
    requestNumLbl.text=@"批量数";
    requestNumLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:requestNumLbl];
    
    [requestNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(requestNumTxt.mas_left).offset(-7);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    timeSectionArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    [timeSectionTxt addSubview:timeSectionArrow];
    
    [timeSectionArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(timeSectionTxt.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    
    requestNumArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    [requestNumTxt addSubview:requestNumArrow];
    
    [requestNumArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-6);
        make.centerY.mas_equalTo(requestNumTxt.mas_centerY);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
}

-(void)loadData{
    
}

//MARK: 时间段文本框点击事件
-(void)timeSectionTaped{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(timeSectionClick:)]){
        [self.delegate timeSectionClick:timeSectionTxt];
    }
}

//MARK: 批量设置分段数的文本框点击事件
-(void)requestNumTaped{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(requestNumClick:)]){
        [self.delegate requestNumClick:requestNumTxt];
    }
}

//MARK: 请求配送订单量的点击事件
-(void)requestTask{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(confirmClick)]){
        [self.delegate confirmClick];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag==5001){
        [self timeSectionTaped];
    }else if(textField.tag==5002){
        [self requestNumTaped];
    }
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

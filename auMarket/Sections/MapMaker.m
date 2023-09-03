//
//  MapMaker.m
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/10.
//  Copyright © 2017年 daao. All rights reserved.
//

#import "MapMaker.h"

@implementation MapMaker
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
    self.markTip=@"";
    self.is_muti=NO;
}

-(void)initUI{
    lbl_markTip=[[UILabel alloc] init];
    lbl_markTip.text=@"";
    lbl_markTip.font=FONT_SIZE_MIDDLE;
    lbl_markTip.textAlignment=NSTextAlignmentCenter;
    lbl_markTip.textColor=COLOR_WHITE;
    lbl_markTip.hidden=YES;
    [self addSubview:lbl_markTip];
    
    [lbl_markTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-7);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    
    lbl_mutiMark_bottom=[[UILabel alloc] init];
    lbl_mutiMark_bottom.text=@"";
    lbl_mutiMark_bottom.font=FONT_SIZE_MIDDLE;
    lbl_mutiMark_bottom.textAlignment=NSTextAlignmentCenter;
    lbl_mutiMark_bottom.textColor=COLOR_WHITE;
    lbl_mutiMark_bottom.hidden=YES;
    lbl_mutiMark_bottom.backgroundColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1];
    lbl_mutiMark_bottom.layer.cornerRadius=2;
    lbl_mutiMark_bottom.clipsToBounds=YES;
    [self addSubview:lbl_mutiMark_bottom];
    
    [lbl_mutiMark_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15.5);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    lbl_mutiMark_top=[[UILabel alloc] init];
    lbl_mutiMark_top.text=@"";
    lbl_mutiMark_top.font=FONT_SIZE_MIDDLE;
    lbl_mutiMark_top.textAlignment=NSTextAlignmentCenter;
    lbl_mutiMark_top.textColor=COLOR_WHITE;
    lbl_mutiMark_top.hidden=YES;
    lbl_mutiMark_top.backgroundColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1];
    lbl_mutiMark_top.layer.cornerRadius=2;
    lbl_mutiMark_top.clipsToBounds=YES;
    [self addSubview:lbl_mutiMark_top];
    
    [lbl_mutiMark_top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(1);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    lbl_mutiMark_left=[[UILabel alloc] init];
    lbl_mutiMark_left.text=@"";
    lbl_mutiMark_left.font=FONT_SIZE_MIDDLE;
    lbl_mutiMark_left.textAlignment=NSTextAlignmentCenter;
    lbl_mutiMark_left.textColor=COLOR_WHITE;
    lbl_mutiMark_left.hidden=YES;
    lbl_mutiMark_left.backgroundColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1];
    lbl_mutiMark_left.layer.cornerRadius=2;
    lbl_mutiMark_left.clipsToBounds=YES;
    [self addSubview:lbl_mutiMark_left];
    
    [lbl_mutiMark_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-7);
        make.left.mas_equalTo(self.mas_left).offset(1);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    lbl_mutiMark_right=[[UILabel alloc] init];
    lbl_mutiMark_right.text=@"";
    lbl_mutiMark_right.font=FONT_SIZE_MIDDLE;
    lbl_mutiMark_right.textAlignment=NSTextAlignmentCenter;
    lbl_mutiMark_right.textColor=COLOR_WHITE;
    lbl_mutiMark_right.hidden=YES;
    lbl_mutiMark_right.backgroundColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1];
    lbl_mutiMark_right.layer.cornerRadius=2;
    lbl_mutiMark_right.clipsToBounds=YES;
    [self addSubview:lbl_mutiMark_right];
    
    [lbl_mutiMark_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(-7);
        make.right.mas_equalTo(self.mas_right).offset(-1);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
}

-(void)loadData{
    if(self.markTip!=nil&&self.markTip.length>0){
        lbl_markTip.hidden=NO;
        lbl_markTip.text=self.markTip;
    }
    else{
        lbl_markTip.hidden=YES;
    }
    
    lbl_mutiMark_top.hidden=lbl_mutiMark_bottom.hidden=lbl_mutiMark_left.hidden=lbl_mutiMark_right.hidden=!self.show_dot;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

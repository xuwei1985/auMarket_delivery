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
    
    lbl_mutiMark=[[UILabel alloc] init];
    lbl_mutiMark.text=@"";
    lbl_mutiMark.font=FONT_SIZE_MIDDLE;
    lbl_mutiMark.textAlignment=NSTextAlignmentCenter;
    lbl_mutiMark.textColor=COLOR_WHITE;
    lbl_mutiMark.hidden=YES;
    lbl_mutiMark.backgroundColor = [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:0.7];
    lbl_mutiMark.layer.cornerRadius=2.5;
    lbl_mutiMark.clipsToBounds=YES;
    [self addSubview:lbl_mutiMark];
    
    [lbl_mutiMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-13);
        make.size.mas_equalTo(CGSizeMake(5, 5));
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
    
    lbl_mutiMark.hidden=!self.show_dot;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

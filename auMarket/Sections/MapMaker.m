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
}

-(void)initUI{
    lbl_markTip=[[UILabel alloc] init];
    lbl_markTip.text=@"12";
    lbl_markTip.font=FONT_SIZE_MIDDLE;
    lbl_markTip.textAlignment=NSTextAlignmentCenter;
    lbl_markTip.textColor=COLOR_WHITE;
    [self addSubview:lbl_markTip];
    
    [lbl_markTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-9);
    }];
}

-(void)loadData{
    lbl_markTip.text=self.markTip;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

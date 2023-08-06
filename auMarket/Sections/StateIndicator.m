//
//  StateIndicator.m
//  auMarket
//
//  Created by 吴绪伟 on 2023/8/4.
//  Copyright © 2023 daao. All rights reserved.
//

#import "StateIndicator.h"

@implementation StateIndicator
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
    btn_gps=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_gps.tag=10110;
    btn_gps.selected=NO;
    [btn_gps setImage:[UIImage imageNamed:@"state_gps_off"] forState:UIControlStateNormal];
    [btn_gps setImage:[UIImage imageNamed:@"state_gps_on"] forState:UIControlStateSelected];
    [btn_gps addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_gps];
    
    btn_predict=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_predict.tag=10111;
    btn_predict.selected=NO;
    [btn_predict setImage:[UIImage imageNamed:@"state_time_off"] forState:UIControlStateNormal];
    [btn_predict setImage:[UIImage imageNamed:@"state_time_on"] forState:UIControlStateSelected];
    [btn_predict addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_predict];
    
    btn_pick=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_pick.tag=10112;
    btn_pick.selected=NO;
    [btn_pick setImage:[UIImage imageNamed:@"state_box_off"] forState:UIControlStateNormal];
    [btn_pick setImage:[UIImage imageNamed:@"state_box_on"] forState:UIControlStateSelected];
    [btn_pick addTarget:self action:@selector(toggleState:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_pick];
    
    [btn_gps mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.width/3, self.height));
    }];
    
    [btn_pick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.width/3, self.height));
    }];
    
    [btn_predict mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(btn_gps.mas_right);
        make.right.mas_equalTo(btn_pick.mas_left);
        make.height.mas_equalTo(self.height);
    }];
}

-(void)loadData{
    [self refreshState];
}

-(void)refreshState{
    btn_gps.selected=(self.state_gps==1);
    btn_predict.selected=(self.state_predict==1);
    btn_pick.selected=(self.state_pick==1);
}


-(void)toggleState:(UIButton *)sender{
    sender.selected=!sender.selected;
    
    //处理代理事件
    if(self.delegate!=nil&&[self.delegate respondsToSelector:@selector(toogleState:)]){
        [self.delegate toogleState:sender.selected];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

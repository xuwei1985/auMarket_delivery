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
    
}

-(void)loadData{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

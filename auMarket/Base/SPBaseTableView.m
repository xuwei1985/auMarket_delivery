//
//  SPBaseTableView.m
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SPBaseTableView.h"

@implementation SPBaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = COLOR_BG_TABLESEPARATE;
    }
    return self;
}


@end

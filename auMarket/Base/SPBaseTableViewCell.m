//
//  SPBaseTableViewCell.m
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import "SPBaseTableViewCell.h"

@interface SPBaseTableViewCell()

@property (strong,nonatomic) UIView* topSeparate;
@property (strong,nonatomic) UIView* bottomSeparate;

@end

@implementation SPBaseTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)calCellHeight:(id)data
{
    return 0;
}
-(void)setData:(id)data
{
    
}

-(void)addTopSeparate
{
    if(!self.topSeparate)
    {
        self.topSeparate = [[UIView alloc] init];
        self.topSeparate.backgroundColor = COLOR_BG_TABLESEPARATE;
        self.topSeparate.height = 0.5;
        [self.contentView addSubview:self.topSeparate];
        [self.topSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.leading.equalTo(self.contentView.mas_leading);
            make.trailing.equalTo(self.contentView.mas_trailing);
            make.height.equalTo(@0.6);
        }];
    }
    
}

-(void)hideTopSeparate:(BOOL)hide
{
    self.topSeparate.hidden = hide;
}

-(void)hideBottomSeparate:(BOOL)hide
{
    self.bottomSeparate.hidden = hide;
}
-(void)addBottomSeparate
{
    if(!self.bottomSeparate)
    {
        self.bottomSeparate = [[UIView alloc] init];
        self.bottomSeparate.backgroundColor = COLOR_BG_TABLESEPARATE;
        [self addSubview:self.bottomSeparate];
        [self.bottomSeparate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.height.equalTo(@0.6);
        }];
        [self bringSubviewToFront:self.bottomSeparate];
    }
}
@end

//
//  SPBaseTableViewCell.h
//  Youpin
//
//  Created by DouJ on 15/3/7.
//  Copyright (c) 2015年 youpin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPBaseTableViewCell : UITableViewCell

-(void)setData:(id)data;

-(CGFloat)calCellHeight:(id)data;
-(void)addBottomSeparate;
-(void)addTopSeparate;
-(void)hideTopSeparate:(BOOL)hide;
-(void)hideBottomSeparate:(BOOL)hide;

@end

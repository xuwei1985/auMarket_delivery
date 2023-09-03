//
//  MapMaker.h
//  auMarket
//
//  Created by 吴绪伟 on 2017/9/10.
//  Copyright © 2017年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapMaker : UIImageView{
    UILabel *lbl_markTip;
    UILabel *lbl_mutiMark_bottom;
    UILabel *lbl_mutiMark_top;
    UILabel *lbl_mutiMark_left;
    UILabel *lbl_mutiMark_right;
}
@property(nonatomic,assign) NSString *markTip;
@property(nonatomic,assign) BOOL is_muti;
@property(nonatomic,assign) BOOL show_dot;
-(void)loadData;
@end

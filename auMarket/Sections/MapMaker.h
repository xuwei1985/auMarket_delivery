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
}
@property(nonatomic,assign) NSString *markTip;
@property(nonatomic,assign) BOOL is_muti;
-(void)loadData;
@end

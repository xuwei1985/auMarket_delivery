//
//  GoodsCategoryParentCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCategoryParentCell : UITableViewCell{
    UILabel *categoryTitleLbl;
    UIImageView *categoryImageView;
    UIView *stateView;
}
@property(nonatomic,retain)NSString *categoryName;
@property(nonatomic,retain)NSString *categoryImgUrl;
@property(nonatomic,retain)NSString *categorySelImgUrl;

-(void)setCellSel;
-(void)setCellUnSel;
@end

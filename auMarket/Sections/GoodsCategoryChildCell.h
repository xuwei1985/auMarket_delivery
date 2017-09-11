//
//  GoodsCategoryParentCell.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/13.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCategoryChildCell : UITableViewCell{
    UILabel *_categoryTitleLbl;
    UIImageView *_markView;
}
@property(nonatomic,retain)NSString *categoryName;
@end

//
//  SizeMacro.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/8.
//  Copyright © 2016年 daao. All rights reserved.
//

#ifndef SizeMacro_h
#define SizeMacro_h

#define WIDTH_SCREEN ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_SCREEN ([UIScreen mainScreen].bounds.size.height)

#define IS_IPhoneX (WIDTH_SCREEN >=375.0f && HEIGHT_SCREEN >=812.0f)
#define HEIGHT_NAVIGATION                   44.0f
#define HEIGHT_STATUS_BAR                   (IS_IPhoneX?44.0f:20.0f)
#define HEIGHT_STATUS_AND_NAVIGATION_BAR    (IS_IPhoneX?88.0f:64.0f)
#define HEIGHT_TAB_BAR                      (IS_IPhoneX?83.0f:49.0f)

#define SCALE_SCREEN [UIScreen mainScreen] scale]
#define SCALE_WIDTH_BASED_ON_IPHONE6(v)               ((v)*(SCREEN_WIDTH/375.0))
#define SCALE_HEIGHT_BASED_ON_IPHONE6(v)               ((v)*(SCREEN_HEIGHT/667.0))
#define SCALE_WIDTH_BASED_ON_IPAD(v)               ((v)*(SCREEN_WIDTH/768.0))
#define SCALE_HEIGHT_BASED_ON_IPAD(v)               ((v)*(SCREEN_HEIGHT/1136.0))
#endif /* SizeMacro_h */

#define FONT_SIZE_MINI          [UIFont systemFontOfSize:10]
#define FONT_SIZE_SMALL         [UIFont systemFontOfSize:12]
#define FONT_SIZE_MIDDLE        [UIFont systemFontOfSize:14]
#define FONT_SIZE_BIG           [UIFont systemFontOfSize:16]
#define FONT_SIZE_NAVIGATION    [UIFont systemFontOfSize:20]
#define FONT_SIZE_NTABBAR       [UIFont systemFontOfSize:10]

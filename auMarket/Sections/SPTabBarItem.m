//
//  SPTabBarItem.m
//  superenglish
//
//  Created by Mrc.cc on 16/6/16.
//  Copyright © 2016年 com.xuwei. All rights reserved.
//

#import "SPTabBarItem.h"

@implementation SPTabBarItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    if (image) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if (selectedImage) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return [super initWithTitle:title image:image selectedImage:selectedImage];

}

@end

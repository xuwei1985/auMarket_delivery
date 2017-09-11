//
//  ImageRotatorView.h
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RotatorItemEntity;

@protocol ImageRotatorViewDelegate <NSObject>

@optional
-(void)rotatorItemClicked:(RotatorItemEntity*) obj;
-(void)rotatorItemDidAppear:(RotatorItemEntity*)obj;
@end

@interface ImageRotatorView : UIScrollView<UIScrollViewDelegate>{
    UIPageControl *_topPageControl;
    NSTimer *_topTimer;
    UIScrollView *_topScrollView;
    float _scale;
    float _w,_h;
}

@property(nonatomic,retain) NSMutableArray<RotatorItemEntity*> *rotatorArray;
@property(nonatomic,assign) NSObject<ImageRotatorViewDelegate> *rotatorDelegate;
@property(nonatomic,assign,readonly) int pageindex;//当前页面索引
@property(nonatomic,assign,readonly) int pagecount;//总页面数
@property(nonatomic,assign) int slipInterval;//滑动周期,单位s

-(void)starRotator;
-(void)pauseRotator;
-(void)resumeRotator;

//向左滑动项目<<
-(void)slipLeftItem;
//向右滑动项目>>
-(void)slipRightItem;
@end

@interface RotatorItemEntity : NSObject
@property (nonatomic,retain) NSString *imageUrl;
@property (nonatomic,retain) NSString *webUrl;
@property (nonatomic,retain) NSString *text;
@end


@interface RotatorImageView : UIImageView
@property(nonatomic,assign) int imageIndex;
@end

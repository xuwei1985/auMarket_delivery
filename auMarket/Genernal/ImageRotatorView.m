//
//  ImageRotatorView.m
//  auMarket
//
//  Created by 吴绪伟 on 2016/12/28.
//  Copyright © 2016年 daao. All rights reserved.
//

#import "ImageRotatorView.h"

@implementation ImageRotatorView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

-(void)initData{
    _pagecount=0;
    _pageindex=0;
    
    _w=CGRectGetWidth(self.frame);
    _h=CGRectGetHeight(self.frame);
}

-(void)initUI{
    [self createRotatorView];
}

-(void)createRotatorView{
    _topScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _w, _h)];
    _topScrollView.pagingEnabled=YES;
    _topScrollView.bounces=NO;
    _topScrollView.delegate=self;
    _topScrollView.backgroundColor=[UIColor whiteColor];
    _topScrollView.showsHorizontalScrollIndicator=NO;
    _topScrollView.showsVerticalScrollIndicator=NO;
    
    [self addSubview:_topScrollView];
    
    _topPageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(_w-122, _h-25, 120, 20)];
    _topPageControl.numberOfPages=0;
    _topPageControl.currentPage=0;
    [self addSubview:_topPageControl];
}


-(void)starRotator{
    [self loadRotatorView];
    
    if (_topTimer&&_topTimer.isValid) {
        [_topTimer invalidate];  // 从运行循环中移除， 对运行循环的引用进行一次 release
        _topTimer=nil;            // 将销毁定时器
    }
    
    if(!self.rotatorArray&&self.rotatorArray.count<=1){//不需要执行任何的功能
        _topScrollView.scrollEnabled=NO;
    }
    else{
        _topScrollView.scrollEnabled=YES;
        
        if(self.slipInterval<1){
            self.slipInterval=5;
        }

        _topTimer=[NSTimer scheduledTimerWithTimeInterval:self.slipInterval target:self selector:@selector(switchRotatorView) userInfo:nil repeats:YES];
        NSLog(@"starRotator");
    }
}

-(void)switchRotatorView{
    CGRect rect;
    
    int cpage = _topScrollView.contentOffset.x/_w;
    if(cpage>=[self.rotatorArray count]-1){
        rect = CGRectMake([self.rotatorArray count] * _w, 0, _w, _h);
    }
    else{
        rect = CGRectMake((_pageindex+2) * _w, 0, _w, _h);
    }
    
    [_topScrollView scrollRectToVisible:rect animated:YES];
}


-(void)pauseRotator{
    if(_topTimer){
        _topTimer.fireDate = [NSDate distantFuture];//关闭定时器
        NSLog(@"pauseRotator");
    }
}

-(void)resumeRotator{
    if(_topTimer){
        _topTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:self.slipInterval];//开启定时器
        NSLog(@"resumeRotator");
    }
}

-(void)loadRotatorView{
    NSString *imgUrl;
    _pagecount=0;
    _pageindex=0;
    
    _pagecount=(int)self.rotatorArray.count;
    _topPageControl.numberOfPages=_pagecount;
    _topPageControl.currentPage=0;
    
    _topScrollView.contentSize=CGSizeMake((_pagecount+1)*_w, _h);
    
    for (UIView *v in [_topScrollView subviews]) {
        if ([v class]==[RotatorImageView class]) {
            [v removeFromSuperview];
        }
    }
    
    CGPoint p = CGPointZero;
    p.x = _w;
    [_topScrollView setContentOffset:p animated:NO];
    
    if (self.rotatorArray!=nil&&self.rotatorArray.count>0) {
        for (int i=0; i<self.rotatorArray.count; i++) {
            RotatorImageView *imgView=[[RotatorImageView alloc] initWithFrame:CGRectMake((i+1)*_w, 0, _w, _h)];
            imgView.tag=4000+i+1;
            imgView.imageIndex=i;//该属性保存该图片原来的索引，这样才知道当前应是对应原来的第几张图片
            imgUrl=((RotatorItemEntity *)[self.rotatorArray objectAtIndex:i]).imageUrl;
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
            imgView.userInteractionEnabled = YES;
            [_topScrollView addSubview:imgView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedItem:)];
            [imgView addGestureRecognizer:tap];
            
            //把最后一个在最前面页放一下
            if (i==(self.rotatorArray.count-1)) {
                imgView=[[RotatorImageView alloc] initWithFrame:CGRectMake(0, 0, _w, _h)];
                imgView.tag=4000;
                imgView.imageIndex=i;
                imgUrl=((RotatorItemEntity *)[self.rotatorArray objectAtIndex:i]).imageUrl;
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                [_topScrollView addSubview:imgView];
                
                imgView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedItem:)];
                [imgView addGestureRecognizer:tap];
            }
        }
    }
}


-(void)handlerRotatorViews{
    int cpage = _topScrollView.contentOffset.x/_w;
    
    _pageindex=((RotatorImageView*)[_topScrollView viewWithTag:(4000+cpage)]).imageIndex;
    _topPageControl.currentPage=_pageindex;
    //NSLog(@"cpage:%d   _pageindex:%d",cpage,_pageindex);
    
    if (cpage == 0) {
        [self allRotatorViewMoveRight];
    } else if(cpage==self.rotatorArray.count){
        [self allRotatorViewMoveLeft];
    }
    
    [self pauseRotator];
    [self resumeRotator];
    
    //处理代理事件
    if(self.rotatorDelegate!=nil&&[self.rotatorDelegate respondsToSelector:@selector(rotatorItemDidAppear:)]){
        [self.rotatorDelegate rotatorItemDidAppear:(RotatorItemEntity *)[self.rotatorArray objectAtIndex:_pageindex]];
    }
}

-(void)allRotatorViewMoveRight{
    NSString *imgUrl;
    
    //复制倒数第二个图像，放到第一个位置
    imgUrl=[self.rotatorArray objectAtIndex:((RotatorImageView*)[_topScrollView viewWithTag:(4000+self.rotatorArray.count-1)]).imageIndex].imageUrl;

    
    RotatorImageView *tmpView = [[RotatorImageView alloc] init];
    tmpView.imageIndex=((RotatorImageView*)[_topScrollView viewWithTag:(4000+self.rotatorArray.count-1)]).imageIndex;
    [tmpView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    tmpView.userInteractionEnabled=YES;
    [tmpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedItem:)]];
    
    //最后一个删掉，其他所有的图像向右移动一屏
    for (int i=(int)self.rotatorArray.count; i>=0; i--) {
        if (i==self.rotatorArray.count) {
            [[_topScrollView viewWithTag:(4000+i)] removeFromSuperview];
        }
        else {
            [_topScrollView viewWithTag:(4000+i)].frame=CGRectMake((i+1)*_w, 0, _w, _h);
            [_topScrollView viewWithTag:(4000+i)].tag=4000+i+1;
        }
    }
    
    CGPoint p = CGPointZero;
    p.x = _w;
    [_topScrollView setContentOffset:p animated:NO];
    tmpView.frame=CGRectMake(0, 0, _w, _h);
    tmpView.tag=4000;
    [_topScrollView addSubview:tmpView];
}

-(void)allRotatorViewMoveLeft{
    NSString *imgUrl;

    //复制第二个图像，放到最右边去
    imgUrl=[self.rotatorArray objectAtIndex:((RotatorImageView*)[_topScrollView viewWithTag:4001]).imageIndex].imageUrl;

    RotatorImageView *tmpView = [[RotatorImageView alloc] init];
    tmpView.imageIndex=((RotatorImageView*)[_topScrollView viewWithTag:4001]).imageIndex;
    [tmpView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    tmpView.userInteractionEnabled=YES;
    [tmpView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedItem:)]];
    
    //第一个删掉，其他所有的图像向左移动一屏
    for (int i=0; i<=(int)self.rotatorArray.count; i++) {
        if (i==0) {
            [[_topScrollView viewWithTag:(4000+i)] removeFromSuperview];
        }
        else {
            [_topScrollView viewWithTag:(4000+i)].frame=CGRectMake((i-1)*_w, 0, _w, _h);
            [_topScrollView viewWithTag:(4000+i)].tag=4000+i-1;
        }
    }
    
    CGPoint p = CGPointZero;
    p.x =_topScrollView.contentOffset.x- _w;
    [_topScrollView setContentOffset:p animated:NO];
    
    tmpView.frame=CGRectMake(self.rotatorArray.count*_w, 0, _w, _h);
    tmpView.tag=4000+self.rotatorArray.count;
    [_topScrollView addSubview:tmpView];
}

-(void)clickedItem:(id)sender{
    //处理代理事件
    if(self.rotatorDelegate!=nil&&[self.rotatorDelegate respondsToSelector:@selector(rotatorItemClicked:)]){
        [self.rotatorDelegate rotatorItemClicked:(RotatorItemEntity *)[self.rotatorArray objectAtIndex:_pageindex]];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
    if (theScrollView==_topScrollView) {
        [self handlerRotatorViews];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)theScrollView{
    if (theScrollView==_topScrollView) {
        [self handlerRotatorViews];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation RotatorItemEntity

@end

@implementation RotatorImageView

@end


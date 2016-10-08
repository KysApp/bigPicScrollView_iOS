//
//  homeBigPicView.h
//  Kozinake
//
//  Created by kys on 16/3/24.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//样式
typedef NS_ENUM(NSInteger, kysAlignment)
{
    //点在中间
    kysAlignmentCenter = 0,
    //点在左
    kysAlignmentLeft,
    //点在右
    kysAlignmentRight
};
@protocol kysScrollPicDelegate<NSObject>
@optional
- (void)clickPicWithindex:(NSInteger)index;
@end
@interface kysScrollPicView : UIView<UIScrollViewDelegate>
{
    //主视图
    UIScrollView *_mainScrollView;
    //点
    UIPageControl *_pageController;
    //
    UILabel *_titleLabel;
    //左视图图片
    UIImageView *_leftImageView;
    //中视图图片
    UIImageView *_centerImageView;
    //右视图图片
    UIImageView *_rightImageView;
    //左视图名称
    UILabel *_leftTiTle;
    //中视图名称
    UILabel *_centerTiTle;
    //右视图名称
    UILabel *_rightTiTle;
    //滚动时间
    NSTimer *_time;
    //数据
    NSArray *_titleList;
    //图片数据
    NSArray *_imageList;
    //当前页书
    NSInteger _currentIndex;
    //
    CGSize _baseSize;
    //
    NSTextAlignment _titleAlignment;
}

//代理 用于点击时间回传
@property (nonatomic,weak) id<kysScrollPicDelegate>delegate;
//自动滚动时间
@property (nonatomic) NSTimeInterval autoScrollTime;
//样式
- (void)setPageControllerAlignment:(kysAlignment)alignment;
//设置颜色
- (void)setCurrentPageIndicatorColor:(UIColor*)current otherPageIndicator:(UIColor*)other;
//设置名称与图片地址
- (void)setDatasWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;
//设置title的属性
- (void)setTitleTextColor:(UIColor*)textColor alignment:(NSTextAlignment)align;
//暂停滚动
- (void)pause;
//重新启动
- (void)restart;
@end

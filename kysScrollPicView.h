//
//  homeBigPicView.h
//  Kozinake
//
//  Created by kys on 16/3/24.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
typedef NS_ENUM(NSInteger, kysAlignment)
{
    kysAlignmentCenter = 0,
    kysAlignmentLeft,
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
    //
    UIPageControl *_pageController;
    //
    UILabel *_titleLabel;
    //
    UIImageView *_leftImageView;
    //
    UIImageView *_centerImageView;
    //
    UIImageView *_rightImageView;
    //
    UILabel *_leftTiTle;
    //
    UILabel *_centerTiTle;
    //
    UILabel *_rightTiTle;
    //
    NSTimer *_time;
    //数据
    NSArray *_titleList;
    //
    NSArray *_imageList;
    //
    NSInteger _currentIndex;
    //
    CGSize _baseSize;
}

//定制颜色
@property (nonatomic,weak) id<kysScrollPicDelegate>delegate;
//自动滚动时间
@property (nonatomic) NSTimeInterval autoScrollTime;
- (void)setPageControllerAlignment:(kysAlignment)alignment;
//
- (void)setCurrentPageIndicatorColor:(UIColor*)current otherPageIndicator:(UIColor*)other;
//
- (void)setDatasWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;
//
- (void)pause;
//
- (void)restart;
@end

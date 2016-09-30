//
//  homeBigPicView.m
//  Kozinake
//
//  Created by kys on 16/3/24.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "kysScrollPicView.h"
#import "UIView+UserData.h"
@implementation kysScrollPicView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseSize = frame.size;
        _imageList = [[NSMutableArray alloc] init];
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _leftTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width, 30)];
        [_leftImageView addSubview:_leftTiTle];
        [_leftTiTle setHidden:NO];
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        _centerTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width, 30)];
        [_centerImageView addSubview:_centerTiTle];
        [_centerTiTle setHidden:NO];
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
        _rightTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width, 30)];
        [_rightImageView addSubview:_rightTiTle];
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [self addSubview:_mainScrollView];
        [_rightTiTle setHidden:NO];
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(3*width, height);
        [_mainScrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        [_mainScrollView addSubview:_leftImageView];
        [_mainScrollView addSubview:_centerImageView];
        [_mainScrollView addSubview:_rightImageView];
        UITapGestureRecognizer *action = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickAction:)];
        [_mainScrollView addGestureRecognizer:action];
        _pageController = [[UIPageControl alloc] init];
        _pageController.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pageController];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_pageController attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_pageController attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSArray *pageLayoutV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageController(30)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageController)];
        [self addConstraint:left];
        [self addConstraint:right];
        [self addConstraints:pageLayoutV];
        _imageList = [[NSMutableArray alloc] init];
        _currentIndex = 0;
        _autoScrollTime = 5;
    }
    return self;
}
- (void)setDatasWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray{
    if (!imageArray||imageArray.count == 0) {
        return;
    }
    _titleList = titleArray;
    _imageList = imageArray;
    _currentIndex = 0;
    _pageController.numberOfPages = _imageList.count;
    [self reloadImg];
    [_time invalidate];
    _time = nil;
    _time = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTime target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}
- (void)setPageControllerAlignment:(kysAlignment)alignment{
    switch (alignment) {
        case kysAlignmentLeft:
            [_pageController setConstraintConstant:0 forAttribute:NSLayoutAttributeLeft];
            [_pageController setConstraintConstant:-self.frame.size.width/2 forAttribute:NSLayoutAttributeRight];
            _leftTiTle.textAlignment = NSTextAlignmentRight;
            _centerTiTle.textAlignment = NSTextAlignmentRight;
            _rightTiTle.textAlignment = NSTextAlignmentRight;
            [_leftTiTle setHidden:NO];
            [_centerTiTle setHidden:NO];
            [_rightTiTle setHidden:NO];
            break;
        case kysAlignmentRight:
            [_pageController setConstraintConstant:0 forAttribute:NSLayoutAttributeRight];
            [_pageController setConstraintConstant:self.frame.size.width/2 forAttribute:NSLayoutAttributeLeft];
            _leftTiTle.textAlignment = NSTextAlignmentLeft;
            _centerTiTle.textAlignment = NSTextAlignmentLeft;
            _rightTiTle.textAlignment = NSTextAlignmentLeft;
            [_leftTiTle setHidden:NO];
            [_centerTiTle setHidden:NO];
            [_rightTiTle setHidden:NO];
            break;
        default:
            [_pageController setConstraintConstant:0 forAttribute:NSLayoutAttributeLeft];
            [_pageController setConstraintConstant:0 forAttribute:NSLayoutAttributeRight];
            [_leftTiTle setHidden:YES];
            [_centerTiTle setHidden:YES];
            [_rightTiTle setHidden:YES];
            break;
    }
}
- (void)reloadImg{
    if (!_imageList||_imageList.count == 0) {
        return;
    }
    CGPoint offset = _mainScrollView.contentOffset;
    if (offset.x > _baseSize.width) {
        _currentIndex = (_currentIndex + 1)%_imageList.count;
    }else if (offset.x < _baseSize.width){
        _currentIndex = (_currentIndex + _imageList.count -1) % _imageList.count;
    }
    [self loadImage];
    _pageController.currentPage = _currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadImg];
    [_mainScrollView setContentOffset:CGPointMake(_baseSize.width, 0) animated:NO];
}

- (void)viewClickAction:(UITapGestureRecognizer *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(clickPicWithindex:)]) {
        [_delegate clickPicWithindex:_currentIndex];
    }
}

- (void)autoScroll{
    _currentIndex = (_currentIndex + 1)%_imageList.count;
    [self loadImage];
    _pageController.currentPage = _currentIndex;
    [_mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [_mainScrollView setContentOffset:CGPointMake(_baseSize.width, 0) animated:YES];
}
- (void)loadImage{
    if (!_imageList||_imageList.count == 0) {
        return;
    }
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:_currentIndex]]];
    [_centerTiTle setText:[_titleList objectAtIndex:_currentIndex]];
    NSInteger leftindex = (_currentIndex + _imageList.count-1)%_imageList.count;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:leftindex]]];
    [_leftTiTle setText:[_titleList objectAtIndex:leftindex]];
    NSInteger rightindex = (_currentIndex + 1)%_imageList.count;
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:rightindex]]];
    [_rightTiTle setText:[_titleList objectAtIndex:rightindex]];
}
-(void)refleshframe{
    _pageController.frame = CGRectMake(0, _baseSize.width*9/16 - 20, _baseSize.width, 20);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_time invalidate];
    _time = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _time = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTime target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}
- (void)setCurrentPageIndicatorColor:(UIColor*)current otherPageIndicator:(UIColor*)other{
    _pageController.currentPageIndicatorTintColor = current;
    _pageController.pageIndicatorTintColor = other;
}
- (void)pause{
    [_time invalidate];
    _time = nil;
}

- (void)restart{
    if (_imageList.count>0) {
         _time = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTime target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    }
}
@end

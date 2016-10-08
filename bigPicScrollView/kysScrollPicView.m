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
        _leftTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width/2, 30)];
        [_leftImageView addSubview:_leftTiTle];
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        _centerTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width/2, 30)];
        [_centerImageView addSubview:_centerTiTle];
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
        _rightTiTle = [[UILabel alloc] initWithFrame:CGRectMake(0, height-30, width/2, 30)];
        [_rightImageView addSubview:_rightTiTle];
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [self addSubview:_mainScrollView];
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
        _pageController.currentPageIndicatorTintColor = [UIColor redColor];
        _pageController.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageController];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_pageController attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_pageController attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSArray *pageLayoutV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageController(30)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageController)];
        [self addConstraint:left];
        [self addConstraint:right];
        [self addConstraints:pageLayoutV];
        [self setPageControllerAlignment:kysAlignmentCenter];
        _imageList = [[NSMutableArray alloc] init];
        _titleList = [[NSMutableArray alloc] init];
        _currentIndex = 0;
        _autoScrollTime = 5;
    }
    return self;
}
-(void)setAutoScrollTime:(NSTimeInterval)autoScrollTime{
    if (autoScrollTime>=1) {
        _autoScrollTime = autoScrollTime;
    }else{
        _autoScrollTime = 5;
    }
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
            [self setTitlePro:@"L"];
            [_leftTiTle setHidden:NO];
            [_centerTiTle setHidden:NO];
            [_rightTiTle setHidden:NO];
            break;
        case kysAlignmentRight:
            [_pageController setConstraintConstant:0 forAttribute:NSLayoutAttributeRight];
            [_pageController setConstraintConstant:self.frame.size.width/2 forAttribute:NSLayoutAttributeLeft];
            [self setTitlePro:@"R"];
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

- (void)setTitlePro:(NSString *)str{
    if ([str isEqualToString:@"L"]) {
        [_leftTiTle setCenter:CGPointMake(self.frame.size.width*3/4, _leftTiTle.center.y)];
        [_centerTiTle setCenter:CGPointMake(self.frame.size.width*3/4, _leftTiTle.center.y)];
        [_rightTiTle setCenter:CGPointMake(self.frame.size.width*3/4, _leftTiTle.center.y)];
    }else if ([str isEqualToString:@"R"]){
        [_leftTiTle setCenter:CGPointMake(self.frame.size.width/4, _leftTiTle.center.y)];
        [_centerTiTle setCenter:CGPointMake(self.frame.size.width/4, _leftTiTle.center.y)];
        [_rightTiTle setCenter:CGPointMake(self.frame.size.width/4, _leftTiTle.center.y)];
    }
}
- (void)setTitleTextColor:(UIColor*)textColor alignment:(NSTextAlignment)align{
    if ([self checkNULL:_leftTiTle]||[self checkNULL:_centerTiTle]||[self checkNULL:_rightTiTle]) {
        return;
    }
    if (![self checkNULL:textColor]) {
        [_leftTiTle setTextColor:textColor];
        [_centerTiTle setTextColor:textColor];
        [_rightTiTle setTextColor:textColor];
    }
    if (align) {
        [_leftTiTle setTextAlignment:align];
        [_centerTiTle setTextAlignment:align];
        [_rightTiTle setTextAlignment:align];
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
    NSInteger leftindex = (_currentIndex + _imageList.count-1)%_imageList.count;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:leftindex]]];
    NSInteger rightindex = (_currentIndex + 1)%_imageList.count;
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageList objectAtIndex:rightindex]]];
    if (_currentIndex<_titleList.count) {
        [_centerTiTle setText:[_titleList objectAtIndex:_currentIndex]];
    }else{
        [_centerTiTle setText:@""];
    }
    if (leftindex<_titleList.count) {
        [_leftTiTle setText:[_titleList objectAtIndex:leftindex]];
    }else{
        [_leftTiTle setText:@""];
    }
    if (rightindex<_titleList.count) {
        [_rightTiTle setText:[_titleList objectAtIndex:rightindex]];
    }else{
        [_rightTiTle setText:@""];
    }
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

- (BOOL)checkNULL:(id)object{
    if (!object) {
        return YES;
    }else if ([object isKindOfClass:[NSNull class]]){
        return YES;
    }else{
        return NO;
    }
}
@end

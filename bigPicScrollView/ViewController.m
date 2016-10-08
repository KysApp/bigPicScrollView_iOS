//
//  ViewController.m
//  bigPicScrollView
//
//  Created by 陈鑫 on 16/9/2.
//  Copyright © 2016年 C.Xin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    kysScrollPicView *view = [[kysScrollPicView alloc] initWithFrame:CGRectMake(0,20, width, width*9/16)];
    [view setDelegate:self];
    [view setAutoScrollTime:5];
    [view setCurrentPageIndicatorColor:[UIColor greenColor] otherPageIndicator:[UIColor grayColor]];
    [view setPageControllerAlignment:kysAlignmentLeft];
    [view setTitleTextColor:[UIColor yellowColor] alignment:NSTextAlignmentLeft];
    [self.view addSubview:view];
    NSArray *array = @[@"http://img1.imgtn.bdimg.com/it/u=3755821029,4244946914&fm=21&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=3935105319,1037389709&fm=21&gp=0.jpg",@"http://img3.imgtn.bdimg.com/it/u=766437667,1744761512&fm=21&gp=0.jpg",@"http://img3.imgtn.bdimg.com/it/u=1952920096,2449558095&fm=21&gp=0.jpg",@"http://img3.imgtn.bdimg.com/it/u=3766162482,4008376723&fm=21&gp=0.jpg",@"http://img4.imgtn.bdimg.com/it/u=2357026344,3429114932&fm=21&gp=0.jpg",@"http://img1.imgtn.bdimg.com/it/u=515225603,3572718824&fm=21&gp=0.jpg"];
    [view setDatasWithTitleArray:@[@"adsad",@"asdasdad",@"ooooooo",@"asdasdadsa",@"adsadasda",@"nioninkjnj",@"sadnklsankdlnaklsd"] imageArray:array];
    kysScrollPicView *view2 = [[kysScrollPicView alloc] initWithFrame:CGRectMake(0,width*9/16+20, width, width*9/16)];
    [view2 setDelegate:self];
    [view2 setAutoScrollTime:5];
    [view2 setCurrentPageIndicatorColor:[UIColor redColor] otherPageIndicator:[UIColor grayColor]];
    [view2 setPageControllerAlignment:kysAlignmentCenter];
    [view2 setTitleTextColor:[UIColor purpleColor] alignment:NSTextAlignmentRight];
    [self.view addSubview:view2];
    [view2 setDatasWithTitleArray:@[@"adsad",@"asdasdad",@"ooooooo",@"asdasdadsa",@"adsadasda",@"nioninkjnj",@"sadnklsankdlnaklsd"] imageArray:array];
    kysScrollPicView *view3 = [[kysScrollPicView alloc] initWithFrame:CGRectMake(0,width*9/8+ 20, width, width*9/16)];
    [view3 setDelegate:self];
    [view3 setAutoScrollTime:5];
    [view3 setCurrentPageIndicatorColor:[UIColor greenColor] otherPageIndicator:[UIColor grayColor]];
    [view3 setPageControllerAlignment:kysAlignmentRight];
    [view3 setTitleTextColor:[UIColor blueColor] alignment:NSTextAlignmentCenter];
    [self.view addSubview:view3];
    [view3 setDatasWithTitleArray:@[@"adsad",@"asdasdad",@"ooooooo",@"asdasdadsa",@"adsadasda"] imageArray:array];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickPicWithindex:(NSInteger)index{
    NSLog(@"%ld",index);
}
@end

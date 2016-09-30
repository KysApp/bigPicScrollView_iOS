# bigPicScrollView
初始化<br>
    kysScrollPicView *view = [[kysScrollPicView alloc] initWithFrame:CGRectMake(0,20, width, width*9/16)];<br>
设置代理<br>
    [view setDelegate:self];<br>
设置滚动时间<br>
    [view setAutoScrollTime:5];<br>
设置pagecontrol点的颜色<br>
    [view setCurrentPageIndicatorColor:[UIColor greenColor] otherPageIndicator:[UIColor grayColor]];<br>
设置点的对其方式<br>
    [view setPageControllerAlignment:kysAlignmentLeft];<br>
设置数据标题和图片地址<br>
(void)setDatasWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;<br>
代理<br>
    点击时返回所在数据index<br>
    (void)clickPicWithindex:(NSInteger)index；<br>
    

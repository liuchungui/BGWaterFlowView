# BGWaterFlowView
一个基于UICollectionView封装的瀑布流控件，自带上下拉刷新功能。简单易用，集成到项目中仅仅只需要三步，轻轻松松分分钟。

##主要功能
  - 瀑布流布局
  - 上下拉刷新加载数据
  
##环境要求
  - iOS7.0+
 
##手动集成方式
克隆工程到本地，导入"BGWaterFlowView"与"EGOTableViewPullRefresh"文件夹至目标工程中。

##使用方法：

（1）初始化瀑布流控件视图

```
    BGRefreshWaterFlowView *waterFlowView = [[BGRefreshWaterFlowView alloc] initWithFrame:self.view.bounds];
    //设置代理
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    [self.view addSubview:waterFlowView];
    //注册Cells
    [waterFlowView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
```
    
（2）实现BGWaterFlowViewDataSource数据源代理方法

```
- (NSInteger)numberOfSectionsInWaterFlowView:(BGWaterFlowView *)waterFlowView{
    return 1;
}

- (NSInteger)waterFlowView:(BGWaterFlowView *)waterFlowView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UICollectionViewCell *)waterFlowView:(BGWaterFlowView *)waterFlowView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGCollectionViewCell *cell = [waterFlowView dequeueReusableCellWithReuseIdentifier:BGCollectionCellIdentify forIndexPath:indexPath];
    ...
    return cell;
}

//返回Cells指定的高度，一般从服务器获取。
- (CGFloat)waterFlowView:(BGWaterFlowView *)waterFlowView heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return 100 + (rand() % 100);
}
```

（3）实现BGRefreshWaterFlowViewDelegate上下拉刷新加载数据代理方法

```
- (void)pullDownWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView{
    //下拉加载最新数据
    ...
    [refreshWaterFlowView reloadData];
    [refreshWaterFlowView pullDownDidFinishedLoadingRefresh];
}

- (void)pullUpWithRefreshWaterFlowView:(BGRefreshWaterFlowView *)refreshWaterFlowView {
    //上拉加载更多数据
    ...
    [refreshWaterFlowView reloadData];
    [refreshWaterFlowView pullUpDidFinishedLoadingMore];
}
```

##协议许可
BGWaterFlowView遵循MIT许可协议。有关详细信息,请参阅许可协议。


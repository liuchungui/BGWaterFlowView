# BGWaterFlowView
一个基于UICollectionView封装的瀑布流控件，自带上下拉刷新功能。简单易用，集成到项目中仅仅只需要三步，轻轻松松分分钟。

##主要功能
  - 瀑布流布局
  - 上下拉刷新加载数据
  
##环境要求
  - iOS6.0+    
  - Xcod7.0+
 
##Installation
####CocoaPods:

```
 pod "BGWaterFlowView"
```  

####手动安装：

导入"BGWaterFlowView"文件夹至目标工程，由于依赖于EGO和BGUIFoundationKit中的UIView+Extra，请导入这个两个库至目标工程中。

##使用方法：

内部封装了BGWaterFlowView和BGRefreshWaterFlowView两个瀑布流视图。BGRefreshWaterFlowView自带EGO下拉刷新和自定义加载更多，以下就是BGRefreshWaterFlowView使用步骤（如使用BGWaterFlowView详见[使用方法](https://github.com/liuchungui/BGWaterFlowView/blob/master/BGWaterFlowView.md)）。

（1）初始化瀑布流控件视图

```
    BGRefreshWaterFlowView *waterFlowView = [[BGRefreshWaterFlowView alloc] initWithFrame:self.view.bounds];
    //设置代理
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    //设置瀑布流列数
    waterFlowView.columnNum = 4;
    //设置cell与cell之间的水平间距
    waterFlowView.horizontalItemSpacing = 10;
    //设置cell与cell之间的垂直间距
    waterFlowView.verticalItemSpacing = 10;
    waterFlowView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:waterFlowView];
    //注册Cells
    [waterFlowView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
```
    
（2）实现BGWaterFlowViewDataSource数据源代理方法

```
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
    //return cellHeight
    return 100 + (rand() % 100);
}
```

（3）实现`BGRefreshWaterFlowViewDelegate`上下拉刷新加载数据代理方法

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

//点击cell的代理方法
- (void)waterFlowView:(BGWaterFlowView *)waterFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}
```
##Demo效果截图
![](http://ww1.sinaimg.cn/mw690/7f266405jw1ey22tbuohvg20ab0inqva.gif)
##协议许可
BGWaterFlowView遵循MIT许可协议。有关详细信息,请参阅许可协议。


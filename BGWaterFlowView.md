##BGWaterFlowView使用方法
（1）初始化瀑布流控件视图

```
    BGWaterFlowView *waterFlowView = [[BGWaterFlowView alloc] initWithFrame:self.view.bounds];
    //设置代理
    waterFlowView.dataSource = self;
    waterFlowView.delegate = self;
    waterFlowView.columnNum = 4;
    waterFlowView.itemSpacing = 10;
    waterFlowView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.view addSubview:waterFlowView];
    //注册Cells
    [waterFlowView registerClass:[BGCollectionViewCell class] forCellWithReuseIdentifier:BGCollectionCellIdentify];
```
    
（2）实现`BGWaterFlowViewDataSource`数据源代理方法

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

（3）实现`BGWaterFlowViewDelegate`上下拉刷新加载数据代理方法

```
//点击cell的代理方法
- (void)waterFlowView:(BGWaterFlowView *)waterFlowView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
}
```

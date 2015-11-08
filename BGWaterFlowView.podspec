Pod::Spec.new do |spec|
  #项目名称
  spec.name         = 'BGWaterFlowView'
  #版本号
  spec.version      = '0.0.1'
  #开源协议
  spec.license      = 'MIT'
  #对开源项目的描述
  spec.summary      = 'BGWaterFlowView是一个基于UICollectionView封装瀑布流控件，内部有封装好刷新的视图'
  #开源项目的首页
  spec.homepage     = 'https://github.com/liuchungui/BGWaterFlowView'
  #作者信息
  spec.author       = {'chunguiLiu' => '404468494@qq.com'}
  #项目的源和版本号
  spec.source       = { :git => 'https://github.com/liuchungui/BGWaterFlowView.git', :tag => spec.version }
  #源文件，这个就是供第三方使用的源文件
  spec.source_files = "BGWaterFlowView/*"
  #适用于ios7及以上版本
  spec.platform     = :ios, '6.0'
  #使用的是ARC
  spec.requires_arc = true

  #spec.dependency 'EGOTableViewPullRefresh', '~> 0.1.0'
  spec.dependency 'BGUIFoundationKit', '~> 0.0.2'
  spec.dependency 'SDWebImage', '~> 3.7.3'

end
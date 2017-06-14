
**iOS11正在适配中，2017.6.14**

![version](https://img.shields.io/badge/Version-2.1.2-blue.svg) ![platform](https://img.shields.io/badge/platform-iOS-ligtgrey.svg)  ![ios](https://img.shields.io/badge/Requirements-iOS8%2B-green.svg)

JKNavigationController
===

`JKNavigationController `通过KVC调用私有API，已通过上架审核，目前已有2个上线项目使用`JKNavigationController`(2017.4.22)。


## 目录

* [JKNavigationController简介](#JKNavigationController)
* [JKNavigationController迭代记录](#Updation)
* [JKNavigationController用法](#Usage)
  * [1.引入头文件](#import)
  * [2.将UINavigationController换成JKRootNavigationController](#replace)
  * [3.为每个控制器VC的导航栏navigationBar定制颜色、透明度](#navigationBar)
  * [4.全屏侧滑返回手势](#PopGestrue)
  * [5.修改navigationBar.tintColor](#tintColor)
  * [6.navigationBar渐变位移效果](#Offset)
  * [7.拦截自定义返回按钮的点击事件](#shouldPopItem)
* [其他注意点](#Prompt)



## <a id="JKNavigationController"></a>JKNavigationController简介 ##

开始我只是想实现NavigationBar的渐变透明效果，但后来发现界面切换时会出现问题，对Push/Pop兼容性很差，折腾了一段时间也就放弃了，直到看到这篇文章[《用Reveal分析网易云音乐的导航控制器切换效果》](http://jerrytian.com/2016/01/07/用Reveal分析网易云音乐的导航控制器切换效果/)。然后就照着作者`JNTian`的思路，整合(搬运)了三个框架的代码，即[Leo的LTNavigationBar](https://github.com/ltebean/LTNavigationBar)、[SunnyDog的FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)和[JNTian的JTNavigationController](https://github.com/JNTian/JTNavigationController#jtnavigationcontroller)，最后实现了为每个控制器定制一个专属导航栏的效果，即每个customViewController都有一一对应的navigationController和navigationBar，可以为每个控制器定制导航栏的颜色。其次，自定义了侧滑返回手势，兼容Push/Pop动画。文章[《用Reveal分析网易云音乐的导航控制器切换效果》](http://jerrytian.com/2016/01/07/用Reveal分析网易云音乐的导航控制器切换效果/)中介绍的就是[JNTian的JTNavigationController](https://github.com/JNTian/JTNavigationController#jtnavigationcontroller)的实现思路，可以先看博客文章再研究源码，`JNTian `介绍的很详细，很容易理解。


![image](http://wx3.sinaimg.cn/mw690/c56eaed1gy1fet9vxwqtyg20ak0j5twm.gif)

## <a id="Updation"></a>JKNavigationController迭代记录
* 2.1.2：解决tabBarController.viewControllers全部提前走viewDidLoad的BUG(1.0.1)，修改后界面显示才会走viewDidLoad
* 2.1.1：解决设置self.navigationItem.backBarButtonItem无效的BUG
* 2.1：增加返回按钮点击事件的拦截机制
* 2.0：兼容了iOS8、iOS9、iOS10，增加了对Push和Pop动画的兼容，并增加全屏侧滑返回手势
* 1.0：实现NavigationBar渐变效果，在iOS10上有兼容性BUG，并且没有适配Push/Pop切换动画。


## <a id="Usage"></a> JKNavigationController用法

### <a id="import"></a> 1.引入头文件

```Object-c
	#import "JKNavigationController.h"
```

`JKNavigationController.h`包括了4个类文件：
> "UINavigationBar+JKTransparentize.h" 修改navigationBar的背景色，可以实现渐变、位移效果
> "JKRootNavigationController" 多样式导航控制器切换效果
> "UIViewController+JKNavigationController.h" 全屏侧滑手势开关
> "JKBackIndicatorButton.h" 自定义返回按钮

### <a id="replace"></a> 2.将入口处的UINavigationController换成JKRootNavigationController

```Object-C
	JKRootNavigationController * nav = [[JKRootNavigationController alloc] initWithRootViewController:homeVC];
```

### <a id="navigationBar"></a> 3.为每个控制器VC的导航栏navigationBar定制颜色、透明度

**全局设置多个控制器vc.navigationController.navigationBar的背景颜色**，navigationBar.jk_barBackgroundColor属性具有全局效果，通过这个属性设置导航栏颜色，会影响后续Push的destinationVC导航栏的背景色。如果大部分界面的导航栏颜色一样，只要在第一个控制器设置navigationBar.jk_barBackgroundColor属性值就行。

```Object-C
	firstVC.navigationController.navigationBar.jk_barBackgroundColor = [UIColor orangeColor];
```
因为在`JKInterLayerNavigationController`类中重写了push方法，并且进行了下面的操作，起到了传递效果。

```Object-C
	destinationVC.navigationController.navigationBar.jk_barBackgroundColor = fromViewController.navigationController.navigationBar.jk_barBackgroundColor
```

**设置当前控制器vc.navigationController.navigationBar的背景颜色**，只会作用当前界面的navigationBar，此方法只能实现当前控制器导航栏navigationBar的渐变效果，不会影响其他控制器导航栏的颜色，也不会阻断navigationBar.jk_barBackgroundColor的传递效果，这一点需要注意。比如有Avc->Bvc->Cvc这种顺序结构的多个控制器，Avc设置了navigationBar.jk_barBackgroundColor，Bvc通过下面的方法定制颜色，但实际上Avc.navigationBar.jk_barBackgroundColor == Bvc.navigationBar.jk_barBackgroundColor == Cvc.navigationBar.jk_barBackgroundColor。

```Object-C
	[self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[UIColor orangeColor]];
```
![image](http://wx4.sinaimg.cn/mw690/c56eaed1gy1fet9vx65x0g20bh0263zu.gif)


### <a id="PopGestrue"></a> 4.全屏侧滑返回手势

**全局控制 全屏侧滑返回手势的开关**，会影响后续Push的destinationVC的`jk_fullScreenPopGestrueEnabled`，原因跟navigationBar.jk_barBackgroundColor一样，都是一层一层地传递赋值。

```Object-C
	self.jk_rootNavigationController.jk_fullScreenPopGestrueEnabled = YES;
```

**控制单个控制器的全屏侧滑返回手势的开关**,需要注意的是关闭全屏侧滑手势后，会使用系统原生的侧滑返回功能。

```Object-C
	self.jk_fullScreenPopGestrueEnabled = NO;
```

### <a id="tintColor"></a> 5.修改navigationBar.tintColor

因为有自定义返回按钮`JKBackIndicatorButton`，建议使用下面的方法修改tintColor，`JKBackIndicatorButton `内部会重绘背景图片，如果只设置navigationBar.tintColor，将不会修改`JKBackIndicatorButton `的颜色。

```Object-C
	[self.navigationController.navigationBar jk_setTintColor:[UIColor purpleColor]];

/// 不推荐
// self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
```

### <a id="Offset"></a> 6.navigationBar渐变位移效果

如果要实现知乎日报首页的效果，即NavigationBar的渐变偏移效果，则调用下面的代码。

```Object-C
	[navigationBar jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY]

/// 方法内部调用jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha实现渐变色效果
```
![image](http://wx3.sinaimg.cn/mw690/c56eaed1gy1fet9vxkztug20bh026jsz.gif)


### <a id="shouldPopItem"></a> 7.拦截自定义返回按钮的点击事件

如果需要拦截返回按钮的点击事件，在控制器中实现`JKNavigationControllerDelegate `协议方法即可。

```Object-C
- (BOOL)jk_navigationController:(JKRootNavigationController *)navigationController
                  shouldPopItem:(UINavigationItem *)item {
    do something...
    return yes or no
}
                  
```

## <a id="Prompt"></a>其他注意点

需要注意一点，如果使用了StoryBoard或者XIB，并且在Push时隐藏TabBar，可能会出现留白或者闪烁。原因跟AutoLayout的更新时机有关，解决的思路是从TableView的Bottom约束入手，纯代码创建的控制器应该没问题。

<img src="http://wx4.sinaimg.cn/mw690/c56eaed1gy1fet9vymyw9j212e0uijyo.jpg" width="800" height="600">

## 1.0版：JPTransparentNavgationBar（已整合到2.0版） ##
## 2.0版：JKNavigationController ##


1.0版本只是实现了`修改NavigationBar的(颜色)透明度`，在iOS10上有兼容性BUG，并且没有适配Push/Pop切换动画。

2.0版本兼容了`iOS8`、`iOS9`、`iOS10`，增加了`对Push和Pop动画的兼容`，并增加`全屏侧划返回`功能。在实现过程中参考了[Leo的LTNavigationBar](https://github.com/ltebean/LTNavigationBar)、[SunnyDog的FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)和[JNTian的JTNavigationController](https://github.com/JNTian/JTNavigationController#jtnavigationcontroller)。2.0版本的`JKNavigationController`可以视为3个第三方库(组件)的组合库。

---

## 效果图 ##

----

![image](https://github.com/XiFengLang/JPTransparentNavgationBar/raw/master/NavigationBarGif.gif)

---


## 实现原理 ##

效果图中实现的多样式控制器切换功能，其原理可以看看文章[《用Reveal分析网易云音乐的导航控制器切换效果》](http://jerrytian.com/2016/01/07/用Reveal分析网易云音乐的导航控制器切换效果/)，文章中介绍的就是[JNTian的JTNavigationController](https://github.com/JNTian/JTNavigationController#jtnavigationcontroller)的实现思路，我也是参考着作者的思路，然后做了少量改动，引入了其他2各库的功能。

---

## 用法  ##


```Object-c
#import "JKNavigationController.h"
```

`JKNavigationController.h`包括了4个类文件：
> "UINavigationBar+JKTransparentize.h" 修改navigationBar的背景色(透明度)
> "JKPackageNavigationController.h" 多样式导航控制器切换效果
> "UIViewController+JKNavigationController.h" 全屏侧滑手势开关
> "JKBackIndicatorButton.h" 自定义返回按钮

---

设置navigationController.navigationBar的全局背景颜色，会影响后续Push的toVC.navigationController.navigationBar的背景色。
```Object-C
self.navigationController.navigationBar.jk_barBackgroundColor = [UIColor orangeColor];
```

设置当前控制器vc.navigationController.navigationBar的背景颜色,通过此方法可以实现当前控制器navigationBar的变色、透明效果：

![image](https://github.com/XiFengLang/JKNavigationController/blob/master/NavigationBarGif_1.gif)

```Object-C
[self.navigationController.navigationBar jk_setNavigationBarBackgroundColor:[UIColor orangeColor]];
```

---

控制全局的全屏侧滑返回手势的开关，会影响后续Push的toVC的`jk_fullScreenPopGestrueEnabled`
```Object-C
self.jk_rootNavigationController.jk_fullScreenPopGestrueEnabled = YES;
```

控制局部控制器的全屏侧滑返回手势的开关,需要注意的是关闭全屏侧滑手势后，会使用系统原生的侧滑返回功能。
```Object-C
self.jk_fullScreenPopGestrueEnabled = NO;
```

---

如果有自定义返回按钮`JKBackIndicatorButton`的控制器，建议使用下面的方法修改navigationBar.tintColor，内部会重绘图片。
```Object-C
[self.navigationController.navigationBar jk_setTintColor:[UIColor purpleColor]];

// self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
```

--- 

如果要实现知乎日报首页的效果，即NavigationBar的渐变偏移效果，则调用下面的代码。

![image](https://github.com/XiFengLang/JKNavigationController/blob/master/NavigationBarGif_2.gif)

```Object-C
[navigationBar jk_setNavigationBarVerticalOffsetY:(CGFloat)offsetY]

/// 渐变透明通过调用jk_setNavigationBarSubViewsAlpha:(CGFloat)alpha实现
```







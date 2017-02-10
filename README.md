## 1.0版：JPTransparentNavgationBar（已整合到2.0版） ##
## 2.0版：JKNavigationController ##


1.0版本只是实现了修改NavigationBar的透明度，在iOS10上有兼容性BUG，并且没有适配Push/Pop切换动画。

2.0版本兼容了iOS8、iOS9、iOS10，增加了对Push和Pop动画的兼容，并增加全屏侧划返回功能。在实现过程中参考了[Leo的LTNavigationBar](https://github.com/ltebean/LTNavigationBar)、[SunnyDog的FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)和[JNTian的JTNavigationController](https://github.com/JNTian/JTNavigationController#jtnavigationcontroller)。2.0版本的JKNavigationController可以视为3个第三方库(组件)的组合库。

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






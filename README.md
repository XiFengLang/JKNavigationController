## JPTransparentNavgationBar
> 实现透明NavigationBar
> 随意控制NavigationBar透明度及颜色，不涉及苹果私有API
> 支持重置还原NavigationBar

**导入UINavigationBar+JPExtension.h即可随意设置NavgationBar的透明度以及背景颜色**
----
![image](https://github.com/XiFengLang/JPTransparentNavgationBar/raw/master/NavigationBarGif.gif)

---
**usage**

```Object-C
#import "UINavigationBar+JPExtension.h"
```

**方式1，插入1个高度为64的view充当背景View**
```Object-C
[self.navigationController.navigationBar jp_setNavigationBarBackgroundColor:[[UIColor purpleColor] colorWithAlphaComponent:0]];
```

**方式2，插入1个高度为20的view放在状态栏下面，同时设置navigationBar的背景颜色**
```Object-C
[self.navigationController.navigationBar jp_setStatusBarBackgroundViewColor:[[UIColor purpleColor] colorWithAlphaComponent:0]];
```

**重置还原**

```Object-C
[self.navigationController.navigationBar jp_restoreNavigationBar];
```

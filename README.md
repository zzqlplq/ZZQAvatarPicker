# ZZQAvatarPicker

一行代码搞定头像选择:
```
    [ZZQAvatarPicker startSelected:^(UIImage * _Nonnull image) {
        [self.avatarBtn setImage:image forState:UIControlStateNormal];
    }];
```


 使用
===============

### CocoaPods
1. 在Podfile 中添加`pod "ZZQAvatarPicker"`。
2. 执行`pod install`或`pod update`。
3. 导入\<ZZQAvatarPicker.h\>


### 手动安装
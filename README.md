# ZZQAvatarPicker

1. 一行代码搞定头像选择:
```
    [ZZQAvatarPicker startSelected:^(UIImage * _Nonnull image) {
        [self.avatarBtn setImage:image forState:UIControlStateNormal];
    }];
```

2. 源码里还有权限请求相关的代码，导入 `ZZQAuthorizationManager` 后可以直接使用


 集成
===============

### CocoaPods
1. 在Podfile 中添加`pod "ZZQAvatarPicker"`
2. 执行`pod install`或`pod update`
3. 导入\<ZZQAvatarPicker.h\>
4. 添加相应的权限

### 手动安装
1. 下载 ZZQAvatarPicker 源码
2. 将 ZZQAvatarPicker 中 源文件添加到你的工程
3. 导入 `ZZQAvatarPicker`
4. 添加相应的权限

# Zapp

一个解析屏幕中二维码的菜单栏应用。

![screenshot_cn](https://raw.githubusercontent.com/liopoos/Zapp/master/Screenshots/screenshot_cn.png)

## 运行环境

macOS 11 或更高。

## 安装

#### 通过Releases版本安装

- 从 Releases下载DMG文件
- 将 .app 文件拖入到 Application 文件夹

##### 签名问题 ⚠️

Zapp 是开源软件，本身是安全的，但由于苹果严格的检查机制，打开时可能会遇到警告拦截。

如果无法打开，请参考苹果使用手册 [打开来自身份不明开发者的 Mac App](https://support.apple.com/zh-cn/guide/mac-help/mh40616/mac)，或者进行本地代码签名。

**macOS本地代码签名**

安装 Command Line Tools：

```bash
xcode-select --install
```

打开终端并执行：

```bash
sudo codesign --force --deep --sign - /Applications/Zapp.app/
```

出现 「replacing existing signature」 即本地签名成功。

#### 自行构建

1. 克隆本项目：

```bash
git clone https://github.com/liopoos/Zapp.git
```

2. 使用Xcode打开`Zapp.xcworkspace`，自行打包构建。

## 使用

Zapp是一个菜单栏应用，所以打开后需要点击菜单栏图标按钮才可以进行操作。目前Zapp提供三种二维码的解析方式：

| 方式               | 快捷键 | 描述                                                         |
| ------------------ | ------ | ------------------------------------------------------------ |
| 从屏幕截图         | ⌘+X    | 通过系统截图应用截取屏幕二维码                               |
| 从剪贴板导入       | ⌘+C    | 将解析剪贴板中的图像                                         |
| 从iPhone或iPad导入 | ⌘+Q    | 通过「连续互通相机」API调用同一个iCloud下iPhone或iPad的相机进行拍摄 |

#### 安全性

Zapp将解析的内容保存在本机中，APP本身没有进行任何网络连接。

## Todo

- [ ] 支持历史记录的导出

## License

©MIT

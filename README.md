# 更新(2020-09-01)
资源文件中加入一个所有资源路径的数组，用于可以方便地进行资源遍历用以precache
使用的工具类如下：
```dart
class H {
  H._();

  static final _h = H._();

  factory H() => _h;

  List<String> _preCached = [];

  preCacheImages(context, {String preCachePath = "/pre_cache/"}) {
    if (!_preCached.contains(preCachePath)) {
      _preCached.add(preCachePath);
      R.values.forEach((String path) {
        if (path.contains(preCachePath)) {
          precacheImage(AssetImage(path), context);
        }
      });
    }
  }
}
```

# 更新(2018-06-03)
向生成的r.dart资源文件中增加了图片预览功能，可以在ide中选择资源时通过快捷键显示预览(as/idea默认为Ctrl+q)，效果如下：
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/preview.gif?raw=true)
由于注释中md格式图片引用不支持本地路径，所以是利用了脚本开启了一个本地文件服务器，如果出现端口冲突可以自行修改脚本中第7行 preview_server_port 的值即可。
# 更新(2018-05-30)
由于官方工具升级，现在已经支持直接在 pubspec.yaml 中填写文件夹并自动扫描添加其中的资源文件了，参考：<br>
[https://flutter.io/assets-and-images/](https://flutter.io/assets-and-images/)<br>
[Scan assets from disk #16413](https://github.com/flutter/flutter/pull/16413)<br>
可以采用这种方式来代替刷新脚本了。<br>
不过利用脚本中生成 r.dart 资源文件方便在代码中引用的功能仍然是有意义的……

# asset_generator
根据pubspec.yaml中设置的目录模板自动向其中添加文件记录的简单脚本

# 效果演示
<img src="https://github.com/flutter-dev/asset_generator/blob/master/raw/demo.gif?raw=true" width="70%" height="70%">

# 安装方法
1. 下载 asset_generator.dart 脚本文件
2. 找到自己flutter的安装目录，将脚本放在flutter的根目录下(可选，推荐)
3. 根据使用的IDE不同，为其设置调用命令

# 为IDE设置脚本运行命令
## idea/Android Studio
1. 打开设置界面，找到外部工具设置项 ( Tools -> ExternalTools ):
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/idea_setting.png?raw=true)
2. 点击添加按钮，参考下图配置：
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/idea_ext_tools.png?raw=true)
其中名称简介均可随意设置，Program 项需要设置为 flutter 目录内下载的 dart 命令的绝对路径；<br>
Arguments 项需要设置为安装方法中下载脚本放置位置的绝对路径；<br>
Working directory 项需要填 $ProjectFileDir$ ， 以确保脚本能在工程中以正确的路径执行<br>

## vscode
1. 创建项目后，选择 [任务]  -> [配置任务] :

![](https://github.com/flutter-dev/asset_generator/blob/master/raw/vscode_task_1.png?raw=true)

2.选择从模板创建任务后，在下面的选项中选择最后一项 (Others 运行任意外部命令的示例)
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/vscode_task_2.png?raw=true)

3.按照下图配置调用命令，需要注意 dart 命令脚本的实际路径， 名称随意:
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/vscode_task_3.png?raw=true)

4.修改好 pubspec.yaml 文件后，可以通过 [任务]->[运行任务]，然后根据上一步配置的名称运行命令:
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/vscode_task_4.png?raw=true)

5.命令运行后可以在底部终端显示栏中切换查看，点击垃圾桶图标可以停止脚本运行:
![](https://github.com/flutter-dev/asset_generator/blob/master/raw/vscode_task_5.png?raw=true)

# 使用方法
编辑 pubspec.yaml 文件，在需要脚本处理的位置加入如下格式的注释：
```
# assets begin
# images/*
# assets end
```
脚本只会处理 '# assets begin' 与 '# assets end' 之间的模板，这样可以避免误删除其他配置信息
加入目录的格式为 '# <目录名>/*'  ，脚本将在此注释下面将遍历出的文件依次添加。

接着根据使用的IDE不同调用脚本运行命令。

处理完成后还会在 lib/ 目录中自动生成r.dart 文件，并按照规范的命名格式生成资源文件路径的静态常量，推荐代码中使用资源时使用 R.xxx 的方式传地址，可以避免手误写错路径的尴尬。

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
其中名称简介均可随意设置，Program 项需要设置为 flutter 目录内下载的 dart 命令的绝对路径；
Arguments 项需要设置为安装方法中下载脚本放置位置的绝对路径；
Working directory 项需要填 $ProjectFileDir$ ， 以确保脚本能在工程中以正确的路径执行

## vscode
...
(征求对vscode设置熟悉的大佬帮忙补全这一部分说明。)

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

---
title: NodeJS使用
copyright: false
date: 2019-06-23 13:14:00
tags: 
 - node
 - npm
 - webpack
 - bower
categories: 
 - VCS
---
## 安装Node.Js
```bash 配置使用 https://nodejs.org 官网
#https://www.gitee.com/doobo/nvmw
nvmw只是安装了不同node的环境，并不是npm的版本也更新，npm是基于node而开发的
node -v 查看的是node的版本，而npm -v 查看的是npm的版本，非服务器端开发，用官方推荐的node包省事
设置代理服务器
npm config rm proxy   
npm config rm https-proxy
npm config set proxy http://127.0.0.1:5858 
npm config set https-proxy http://127.0.0.1:5858
npm config set registry=http://registry.npmjs.org
```

## 配置NPM环境
```bash
npm install -g npm --registry=https://registry.npm.taobao.org
npm install -g cnpm --registry=https://registry.npm.taobao.org
npm install -g bower --registry=https://registry.npm.taobao.org

#可选，将npm默认设置从淘宝服务器上获取数据
npm config set registry "https://registry.npm.taobao.org"

#配置npm的全局模块的存放路径以及cache的路径
#注意：配置全局模块位置后，需要把新的global加入到环境变量，否则安装的全局插件找不到路径，不能使用
npm config set prefix "D:\nodejs\global"
npm config set cache "D:\nodejs\cache"
#检测环境：npm -v   bower -v
```

## NPM常用命令
```bash
npm view react          搜索查看react
npm cache ls react      查看本地缓存的react
npm install --save jquery@1.9.1     安装指定版本的包
npm install --cache-min 9999999 <package-name>
npm install --cache-min Infinity <package-name>     超过这个时间的模块，才会从 registry下载
npm-cache install       替代npm利用缓存安装安装
npm cache clean --force 清空缓存，install安装失败时，可试试解决
npm install color-name --unsafe-perm=true   #npm ERR! enoent 出现可以试试对应的包
```

## 使用bower插件搭建Angular开发环
```bash
a、新建文件夹，如：angular
b、进入文件夹下，执行命令，初始化bower环境：bower init  按照提示输入一些基本信息
c、根目录创建.bowerrc文件，并在其中加入如下内容，告诉bower将组件库下载到特定的目录
    {
     "directory": "public/components"
    }
d、用bower安装angular环境
    bower install angular#1.6.0-rc.0 --save
    #--save标志 这个额外的标志，是告诉bower把我们的安装记录放置入bower.json文件,便于通过bower更新项目
    #会在angular/public/components/目录下引入angular1.6的相关代码
e、开始angular开发，编写在public下编写index.html文件，引入对应的js文件
    <script type="text/JavaScript" src="components/angular/angular.min.js"></script>
f、使用bower引入其它插件：
    bower install angular-bindonce --save
```

## bower常用命令
```bash
cache-clean             清除Bower的缓存，或清除指定包的缓存
completion              Bower的Tab键自动完成
help                    显示Bower命令的辅助信息
info                    指定包的版本信息和描述
init                    交互式的创建bower.json文件
install                 安装一个本地的包
link                    包目录的符号连接
list, ls                列出所有已安装的包
lookup                  根据包名查询包的URL
register                注册一个包
search                  根据包名搜索一个包
uninstall               删除一个包
update                  更新一个包
bower uninstall --help  显示命令的具体使用方法
```

## Webpack基本配置
```bash
#常用命令
webpack --config XXX.js     #使用另一份配置文件（比如webpack.config2.js）来打包
webpack --watch             #监听变动并自动打包
webpack -p                  #压缩混淆脚本，这个非常非常重要！
webpack -d                  #生成map映射文件，告知哪些模块被最终打包到哪里了
webpack {entry file} {destination for bundled file}
webpack app/start/main.js dist/start/bundle.js #命令打包JS文件

#webpack.config.js的文件打包,放根目录下,__dirname是node的当前目录
module.exports = {
    entry:  __dirname + "/app/start/main.js",//已多次提及的唯一入口文件
    output: {
        path: __dirname + "/dist/start",//打包后的文件存放的地方
        filename: "bundle.js"//打包后输出文件的文件名
    }
}

#个性化配置js的打包名称
var CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkPlugin");
module.exports = {
    entry: {
        p1: "./page1",
        p2: "./page2",
        p3: "./page3",
        ap1: "./admin/page1",
        ap2: "./admin/page2"
    },
    output: {
        filename: "[name].js"
    },
    plugins: [
        new CommonsChunkPlugin("admin-commons.js", ["ap1", "ap2"]),
        new CommonsChunkPlugin("commons.js", ["p1", "p2", "admin-commons.js"])
    ]
};
{
    entry: {
        page1: "./page1",
        //支持数组形式，将加载数组中的所有模块，但以最后一个模块作为输出
        page2: ["./entry1", "./entry2"]
    },
    output: {
        path: "dist/js/page",
        filename: "[name].bundle.js"
    }
}
//最终会生成一个 page1.bundle.js 和 page2.bundle.js，并存放到 ./dist/js/page 文件夹下
//指定公共文件生成到指定目录
plugins: [
new webpack.optimize.CommonsChunkPlugin("file2","./anotherpath/file2.bundle.js")
]
//特定目录打包生成特定目录下的代码
module.exports = {
    entry: {
        "start/":__dirname +"/app/start/main.js",//已多次提及的唯一入口文件
        "angular/":__dirname+"/app/angular/main.js"

    },
    output: {
        path: __dirname + "/dist",//打包后的文件存放的地方
        filename: "[name]bundle.js"//打包后输出文件的文件名
    }
}

#常用配置
#配置source maps，需要配置devtool，有{source-map,cheap-module-source-map
        ,cheap-module-source-map,cheap-module-eval-source-map}四个选项
        cheap-module-eval-source-map方法构建速度更快，但是不利于调试，推荐在大型项目考虑da时间成本是使用
module.exports = {
    devtool: 'eval-source-map',//配置生成Source Maps，选择合适的选项
    entry:  __dirname + "/app/start/main.js",
    output: {
    path: __dirname + "/dist/start",
    filename: "bundle.js"
    }
}

#本地开发服务器配置：npm install --save-dev webpack-dev-server
module.exports = {
    devtool: 'eval-source-map',
    entry:  __dirname + "/app/start/main.js",
    output: {
    path: __dirname + "/dist/start",
    filename: "bundle.js"
    },

    devServer: {
    contentBase: "./public",//本地服务器所加载的页面所在的目录
    colors: true,//终端中输出结果为彩色
    historyApiFallback: true,//不跳转
    inline: true//实时刷新
    } 
}

#css-loader 和 style-loader使用：npm install --save-dev style-loader css-loader
module.exports = {
    devtool: 'eval-source-map',
    entry:  __dirname + "/app/main.js",
    output: {
    path: __dirname + "/build",
    filename: "bundle.js"
    },
    module: {
        loaders: [
            {
            test: /\.json$/,
            loader: "json"
            },
            {
            test: /\.js$/,
            exclude: /node_modules/,
            loader: 'babel'
            },
            {
            test: /\.css$/,
            loader: 'style!css'//添加对样式表的处理
            }
        ]
    }
}
```
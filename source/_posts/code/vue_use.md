---
title: VUE基本使用
copyright: false
date: 2019-06-22 15:40:00
tags: 
 - VUE
categories: 
 - 编程
---
## 基本语法
```bash
#attribute
    v-bind:disabled="isButtonDisabled"	#绑定ID变量
#class
    v-bind:class="[activeClass, errorClass]"	#{activeClass: 'active',errorClass: 'text-danger}
    v-bind:class="[isActive ? activeClass : '', errorClass]"
#style
    v-bind:style="styleObject"
    v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"
    :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"	/*v=2.3.0+*/
#指令缩写
    v-bind:href---->:href
    v-on:click----->@click
#IF条件
    <h1 v-if="ok">Yes</h1>
    <h1 v-else>No</h1>		/*可选,v-else 元素必须紧跟在带 v-if 或者 v-else-if 的元素的后面*/
#key--唯一值,强制刷新，不复用
    <input placeholder="Enter your username" key="username-input">
    <input placeholder="Enter your email address" key="email-input">
#解决IE无法使用Promise
npm install es6-promise -S
#文件最上方
import 'es6-promise/auto'
#数据加载后，再渲染
vm.$mount("#app")
```

## element使用
```bash
#table组件使用过滤器
<el-table-column label="计算日期(开始)" align="center" width="150">
      <template slot-scope="scope">
        <div class="cell">{{scope.row.startTime|date2}}</div>
      </template>
</el-table-column>

#按钮组
<el-button-group>
          <el-button :size="size" type="primary" icon="search" @click="search">查询</el-button>
          <span>&nbsp;</span>
          <el-button :size="size" type="primary" @click="reset">重置</el-button>
</el-button-group>

#按钮不换行
<el-col :span="1">
        <el-button :size="size" type="primary" icon="search" @click="search">查询</el-button>
</el-col>
<el-col :span="1" style="width: 16px"><span>&nbsp;</span></el-col>
<el-col :span="1">
  <el-button :size="size" type="primary" @click="reset">重置</el-button>
</el-col>

#table单选
<el-table-column  width="55" align="center" label="选择">
  <template slot-scope="scope">
    <el-radio v-model="users" @change.native="getCurrentRow(scope.row)" :label="scope.row.employeeCode">&nbsp;</el-radio>
  </template>
</el-table-column>
```

##　全局过滤器-日期
```bash
npm install -S moment;

import Vue from 'vue';
import moment from 'moment/moment';
Vue.filter('date', function (value, formatString) {
  formatString = formatString || 'YYYY-MM-DD HH:mm:ss';
  return moment(value).format(formatString); // value可以是普通日期 20170723
});
Vue.filter('date2', function (value, formatString) {
  formatString = formatString || 'YYYY-MM-DD';
  return moment(value).format(formatString); // value可以是普通日期 20170723
});
```

## 对象复制和数组赋值监听
```bash
#代替 `Object.assign(this.someObject, { a: 1, b: 2 })`
this.someObject = Object.assign({}, this.someObject, { a: 1, b: 2 })

#数组替换新值
#Array.prototype.splice
example1.items.splice(indexOfItem, 1, newValue)
#Vue.set
Vue.set(example1.items, indexOfItem, newValue)
```
---
title: MySQL使用
copyright: false
date: 2019-05-23 14:52:00
tags: 
 - mysql
categories: 
 - 系统
---
## MySQL基本使用
```bash
mysql -u root -p	#登录
mysqladmin -u root -proot password newpassword;		#修改密码
mysqldump -uroot -p888 -R jxstar -r d:\jxstar.sql 	#导出服务器上数据库的备份文件
mysql -uroot -p888 jxstar < d:\jxstar.sql 	#导入数据库备份文件
max_allowed_packet = 32M	#大数据导入到MYSQL数据库出现错误退出的解决办法--my.ini
CREATE DATABASE `jxstar` CHARACTER SET 'utf8' COLLATE 'utf8_bin';   #创建数据库

#开启外网调试，启动外网连接数据库
grant all on *.* to root@'%' identified by '123456';
flush privileges;
```

## MySQL函数使用
```bash
left join和right join 用于将2个或以上表进行连接查询:
left join会查出左表里所有数据,查出右表里满足条件的数据,
right join自然就是查出右表里所有数据，查出左表里满足条件的数据
LIMIT 开始位置, 行数 	####注意：开始位置可以省略，默认是0位置
source /opt/apollo-build-scripts/sql/apolloportaldb.sql
source /opt/apollo-build-scripts/sql/apolloconfigdb.sql
FROM_UNIXTIME(1156219870) #转为时间，比Java少3位数
UNIX_TIMESTAMP(’2011-12-07 12:23:00′) #日期转Long，比Java少3位数
FROM_UNIXTIME(LEFT('1556553600000',LENGTH('1556553600000')-3) #截取后面3位，转为时间
where、group by、having、order by、limit #语句里不允许上述排序的后面的语法出现在前面语法

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;#禁用外键约束
DROP TABLE IF EXISTS `annual_leave_manual_log`;
#....
SET FOREIGN_KEY_CHECKS = 1;#启动外键约束
```

## 常用函数和Mybatis语法
```bash
IFNULL(calculateTypeNameRest,'无此加班类型') calculateTypeNameRest #设置默认值
inner JOIN org_unit ou ON m.unit_id = ou.unit_id 		#内连接，只有查询满足条件的值

#日期比较,加日期
<if test="null != params.signinTimeEnd and '' != params.signinTimeEnd">
    AND signin_date <![CDATA[<]]>
    DATE_ADD(#{params.signinTimeEnd,jdbcType=DATE},INTERVAL 1 DAY)
</if>

#基于Long型的字符串比较
<if test="null != params.endTime and '' != params.endTime">
    AND acss.end_time <![CDATA[<]]>
    DATE_ADD(FROM_UNIXTIME(LEFT(#{params.endTime},LENGTH(#{params.endTime})-3)),INTERVAL 1 DAY)
</if>

#like查询，字符串拼接
<if test="null != params.employeeCode and '' != params.employeeCode">
    AND employee_code LIKE
    CONCAT('%',#{params.employeeCode,jdbcType=VARCHAR},'%')
</if>

#更新时,则字段无论值有没有变化，它的值也会跟着更新为当前UPDATE操作时的时间
`update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间'

LOCATE(substr,str) #返回字符串substr中第一次出现子字符串的位置 str。
LEFT(str,7) 	#截取字符串前7位，超出长度，不报错

#修改列属性
alter table annual_leave_manual_log MODIFY COLUMN `holiday_type_name` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '年假' COMMENT '假期类型名称（来源于数据字典）';

#添加新字段
ALTER TABLE att_overtime_config_main ADD `card_submission` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否允许无打卡提交加班申请 1是 0否';

#插入多行数据
insert into `dictionary_info` ( `dic_id`, `info_code`, `info_name`, `create_user`, `delflag`, `update_user`,`sort`, `status`)
SELECT dic_id,'1' AS info_code,'忘记打卡' AS info_name,'admin' AS create_user, '0' AS delflag,'admin' AS update_user, '1' AS sort, '1' AS status FROM dictionary WHERE dic_code = 'GOOUT_REASONS'
UNION ALL
SELECT dic_id,'2' AS info_code,'设备故障' AS info_name,'admin' AS create_user, '0' AS delflag,'admin' AS update_user, '2' AS sort, '1' AS status FROM dictionary WHERE dic_code = 'GOOUT_REASONS'
UNION ALL
SELECT dic_id,'3' AS info_code,'开会' AS info_name,'admin' AS create_user, '0' AS delflag,'admin' AS update_user, '3' AS sort, '1' AS status FROM dictionary WHERE dic_code = 'GOOUT_REASONS'
UNION ALL
SELECT dic_id,'4' AS info_code,'培训' AS info_name,'admin' AS create_user, '0' AS delflag,'admin' AS update_user, '4' AS sort, '1' AS status FROM dictionary WHERE dic_code = 'GOOUT_REASONS'
UNION ALL
SELECT dic_id,'5' AS info_code,'其他' AS info_name,'admin' AS create_user, '0' AS delflag,'admin' AS update_user, '5' AS sort, '1' AS status FROM dictionary WHERE dic_code = 'GOOUT_REASONS'

#查出数据，再更新列
UPDATE `process_rule_config` p SET p.`cause_config`= (
SELECT GROUP_CONCAT(di.id) AS cause_config FROM dictionary_info di 
LEFT JOIN dictionary d ON d.dic_id = di.dic_id
WHERE d.delflag = 0 
AND di.delflag = 0 
AND d.dic_code = "EXT_APPLY_REASONS"
AND di.info_name in ('忘记打卡','设备故障','替班','其他')
GROUP BY dic_code )
WHERE p.id IN (
    SELECT t.id FROM(
        SELECT p.id
        FROM process_rule_config p 
        WHERE p.config_type = 14 AND p.is_enabled = 1 AND p.cause_config IS NULL
    ) t
);

#for循环
<if test="params.unitIds != null and params.unitIds.size > 0">
    AND ou.unit_id in
    <foreach collection="params.unitIds" item="unitId" index="index" separator="," open="(" close=")">
        #{unitId,jdbcType=INTEGER}
    </foreach>
</if>
```

## 类型注释
```bash
double(6,2) #总共占6位数字，小数点后占两位，小数点前占4位
TINYINT		#(0，255) 小整数值----IP
SMALLINT 	#(0，65 535) 大整数值----TCP端口
MEDIUMINT	#(0，16 777 215) 大整数值
INT或INTEGER #(0，4 294 967 295) 大整数值
BIGINT 		#(0，18 446 744 073 709 551 615) 极大整数值
```
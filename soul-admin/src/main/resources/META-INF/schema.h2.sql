-- Licensed to the Apache Software Foundation (ASF) under one
-- or more contributor license agreements.  See the NOTICE file
-- distributed with this work for additional information
-- regarding copyright ownership.  The ASF licenses this file
-- to you under the Apache License, Version 2.0 (the
-- "License"); you may not use this file except in compliance
-- with the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


/*Table structure for table `dashboard_user` */
CREATE TABLE IF NOT EXISTS `dashboard_user` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `user_name` varchar(64) NOT NULL COMMENT 'user name',
  `password` varchar(128) DEFAULT NULL COMMENT 'user password',
  `role` int(4) NOT NULL COMMENT 'role',
  `enabled` tinyint(4) NOT NULL COMMENT 'delete or not',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`),
  UNIQUE KEY(`user_name`)
);

/*Table structure for table `plugin` */
CREATE TABLE IF NOT EXISTS `plugin` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `name` varchar(62) NOT NULL COMMENT 'plugin name',
  `config` text COMMENT 'plugin configuration',
  `role` int(4) NOT NULL COMMENT 'plug-in role',
  `enabled` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'whether to open (0, not open, 1 open)',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `plugin_handle` (
  `id` varchar(128) NOT NULL,
  `plugin_id` varchar(128) NOT NULL COMMENT 'plugin id',
  `field` varchar(100) NOT NULL COMMENT 'field',
  `label` varchar(100) DEFAULT NULL COMMENT 'label',
  `data_type` smallint(6) NOT NULL DEFAULT '1' COMMENT 'data type 1 number 2 string',
  `type` smallint(6) NULL COMMENT 'type, 1 means selector, 2 means rule',
  `sort` int(4)  NULL COMMENT 'sort',
  `ext_obj` varchar(1024) DEFAULT NULL COMMENT 'extra configuration (json format data)',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugin_id_field_type` (`plugin_id`,`field`,`type`)
);


/*Table structure for table `selector` */
CREATE TABLE IF NOT EXISTS `selector` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id varchar' primary key,
  `plugin_id` varchar(128) NOT NULL COMMENT 'plugin id',
  `name` varchar(64) NOT NULL COMMENT 'selector name',
  `match_mode` int(2) NOT NULL COMMENT 'matching mode (0 and 1 or)',
  `type` int(4) NOT NULL COMMENT 'type (0, full flow, 1 custom flow)',
  `sort` int(4) NOT NULL COMMENT 'sort',
  `handle` varchar(1024) DEFAULT NULL COMMENT 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)',
  `enabled` tinyint(4) NOT NULL COMMENT 'whether to open',
  `loged` tinyint(4) NOT NULL COMMENT 'whether to print the log',
  `continued` tinyint(4) NOT NULL COMMENT 'whether to continue execution',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  UNIQUE KEY(`name`)
);

/*Table structure for table `selector_condition` */
CREATE TABLE IF NOT EXISTS `selector_condition` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `selector_id` varchar(128) NOT NULL COMMENT 'selector id',
  `param_type` varchar(64) NOT NULL COMMENT 'parameter type (to query uri, etc.)',
  `operator` varchar(64) NOT NULL COMMENT 'matching character (=> <like matching)',
  `param_name` varchar(64) NOT NULL COMMENT 'parameter name',
  `param_value` varchar(64) NOT NULL COMMENT 'parameter value',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
);

/*Table structure for table `rule` */
CREATE TABLE IF NOT EXISTS `rule` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id' PRIMARY KEY,
  `selector_id` varchar(128) NOT NULL COMMENT 'selector id',
  `match_mode` int(2) NOT NULL COMMENT 'matching mode (0 and 1 or)',
  `name` varchar(128) NOT NULL COMMENT 'rule name',
  `enabled` tinyint(4) NOT NULL COMMENT 'whether to open',
  `loged` tinyint(4) NOT NULL COMMENT 'whether to log or not',
  `sort` int(4) NOT NULL COMMENT 'sort',
  `handle` varchar(1024) DEFAULT NULL COMMENT 'processing logic (here for different plug-ins, there will be different fields to identify different processes, all data in JSON format is stored)',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
   UNIQUE KEY (`name`)
);

CREATE TABLE IF NOT EXISTS `rule_condition` (
  `id` varchar(128) NOT NULL COMMENT 'primary key id' PRIMARY KEY,
  `rule_id` varchar(128) NOT NULL COMMENT 'rule id',
  `param_type` varchar(64) NOT NULL COMMENT 'parameter type (post query uri, etc.)',
  `operator` varchar(64) NOT NULL COMMENT 'matching character (=> <like match)',
  `param_name` varchar(64) NOT NULL COMMENT 'parameter name',
  `param_value` varchar(64) NOT NULL COMMENT 'parameter value',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time'
);

CREATE TABLE  IF NOT EXISTS `meta_data` (
  `id` varchar(128) NOT NULL COMMENT 'id',
  `app_name` varchar(255) NOT NULL COMMENT 'application name',
  `path` varchar(255) NOT NULL COMMENT 'path, cannot be repeated',
  `path_desc` varchar(255) NOT NULL COMMENT 'path description',
  `rpc_type` varchar(64) NOT NULL COMMENT 'rpc type',
  `service_name` varchar(255) NULL DEFAULT NULL COMMENT 'service name',
  `method_name` varchar(255) NULL DEFAULT NULL COMMENT 'method name',
  `parameter_types` varchar(255) NULL DEFAULT NULL COMMENT 'parameter types are provided with multiple parameter types separated by commas',
  `rpc_ext` varchar(512) NULL DEFAULT NULL COMMENT 'rpc extended information, json format',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  `enabled` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'enabled state',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `app_auth`  (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `app_key` varchar(32) NOT NULL COMMENT 'application identification key',
  `app_secret` varchar(128) NOT NULL COMMENT 'encryption algorithm secret',
  `user_id` varchar(128) NULL DEFAULT NULL COMMENT 'user id',
  `phone` varchar(255) NULL DEFAULT NULL COMMENT 'phone number when the user applies',
  `ext_info` varchar(1024) NULL DEFAULT NULL COMMENT 'extended parameter json',
  `open` tinyint(4) NOT NULL COMMENT 'open auth path or not',
  `enabled` tinyint(4) NOT NULL COMMENT 'delete or not',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `auth_param`  (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `auth_id` varchar(128) NULL DEFAULT NULL COMMENT 'authentication table id',
  `app_name` varchar(255) NOT NULL COMMENT 'business Module',
  `app_param` varchar(255) NULL DEFAULT NULL COMMENT 'service module parameters (parameters that need to be passed by the gateway) json type',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
);

-- ----------------------------
-- Table structure for auth_path
-- ----------------------------
CREATE TABLE IF NOT EXISTS `auth_path`  (
  `id` varchar(128) NOT NULL COMMENT 'primary key id',
  `auth_id` varchar(128) NOT NULL COMMENT 'auth table id',
  `app_name` varchar(255) NOT NULL COMMENT 'module',
  `path` varchar(255) NOT NULL COMMENT 'path',
  `enabled` tinyint(4) NOT NULL COMMENT 'whether pass 1 is',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `soul_dict` (
   `id` varchar(128) NOT NULL COMMENT 'primary key id',
   `type` varchar(100) NOT NULL COMMENT 'type',
   `dict_code` varchar(100) NOT NULL COMMENT 'dictionary encoding',
   `dict_name` varchar(100) NOT NULL COMMENT 'dictionary name',
   `dict_value` varchar(100) DEFAULT NULL COMMENT 'dictionary value',
   `desc` varchar(255) DEFAULT NULL COMMENT 'dictionary description or remarks',
   `sort` int(4) NOT NULL COMMENT 'sort',
   `enabled` tinyint(4) DEFAULT NULL COMMENT 'whether it is enabled',
   `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
   `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
   PRIMARY KEY (`id`)
 );

-- ----------------------------
-- Table structure for permission role
-- ----------------------------
CREATE TABLE IF NOT EXISTS `role` (
    `id` varchar(128) NOT NULL COMMENT 'primary key id',
    `role_name` varchar(32) NOT NULL COMMENT 'role name',
    `description` varchar(255) DEFAULT NULL COMMENT 'role describe',
    `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
    `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
    PRIMARY KEY (`id`,`role_name`)
    );
-- ----------------------------
-- Table structure for user_role
-- ----------------------------
CREATE TABLE IF NOT EXISTS `user_role` (
    `id` varchar(128) NOT NULL COMMENT 'primary key id',
    `user_id` varchar(128) NOT NULL COMMENT 'user primary key',
    `role_id` varchar(128) NOT NULL COMMENT 'role primary key',
    `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
    `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
    PRIMARY KEY (`id`)
    );
-- ----------------------------
-- Table structure for permission
-- ----------------------------
CREATE TABLE IF NOT EXISTS `permission` (
    `id` varchar(128) NOT NULL COMMENT 'primary key id',
    `object_id` varchar(128) NOT NULL COMMENT 'user primary key id or role primary key id',
    `resource_id` varchar(128) NOT NULL COMMENT 'resource primary key id',
    `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
    `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
    PRIMARY KEY (`id`)
    );
-- ----------------------------
-- Table structure for resource
-- ----------------------------
CREATE TABLE IF NOT EXISTS `resource` (
    `id` varchar(128) NOT NULL COMMENT 'primary key id',
    `parent_id` varchar(128) NOT NULL COMMENT 'resource parent primary key id',
    `title` varchar(128) NOT NULL COMMENT 'title',
    `name` varchar(32) NOT NULL COMMENT 'route name',
    `url` varchar(32) NOT NULL COMMENT 'route url',
    `component` varchar(32) NOT NULL COMMENT 'component',
    `resource_type` int(4) NOT NULL COMMENT 'resource type eg 0:main menu 1:child menu 2:function button',
    `sort` int(4) NOT NULL COMMENT 'sort',
    `icon` varchar(32) NOT NULL COMMENT 'icon',
    `is_leaf` tinyint(1) NOT NULL COMMENT 'leaf node 0:no 1:yes',
    `is_route` int(4) NOT NULL COMMENT 'route 1:yes 0:no',
    `perms` varchar(64) NOT NULL COMMENT 'button permission description sys:user:add(add)/sys:user:edit(edit)',
    `status` int(4) NOT NULL COMMENT 'status 1:enable 0:disable',
    `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
    `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
    PRIMARY KEY (`id`)
    );

/*soul dict*/
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('1','degradeRuleGrade','DEGRADE_GRADE_RT','slow call ratio','0','degrade type-slow call ratio',1,1,'2020-11-18 14:39:56','2020-11-20 15:43:43');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('2','degradeRuleGrade','DEGRADE_GRADE_EXCEPTION_RATIO','exception ratio','1','degrade type-abnormal ratio',0,1,'2020-11-18 16:42:34','2020-11-20 15:42:58');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('3','degradeRuleGrade','DEGRADE_GRADE_EXCEPTION_COUNT','exception number strategy','2','degrade type-abnormal number strategy',2,1,'2020-11-19 16:23:45','2020-11-20 16:01:00');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('4','flowRuleGrade','FLOW_GRADE_QPS','QPS','1','grade type-QPS',0,1,'2020-11-20 15:42:03','2020-11-20 15:42:03');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('5','flowRuleGrade','FLOW_GRADE_THREAD','number of concurrent threads','0','degrade type-number of concurrent threads',1,1,'2020-11-20 15:44:44','2020-11-20 15:44:44');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('6','flowRuleControlBehavior','CONTROL_BEHAVIOR_DEFAULT','direct rejection by default','0','control behavior-direct rejection by default',0,1,'2020-11-20 15:46:22','2020-11-20 15:48:36');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('7','flowRuleControlBehavior','CONTROL_BEHAVIOR_WARM_UP','warm up','1','control behavior-warm up',1,1,'2020-11-20 15:47:05','2020-11-20 15:47:05');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('8','flowRuleControlBehavior','CONTROL_BEHAVIOR_RATE_LIMITER','constant speed queuing','2','control behavior-uniform speed queuing',2,1,'2020-11-20 15:49:45','2020-11-20 15:49:45');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('9','flowRuleControlBehavior','CONTROL_BEHAVIOR_WARM_UP_RATE_LIMITER','preheating uniformly queued','3','control behavior-preheating uniformly queued',3,1,'2020-11-20 15:51:25', '2020-11-20 15:51:37');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('10','permission','REJECT','reject','reject','reject',0,1,'2020-11-22 12:04:10','2020-11-22 12:04:10');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('11','permission','ALLOW','allow','allow','allow',1,1,'2020-11-22 12:04:10','2020-11-22 12:04:10');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('15','algorithmName','ALGORITHM_SLIDINGWINDOW','slidingWindow','slidingWindow','Sliding window algorithm',0,1,'2020-11-20 15:42:03','2020-11-20 15:42:03');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('16','algorithmName','ALGORITHM_LEAKYBUCKET','leakyBucket','leakyBucket','Leaky bucket algorithm',1,1,'2020-11-20 15:44:44','2020-11-20 15:44:44');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('17','algorithmName','ALGORITHM_CONCURRENT','concurrent','concurrent','Concurrent algorithm',2,1,'2020-11-20 15:42:03','2020-11-20 15:42:03');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('18','algorithmName','ALGORITHM_TOKENBUCKET','tokenBucket','tokenBucket','Token bucket algorithm',3,1,'2020-11-20 15:44:44','2020-11-20 15:44:44');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('19', 'loadBalance', 'LOAD_BALANCE', 'roundRobin', 'roundRobin', 'roundRobin', 2, 1, '2021-03-08 19:11:35', '2021-03-08 19:11:35');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('20', 'loadBalance', 'LOAD_BALANCE', 'random', 'random', 'random', 1, 1, '2021-03-08 19:10:17', '2021-03-08 19:10:17');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('21', 'loadBalance', 'LOAD_BALANCE', 'hash', 'hash', 'hash', 0, 1, '2021-03-08 19:09:10', '2021-03-08 19:09:10');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('22', 'status', 'DIVIDE_STATUS', 'close', 'false', 'close', 1, 1, '2021-03-08 14:21:58', '2021-03-08 14:21:58');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('23', 'status', 'DIVIDE_STATUS', 'open', 'true', 'open', 0, 1, '2021-03-08 14:21:32', '2021-03-08 14:21:32');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('24', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'multiple rule', '1', 'multiple rule', 1, 1, '2021-03-08 13:40:38', '2021-03-08 13:40:38');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('25', 'multiRuleHandle', 'MULTI_RULE_HANDLE', 'single rule', '0', 'single rule', 0, 1, '2021-03-08 13:39:30', '2021-03-08 13:39:30');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('26', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'multiple handle', '1', 'multiple handle', 1, 1, '2021-03-08 13:26:48', '2021-03-08 13:39:54');
INSERT INTO `soul_dict` (`id`, `type`,`dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('27', 'multiSelectorHandle', 'MULTI_SELECTOR_HANDLE', 'single handle', '0', 'single handle', 0, 1, '2021-03-08 13:26:05', '2021-03-08 13:27:54');

/*plugin*/
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('1','sign','1', '0', '2018-06-14 10:17:35', '2018-06-14 10:17:35');
INSERT INTO `plugin` (`id`, `name`,`role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('2','waf', '1','{"model":"black"}','0', '2018-06-23 10:26:30', '2018-06-13 15:43:10');
INSERT INTO `plugin` (`id`, `name`,`role`, `enabled`, `date_created`, `date_updated`) VALUES ('3','rewrite', '1','0', '2018-06-23 10:26:34', '2018-06-25 13:59:31');
INSERT INTO `plugin` (`id`, `name`,`role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('4','rate_limiter','1','{"master":"mymaster","mode":"standalone","url":"192.168.1.1:6379","password":"abc"}', '0', '2018-06-23 10:26:37', '2018-06-13 15:34:48');
INSERT INTO `plugin` (`id`, `name`,`role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('5','divide', '0', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', '1', '2018-06-25 10:19:10', '2018-06-13 13:56:04');
INSERT INTO `plugin` (`id`, `name`,`role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('6','dubbo','1','{"register":"zookeeper://localhost:2181"}', '0', '2018-06-23 10:26:41', '2018-06-11 10:11:47');
INSERT INTO `plugin` (`id`, `name`,`role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('7','monitor', '1','{"metricsName":"prometheus","host":"localhost","port":"9190","async":"true"}','0', '2018-06-25 13:47:57', '2018-06-25 13:47:57');
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('8','springCloud','1', '0', '2018-06-25 13:47:57', '2018-06-25 13:47:57');
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('9','hystrix', '0','0', '2020-01-15 10:19:10', '2020-01-15 10:19:10');
INSERT INTO `plugin` (`id`, `name`,`role`, `enabled`, `date_created`, `date_updated`) VALUES ('10','sentinel', '1','0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`, `config`, `enabled`, `date_created`, `date_updated`) VALUES ('11','sofa', '0', '{"protocol":"zookeeper","register":"127.0.0.1:2181"}', '0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('12','resilience4j', '1','0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('13', 'tars', '1', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', '0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('14', 'context_path', '1','1', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`,`config`,`enabled`, `date_created`, `date_updated`) VALUES ('15', 'grpc', '1', '{"multiSelectorHandle":"1","multiRuleHandle":"0"}', '0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO `plugin` (`id`, `name`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('16', 'redirect', '1','0', '2020-11-09 01:19:10', '2020-11-09 01:19:10');

/**default admin user**/
INSERT INTO `dashboard_user` (`id`, `user_name`, `password`, `role`, `enabled`, `date_created`, `date_updated`) VALUES ('1','admin','jHcpKkiDbbQh7W7hh8yQSA==', '1', '1', '2018-06-23 15:12:22', '2018-06-23 15:12:23');

/*insert plugin_handle data for sentinel*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('1','10' ,'flowRuleGrade','flowRuleGrade','3', 2, 8, '{"required":"1","defaultValue":"1","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('2','10' ,'flowRuleControlBehavior','flowRuleControlBehavior','3', 2, 5, '{"required":"1","defaultValue":"0","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('3','10' ,'flowRuleEnable','flowRuleEnable (1 or 0)', '1', 2, 7, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('4','10' ,'flowRuleCount','flowRuleCount','1', 2, 6, '{"required":"1","defaultValue":"0","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('5','10' ,'degradeRuleEnable','degradeRuleEnable (1 or 0)', '1', 2, 2, '{"required":"1","defaultValue":"1","rule":"/^[01]$/"}', '2020-11-09 01:19:10', '2020-11-09 01:19:10') ;
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('6','10' ,'degradeRuleGrade','degradeRuleGrade','3', 2, 3, '{"required":"1","defaultValue":"0","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('7','10' ,'degradeRuleCount','degradeRuleCount','1', 2, 1, '{"required":"1","defaultValue":"0","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('8','10' ,'degradeRuleTimeWindow','degradeRuleTimeWindow','1', 2, 4, '{"required":"1","defaultValue":"0","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');

/*insert plugin_handle data for waf*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('9','2' ,'permission','permission','3', 2, 1, '2020-11-22 12:04:10', '2020-11-22 12:04:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('10','2' ,'statusCode','statusCode','2', 2, 2, '2020-11-22 12:04:10', '2020-11-22 12:04:10');

/*insert plugin_handle data for rate_limiter*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('11', '4' ,'replenishRate','replenishRate', 2, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', '2020-11-24 00:17:10', '2020-11-24 00:17:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('12', '4' ,'burstCapacity','burstCapacity', 2, 2, 3, '{"required":"1","defaultValue":"100","rule":""}', '2020-11-24 00:17:10', '2020-11-24 00:17:10');

/*insert plugin_handle data for rewrite*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('13', '3' ,'rewriteURI','rewriteURI', 2, 2, 1, '2020-11-29 16:07:10', '2020-11-29 16:07:10');

/*insert plugin_handle data for rewrite*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('42', '16' ,'redirectURI','redirectURI', 2, 2, 1, '2020-11-29 16:07:10', '2020-11-29 16:07:10');

/*insert plugin_handle data for springCloud*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('14', '8' ,'path','path', 2, 2, 1, '2020-11-29 16:07:10', '2020-11-29 16:07:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('15', '8' ,'timeout','timeout (ms)', 1, 2, 2, '2020-11-29 16:07:10', '2020-11-29 16:07:10');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('16', '8' ,'serviceId','serviceId', 2, 1, 1, '2020-11-29 16:07:10', '2020-11-29 16:07:10');

/*insert plugin_handle data for resilience4j*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('17', '12' ,'timeoutDurationRate','timeoutDurationRate (ms)', 1, 2, 1, '{"required":"1","defaultValue":"5000","rule":""}', '2020-11-28 11:08:14', '2020-11-28 11:19:12');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('18', '12' ,'limitRefreshPeriod','limitRefreshPeriod (ms)', 1, 2, 0, '{"required":"1","defaultValue":"500","rule":""}', '2020-11-28 11:18:54', '2020-11-28 11:22:40');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('19', '12' ,'limitForPeriod','limitForPeriod', 1, 2, 0, '{"required":"1","defaultValue":"50","rule":""}', '2020-11-28 11:20:11', '2020-11-28 11:20:11');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('20', '12' ,'circuitEnable','circuitEnable', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', '2020-11-28 11:23:09', '2020-11-28 11:24:12');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('21', '12' ,'timeoutDuration','timeoutDuration (ms)', 1, 2, 2, '{"required":"1","defaultValue":"30000","rule":""}', '2020-11-28 11:25:56', '2020-11-28 11:25:56');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('22', '12' ,'fallbackUri','fallbackUri', 2, 2, 2, '2020-11-28 11:26:44', '2020-11-28 11:26:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('23', '12' ,'slidingWindowSize','slidingWindowSize', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', '2020-11-28 11:27:34', '2020-11-28 11:27:34');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('24', '12' ,'slidingWindowType','slidingWindowType', 1, 2, 2, '{"required":"1","defaultValue":"0","rule":"/^[01]$/"}', '2020-11-28 11:28:05', '2020-11-28 11:28:05');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('25', '12' ,'minimumNumberOfCalls','minimumNumberOfCalls', 1, 2, 2, '{"required":"1","defaultValue":"100","rule":""}', '2020-11-28 11:28:34', '2020-11-28 11:28:34');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('26', '12' ,'waitIntervalFunctionInOpenState','waitIntervalInOpen', 1, 2, 2, '{"required":"1","defaultValue":"60000","rule":""}', '2020-11-28 11:29:01', '2020-11-28 11:29:01');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('27', '12' ,'permittedNumberOfCallsInHalfOpenState','bufferSizeInHalfOpen', 1, 2, 2, '{"required":"1","defaultValue":"10","rule":""}', '2020-11-28 11:29:55', '2020-11-28 11:29:55');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('28', '12' ,'failureRateThreshold','failureRateThreshold', 1, 2, 2, '{"required":"1","defaultValue":"50","rule":""}', '2020-11-28 11:30:40', '2020-11-28 11:30:40');

/*insert plugin_handle data for plugin*/
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('30', '4', 'mode', 'mode', 3, 3, 1, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('31', '4', 'master', 'master', 2, 3, 2, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('32', '4', 'url', 'url', 2, 3, 3, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('33', '4', 'password', 'password', 2, 3, 4, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('34', '11', 'protocol', 'protocol', 2, 3, 1, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('35', '11', 'register', 'register', 2, 3, 2, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('36', '2', 'model', 'model', 2, 3, 1, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('37', '6', 'register', 'register', 2, 3, 1, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('38', '7', 'metricsName', 'metricsName', 2, 3, 1, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('39', '7', 'host', 'host', 2, 3, 2, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('40', '7', 'port', 'port', 2, 3, 3, '{"rule":"/^[0-9]*$/"}', '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO plugin_handle (`id`, `plugin_id`, `field`, `label`, `data_type`, `type`, `sort`, `ext_obj`, `date_created`, `date_updated`) VALUES ('41', '7', 'async', 'async', 2, 3, 4, NULL, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
/*insert plugin_handle data for plugin rate_limiter*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('43','4' ,'algorithmName','algorithmName','3', 2, 1, '{"required":"1","defaultValue":"slidingWindow","rule":""}', '2020-11-09 01:19:10', '2020-11-09 01:19:10');

/*insert mode data for rate_limiter plugin*/
INSERT INTO soul_dict (`id`, `type`, `dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('12', 'mode', 'MODE', 'cluster', 'cluster', 'cluster', 0, 1, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO soul_dict (`id`, `type`, `dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('13', 'mode', 'MODE', 'sentinel', 'sentinel', 'sentinel', 1, 1, '2020-12-25 00:00:00', '2020-12-25 00:00:00');
INSERT INTO soul_dict (`id`, `type`, `dict_code`, `dict_name`, `dict_value`, `desc`, `sort`, `enabled`, `date_created`, `date_updated`) VALUES ('14', 'mode', 'MODE', 'standalone', 'standalone', 'standalone', 2, 1, '2020-12-25 00:00:00', '2020-12-25 00:00:00');

/*insert plugin_handle data for context path*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`date_created`,`date_updated`) VALUES ('29', '14', 'contextPath', 'contextPath', 2, 2, 0, '2020-12-25 16:13:09', '2020-12-25 16:13:09');

/*insert plugin_handle data for divide*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('44', '5', 'upstreamHost', 'host', 2, 1, 0, null, '2021-03-06 21:23:41', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('45', '5', 'protocol', 'protocol', 2, 1, 2, '{"required":"1","defaultValue":"","placeholder":"http://","rule":""}', '2021-03-06 21:25:37', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('46', '5', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2021-03-06 21:25:55', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('47', '5', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2021-03-06 21:26:35', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('48', '5', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2021-03-06 21:27:11', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('49', '5', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}', '2021-03-06 21:27:34', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('50', '5', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2021-03-06 21:29:16', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('51', '5', 'loadBalance', 'loadStrategy', 3, 2, 0, null, '2021-03-06 21:30:32', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('52', '5', 'retry', 'retryCount', 1, 2, 1, null, '2021-03-06 21:31:00', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('53', '5', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', '2021-03-07 21:13:50', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('54', '5', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, '2021-03-08 13:18:44', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('55', '5', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, '2021-03-08 13:37:12', '2021-03-09 10:32:51');

/*insert plugin_handle data for tars*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('56', '13', 'upstreamHost', 'host', 2, 1, 0, null, '2021-03-06 21:23:41', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('57', '13', 'protocol', 'protocol', 2, 1, 2, '{"defaultValue":"","rule":""}', '2021-03-06 21:25:37', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('58', '13', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2021-03-06 21:25:55', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('59', '13', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2021-03-06 21:26:35', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('60', '13', 'timestamp', 'startupTime', 1, 1, 3, '{"defaultValue":"0","placeholder":"startup timestamp","rule":""}', '2021-03-06 21:27:11', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('61', '13', 'warmup', 'warmupTime', 1, 1, 5, '{"defaultValue":"0","placeholder":"warmup time (ms)","rule":""}', '2021-03-06 21:27:34', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('62', '13', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2021-03-06 21:29:16', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('63', '13', 'loadBalance', 'loadStrategy', 3, 2, 0, null, '2021-03-06 21:30:32', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('64', '13', 'retry', 'retryCount', 1, 2, 1, null, '2021-03-06 21:31:00', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('65', '13', 'timeout', 'timeout', 1, 2, 2, '{"defaultValue":"3000","rule":""}', '2021-03-07 21:13:50', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('66', '13', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, '2021-03-08 13:18:44', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('67', '13', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, '2021-03-08 13:37:12', '2021-03-09 10:32:51');

/*insert plugin_handle data for grpc*/
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('69', '15', 'protocol', 'protocol', 2, 1, 2, '{"defaultValue":"","rule":""}', '2021-03-06 21:25:37', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('70', '15', 'upstreamUrl', 'ip:port', 2, 1, 1, '{"required":"1","placeholder":"","rule":""}', '2021-03-06 21:25:55', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('71', '15', 'weight', 'weight', 1, 1, 3, '{"defaultValue":"50","rule":""}', '2021-03-06 21:26:35', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('74', '15', 'status', 'status', 3, 1, 6, '{"defaultValue":"true","rule":""}', '2021-03-06 21:29:16', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('78', '15', 'multiSelectorHandle', 'multiSelectorHandle', 3, 3, 0, null, '2021-03-08 13:18:44', '2021-03-09 10:32:51');
INSERT INTO plugin_handle (`id`,`plugin_id`,`field`,`label`,`data_type`,`type`,`sort`,`ext_obj`,`date_created`,`date_updated`) VALUES ('79', '15', 'multiRuleHandle', 'multiRuleHandle', 3, 3, 1, null, '2021-03-08 13:37:12', '2021-03-09 10:32:51');

/** insert permission role for role */
INSERT INTO `role` (`id`,`role_name`,`description`,`date_created`,`date_updated`) VALUES ('1346358560427216896', 'super', '超级管理员', '2021-01-05 01:31:10', '2021-01-08 17:00:07');
INSERT INTO `role` (`id`,`role_name`,`description`,`date_created`,`date_updated`) VALUES ('1385482862971723776', 'default', '普通用户', '2021-04-23 14:37:10', '2021-04-23 14:38:39');

/** insert resource ror resource */
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346775491550474240','','SOUL.MENU.PLUGIN.LIST','plug','/plug','PluginList','0','0','dashboard','0','0','','1','2021-01-06 05:07:54','2021-01-07 18:34:11');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1357956838021890048','','SOUL.MENU.CONFIG.MANAGMENT','config','/config','config','0','1','api','0','0','','1','2021-02-06 15:38:34','2021-02-06 15:47:25');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346776175553376256','','SOUL.MENU.SYSTEM.MANAGMENT','system','/system','system','0','2','setting','0','0','','1','2021-01-06 05:10:37','2021-01-07 11:41:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346777157943259136','1346776175553376256','SOUL.MENU.SYSTEM.MANAGMENT.USER','manage','/system/manage','manage','1','1','user','0','0','','1','2021-01-06 05:14:31','2021-01-15 23:46:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346777449787125760','1357956838021890048','SOUL.MENU.SYSTEM.MANAGMENT.PLUGIN','plugin','/config/plugin','plugin','1','2','book','0','0','','1','2021-01-06 05:15:41','2021-01-15 23:46:35');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346777623011880960','1357956838021890048','SOUL.PLUGIN.PLUGINHANDLE','pluginhandle','/config/pluginhandle','pluginhandle','1','3','down-square','0','0','','1','2021-01-06 05:16:22','2021-01-15 23:46:36');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346777766301888512','1357956838021890048','SOUL.MENU.SYSTEM.MANAGMENT.AUTHEN','auth','/config/auth','auth','1','4','audit','0','0','','1','2021-01-06 05:16:56','2021-01-15 23:46:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346777907096285184','1357956838021890048','SOUL.MENU.SYSTEM.MANAGMENT.METADATA','metadata','/config/metadata','metadata','1','5','snippets','0','0','','1','2021-01-06 05:17:30','2021-01-15 23:46:39');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1346778036402483200','1357956838021890048','SOUL.MENU.SYSTEM.MANAGMENT.DICTIONARY','dict','/config/dict','dict','1','6','ordered-list','0','0','','1','2021-01-06 05:18:00','2021-01-15 23:46:41');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347026381504262144','1346775491550474240','divide','divide','/plug/divide','divide','1','0','border-bottom','0','0','','1','2021-01-06 21:44:51','2021-01-17 16:01:47');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347026805170909184','1346775491550474240','hystrix','hystrix','/plug/hystrix','hystrix','1','1','stop','0','0','','1','2021-01-06 21:46:32','2021-01-07 11:46:31');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027413357572096','1346775491550474240','rewrite','rewrite','/plug/rewrite','rewrite','1','2','redo','0','0','','1','2021-01-06 21:48:57','2021-01-07 11:48:56');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027482244820992','1346775491550474240','springCloud','springCloud','/plug/springCloud','springCloud','1','3','ant-cloud','0','0','','1','2021-01-06 21:49:13','2021-01-07 11:49:12');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027526339538944','1346775491550474240','sign','sign','/plug/sign','sign','1','5','highlight','0','0','','1','2021-01-06 21:49:23','2021-01-07 14:12:07');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027566034432000','1346775491550474240','waf','waf','/plug/waf','waf','1','6','database','0','0','','1','2021-01-06 21:49:33','2021-01-07 14:12:09');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027647999520768','1346775491550474240','rate_limiter','rate_limiter','/plug/rate_limiter','rate_limiter','1','7','pause','0','0','','1','2021-01-06 21:49:53','2021-01-07 14:12:11');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027717792739328','1346775491550474240','dubbo','dubbo','/plug/dubbo','dubbo','1','8','align-left','0','0','','1','2021-01-06 21:50:09','2021-01-07 14:12:12');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027769747582976','1346775491550474240','monitor','monitor','/plug/monitor','monitor','1','9','camera','0','0','','1','2021-01-06 21:50:22','2021-01-07 14:12:14');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027830602739712','1346775491550474240','sentinel','sentinel','/plug/sentinel','sentinel','1','10','pic-center','0','0','','1','2021-01-06 21:50:36','2021-01-07 14:12:16');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027918121086976','1346775491550474240','resilience4j','resilience4j','/plug/resilience4j','resilience4j','1','11','pic-left','0','0','','1','2021-01-06 21:50:57','2021-01-07 14:12:20');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027995199811584','1346775491550474240','tars','tars','/plug/tars','tars','1','12','border-bottom','0','0','','1','2021-01-06 21:51:15','2021-01-07 14:12:21');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347028169120821248','1346775491550474240','context_path','context_path','/plug/context_path','context_path','1','13','retweet','0','0','','1','2021-01-06 21:51:57','2021-01-07 14:12:24');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347028169120821249','1346775491550474240','grpc','grpc','/plug/grpc','grpc','1','15','retweet','0','0','','1','2021-01-06 21:51:57','2021-01-07 14:12:24');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347032308726902784','1346777157943259136','SOUL.BUTTON.SYSTEM.ADD','','','','2','0','','1','0','system:manager:add','1','2021-01-06 22:08:24','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347032395901317120','1346777157943259136','SOUL.BUTTON.SYSTEM.LIST','','','','2','1','','1','0','system:manager:list','1','2021-01-06 22:08:44','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347032453707214848','1346777157943259136','SOUL.BUTTON.SYSTEM.DELETE','','','','2','2','','1','0','system:manager:delete','1','2021-01-06 22:08:58','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347032509051056128','1346777157943259136','SOUL.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:manager:edit','1','2021-01-06 22:09:11','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347034027070337024','1346777449787125760','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:plugin:list','1','2021-01-06 22:15:00','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347039054925148160','1346777449787125760','SOUL.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:plugin:delete','1','2021-01-06 22:34:38','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347041326749691904','1346777449787125760','SOUL.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:plugin:add','1','2021-01-06 22:44:14','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347046566244003840','1346777449787125760','SOUL.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','3','','1','0','system:plugin:modify','1','2021-01-07 13:05:03','2021-01-17 12:06:23');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047143350874112','1346777449787125760','SOUL.BUTTON.SYSTEM.ENABLE','','','','2','4','','1','0','system:plugin:disable','1','2021-01-07 13:07:21','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047203220369408','1346777449787125760','SOUL.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:plugin:edit','1','2021-01-07 13:07:35','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047555588042752','1346777623011880960','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:pluginHandler:list','1','2021-01-07 13:08:59','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047640145211392','1346777623011880960','SOUL.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:pluginHandler:delete','1','2021-01-07 13:09:19','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047695002513408','1346777623011880960','SOUL.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:pluginHandler:add','1','2021-01-07 13:09:32','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347047747305484288','1346777623011880960','SOUL.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:pluginHandler:edit','1','2021-01-07 13:09:45','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048004105940992','1346777766301888512','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:authen:list','1','2021-01-07 13:10:46','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048101875167232','1346777766301888512','SOUL.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:authen:delete','1','2021-01-07 13:11:09','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048145877610496','1346777766301888512','SOUL.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:authen:add','1','2021-01-07 13:11:20','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048240677269504','1346777766301888512','SOUL.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:authen:disable','1','2021-01-07 13:11:42','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048316216684544','1346777766301888512','SOUL.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','4','','1','0','system:authen:modify','1','2021-01-07 13:12:00','2021-01-17 12:06:23');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048776029843456','1346777766301888512','SOUL.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:authen:edit','1','2021-01-07 13:13:50','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347048968414179328','1346777907096285184','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:meta:list','1','2021-01-07 13:14:36','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049029323862016','1346777907096285184','SOUL.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:meta:delete','1','2021-01-07 13:14:50','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049092552994816','1346777907096285184','SOUL.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:meta:add','1','2021-01-07 13:15:05','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049251395481600','1346777907096285184','SOUL.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:meta:disable','1','2021-01-07 13:15:43','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049317178945536','1346777907096285184','SOUL.BUTTON.SYSTEM.SYNCHRONIZE','','','','2','4','','1','0','system:meta:modify','1','2021-01-07 13:15:59','2021-01-17 12:06:23');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049370014593024','1346777907096285184','SOUL.BUTTON.SYSTEM.EDIT','','','','2','5','','1','0','system:meta:edit','1','2021-01-07 13:16:11','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049542417264640','1346778036402483200','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:dict:list','1','2021-01-07 13:16:53','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049598155370496','1346778036402483200','SOUL.BUTTON.SYSTEM.DELETE','','','','2','1','','1','0','system:dict:delete','1','2021-01-07 13:17:06','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049659023110144','1346778036402483200','SOUL.BUTTON.SYSTEM.ADD','','','','2','2','','1','0','system:dict:add','1','2021-01-07 13:17:20','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049731047698432','1346778036402483200','SOUL.BUTTON.SYSTEM.ENABLE','','','','2','3','','1','0','system:dict:disable','1','2021-01-07 13:17:38','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347049794008395776','1346778036402483200','SOUL.BUTTON.SYSTEM.EDIT','','','','2','4','','1','0','system:dict:edit','1','2021-01-07 13:17:53','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347050493052071936','1347026381504262144','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:divideSelector:add','1','2021-01-07 13:20:39','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347050998931271680','1347026381504262144','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:divideSelector:delete','1','2021-01-07 13:22:40','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051241320099840','1347026381504262144','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:divideRule:add','1','2021-01-07 13:23:38','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051306788990976','1347026381504262144','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:divideRule:delete','1','2021-01-07 13:23:53','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051641725136896','1347026381504262144','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:divide:modify','1','2021-01-07 13:25:13','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051850521784320','1347026805170909184','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:hystrixSelector:add','1','2021-01-07 13:26:03','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051853025783808','1347026805170909184','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:hystrixSelector:delete','1','2021-01-07 13:26:03','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051855538171904','1347026805170909184','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:hystrixRule:add','1','2021-01-07 13:26:04','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051857962479616','1347026805170909184','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:hystrixRule:delete','1','2021-01-07 13:26:05','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347051860495839232','1347026805170909184','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:hystrix:modify','1','2021-01-07 13:26:05','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052833968631808','1347027413357572096','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:rewriteSelector:add','1','2021-01-07 13:29:57','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052836300664832','1347027413357572096','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:rewriteSelector:delete','1','2021-01-07 13:29:58','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052839198928896','1347027413357572096','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:rewriteRule:add','1','2021-01-07 13:29:59','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052841824563200','1347027413357572096','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:rewriteRule:delete','1','2021-01-07 13:29:59','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052843993018368','1347027413357572096','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:rewrite:modify','1','2021-01-07 13:30:00','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053324018528256','1347027482244820992','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:springCloudSelector:add','1','2021-01-07 13:31:54','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053326988095488','1347027482244820992','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:springCloudSelector:delete','1','2021-01-07 13:31:55','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053329378848768','1347027482244820992','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:springCloudRule:add','1','2021-01-07 13:31:55','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053331744436224','1347027482244820992','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:springCloudRule:delete','1','2021-01-07 13:31:56','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053334470733824','1347027482244820992','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:springCloud:modify','1','2021-01-07 13:31:57','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053363814084608','1347027526339538944','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:signSelector:add','1','2021-01-07 13:32:04','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053366552965120','1347027526339538944','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:signSelector:delete','1','2021-01-07 13:32:04','2021-01-17 11:54:13');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053369413480448','1347027526339538944','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:signRule:add','1','2021-01-07 13:32:05','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053372164943872','1347027526339538944','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:signRule:delete','1','2021-01-07 13:32:06','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053375029653504','1347027526339538944','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:sign:modify','1','2021-01-07 13:32:06','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053404050042880','1347027566034432000','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:wafSelector:add','1','2021-01-07 13:32:13','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053406939918336','1347027566034432000','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:wafSelector:delete','1','2021-01-07 13:32:14','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053409842376704','1347027566034432000','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:wafRule:add','1','2021-01-07 13:32:15','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053413067796480','1347027566034432000','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:wafRule:delete','1','2021-01-07 13:32:15','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053415945089024','1347027566034432000','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:waf:modify','1','2021-01-07 13:32:16','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053442419535872','1347027647999520768','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:rate_limiterSelector:add','1','2021-01-07 13:32:22','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053445191970816','1347027647999520768','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:rate_limiterSelector:delete','1','2021-01-07 13:32:23','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053447695970304','1347027647999520768','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:rate_limiterRule:add','1','2021-01-07 13:32:24','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053450304827392','1347027647999520768','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:rate_limiterRule:delete','1','2021-01-07 13:32:24','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053452737523712','1347027647999520768','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:rate_limiter:modify','1','2021-01-07 13:32:25','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053477844627456','1347027717792739328','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:dubboSelector:add','1','2021-01-07 13:32:31','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053480977772544','1347027717792739328','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','2','','1','0','plugin:dubboSelector:delete','1','2021-01-07 13:32:32','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053483712458752','1347027717792739328','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:dubboRule:add','1','2021-01-07 13:32:32','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053486426173440','1347027717792739328','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:dubboRule:delete','1','2021-01-07 13:32:33','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053489571901440','1347027717792739328','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:dubbo:modify','1','2021-01-07 13:32:34','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053516423835648','1347027769747582976','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:monitorSelector:add','1','2021-01-07 13:32:40','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053519401791488','1347027769747582976','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:monitorSelector:delete','1','2021-01-07 13:32:41','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053522182615040','1347027769747582976','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:monitorRule:add','1','2021-01-07 13:32:41','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053525034741760','1347027769747582976','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:monitorRule:delete','1','2021-01-07 13:32:42','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053527819759616','1347027769747582976','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:monitor:modify','1','2021-01-07 13:32:43','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053554310983680','1347027830602739712','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:sentinelSelector:add','1','2021-01-07 13:32:49','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053556512993280','1347027830602739712','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:sentinelSelector:delete','1','2021-01-07 13:32:50','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053559050547200','1347027830602739712','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:sentinelRule:add','1','2021-01-07 13:32:50','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053561579712512','1347027830602739712','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:sentinelRule:delete','1','2021-01-07 13:32:51','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053564016603136','1347027830602739712','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:sentinel:modify','1','2021-01-07 13:32:51','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053595729735680','1347027918121086976','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:resilience4jSelector:add','1','2021-01-07 13:32:59','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053598829326336','1347027918121086976','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:resilience4jSelector:delete','1','2021-01-07 13:33:00','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053601572401152','1347027918121086976','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:resilience4jRule:add','1','2021-01-07 13:33:00','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053604093177856','1347027918121086976','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:resilience4jRule:delete','1','2021-01-07 13:33:01','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053606622343168','1347027918121086976','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:resilience4j:modify','1','2021-01-07 13:33:02','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053631159021568','1347027995199811584','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:tarsSelector:add','1','2021-01-07 13:33:07','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053633809821696','1347027995199811584','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:tarsSelector:delete','1','2021-01-07 13:33:08','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053636439650304','1347027995199811584','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:tarsRule:add','1','2021-01-07 13:33:09','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053638968815616','1347027995199811584','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:tarsRule:delete','1','2021-01-07 13:33:09','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053641346985984','1347027995199811584','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:tars:modify','1','2021-01-07 13:33:10','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053666227597312','1347028169120821248','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:context_pathSelector:add','1','2021-01-07 13:33:16','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053668538658816','1347028169120821248','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:context_pathSelector:delete','1','2021-01-07 13:33:16','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053670791000064','1347028169120821248','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:context_pathRule:add','1','2021-01-07 13:33:17','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053673043341312','1347028169120821248','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:context_pathRule:delete','1','2021-01-07 13:33:17','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347053675174047744','1347028169120821248','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:context_path:modify','1','2021-01-07 13:33:18','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347063567603609600','1346775491550474240','sofa','sofa','/plug/sofa','sofa','1','4','fire','0','0','','1','2021-01-07 14:12:36','2021-01-15 23:24:04');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347064011369361408','1347063567603609600','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:sofaSelector:add','1','2021-01-07 14:14:22','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347064013848195072','1347063567603609600','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:sofaSelector:delete','1','2021-01-07 14:14:23','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347064016373166080','1347063567603609600','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:sofaRule:add','1','2021-01-07 14:14:23','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347064019007188992','1347063567603609600','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:sofaRule:delete','1','2021-01-07 14:14:24','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347064021486022656','1347063567603609600','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:sofa:modify','1','2021-01-07 14:14:25','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350096617689751552','1347026381504262144','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:divideSelector:edit','1','2021-01-15 23:04:52','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350096630197166080','1347026381504262144','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:divideRule:edit','1','2021-01-15 23:04:55','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350098233939632128','1347026805170909184','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:hystrixSelector:edit','1','2021-01-15 23:11:17','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350098236741427200','1347026805170909184','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:hystrixRule:edit','1','2021-01-15 23:11:18','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099831950163968','1347027413357572096','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','4','','1','0','plugin:rewriteSelector:edit','1','2021-01-15 23:17:38','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099836492595200','1347027413357572096','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','4','','1','0','plugin:rewriteRule:edit','1','2021-01-15 23:17:39','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099893203779584','1347027482244820992','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:springCloudSelector:edit','1','2021-01-15 23:17:53','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099896441782272','1347027482244820992','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:springCloudRule:edit','1','2021-01-15 23:17:54','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099936379944960','1347027526339538944','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:signSelector:edit','1','2021-01-15 23:18:03','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099939177545728','1347027526339538944','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:signRule:edit','1','2021-01-15 23:18:04','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099976435548160','1347027566034432000','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:wafSelector:edit','1','2021-01-15 23:18:13','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099979434475520','1347027566034432000','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:wafRule:edit','1','2021-01-15 23:18:13','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100013341229056','1347027647999520768','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:rate_limiterSelector:edit','1','2021-01-15 23:18:21','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100016319184896','1347027647999520768','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:rate_limiterRule:edit','1','2021-01-15 23:18:22','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100053757542400','1347027717792739328','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:dubboSelector:edit','1','2021-01-15 23:18:31','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100056525783040','1347027717792739328','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:dubboRule:edit','1','2021-01-15 23:18:32','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100110510669824','1347027769747582976','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:monitorSelector:edit','1','2021-01-15 23:18:45','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100113283104768','1347027769747582976','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:monitorRule:edit','1','2021-01-15 23:18:45','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100147437322240','1347027830602739712','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:sentinelSelector:edit','1','2021-01-15 23:18:53','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100150096510976','1347027830602739712','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:sentinelRule:edit','1','2021-01-15 23:18:54','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100190894505984','1347027918121086976','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:resilience4jSelector:edit','1','2021-01-15 23:19:04','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100193801158656','1347027918121086976','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:resilience4jRule:edit','1','2021-01-15 23:19:05','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100229360467968','1347027995199811584','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:tarsSelector:edit','1','2021-01-15 23:19:13','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100232451670016','1347027995199811584','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:tarsRule:edit','1','2021-01-15 23:19:14','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100269307019264','1347028169120821248','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:context_pathSelector:edit','1','2021-01-15 23:19:23','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100272083648512','1347028169120821248','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:context_pathRule:edit','1','2021-01-15 23:19:23','2021-01-17 11:57:37');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100334205485056','1347063567603609600','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:sofaSelector:edit','1','2021-01-15 23:19:38','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795968','1347063567603609600','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:sofaRule:edit','1','2021-01-15 23:19:39','2021-01-17 11:57:37');

INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795969','1347028169120821249','SOUL.BUTTON.PLUGIN.SELECTOR.ADD','','','','2','0','','1','0','plugin:grpcSelector:add','1','2021-01-07 13:33:07','2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795970','1347028169120821249','SOUL.BUTTON.PLUGIN.SELECTOR.DELETE','','','','2','1','','1','0','plugin:grpcSelector:delete','1','2021-01-07 13:33:08','2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795971','1347028169120821249','SOUL.BUTTON.PLUGIN.RULE.ADD','','','','2','2','','1','0','plugin:grpcRule:add','1','2021-01-07 13:33:09','2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795972','1347028169120821249','SOUL.BUTTON.PLUGIN.RULE.DELETE','','','','2','3','','1','0','plugin:grpcRule:delete','1','2021-01-07 13:33:09','2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795973','1347028169120821249','SOUL.BUTTON.PLUGIN.SYNCHRONIZE','','','','2','4','','1','0','plugin:grpc:modify','1','2021-01-07 13:33:10','2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795974','1347028169120821249','SOUL.BUTTON.PLUGIN.SELECTOR.EDIT','','','','2','5','','1','0','plugin:grpcSelector:edit','1','2021-01-15 23:19:13','2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350100337363795975','1347028169120821249','SOUL.BUTTON.PLUGIN.RULE.EDIT','','','','2','6','','1','0','plugin:grpcRule:edit','1','2021-01-15 23:19:14','2021-01-17 11:57:37');

INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350106119681622016','1346776175553376256','SOUL.MENU.SYSTEM.MANAGMENT.ROLE','role','/system/role','role','1','0','usergroup-add','0','0','','1','2021-01-15 23:42:37','2021-01-17 16:00:24');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350107709494804480','1350106119681622016','SOUL.BUTTON.SYSTEM.ADD','','','','2','0','','1','0','system:role:add','1','2021-01-15 23:48:56','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350107842236137472','1350106119681622016','SOUL.BUTTON.SYSTEM.LIST','','','','2','1','','1','0','system:role:list','1','2021-01-15 23:49:28','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350112406754766848','1350106119681622016','SOUL.BUTTON.SYSTEM.DELETE','','','','2','2','','1','0','system:role:delete','1','2021-01-16 00:07:36','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350112481253994496','1350106119681622016','SOUL.BUTTON.SYSTEM.EDIT','','','','2','3','','1','0','system:role:edit','1','2021-01-16 00:07:54','2021-01-17 11:21:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350804501819195392','1346777766301888512','SOUL.BUTTON.SYSTEM.EDITRESOURCEDETAILS','','','','2','6','','1','0','system:authen:editResourceDetails','1','2021-01-17 21:57:45','2021-01-17 21:57:44');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1355163372527050752','1346776175553376256','SOUL.MENU.SYSTEM.MANAGMENT.RESOURCE','resource','/system/resource','resource','1','2','menu','0','0','','1','2021-01-29 22:38:20','2021-02-06 14:04:23');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1355165158419750912','1355163372527050752','SOUL.BUTTON.RESOURCE.MENU.ADD','','','','2','1','','1','0','system:resource:addMenu','1','2021-01-29 22:45:26','2021-02-06 17:10:40');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1355165353534578688','1355163372527050752','SOUL.BUTTON.SYSTEM.LIST','','','','2','0','','1','0','system:resource:list','1','2021-01-29 22:46:13','2021-02-06 17:10:40');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1355165475785957376','1355163372527050752','SOUL.BUTTON.RESOURCE.MENU.DELETE','','','','2','2','','1','0','system:resource:deleteMenu','1','2021-01-29 22:46:42','2021-02-06 16:59:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1355165608565039104','1355163372527050752','SOUL.BUTTON.RESOURCE.MENU.EDIT','','','','2','3','','1','0','system:resource:editMenu','1','2021-01-29 22:47:13','2021-02-06 16:59:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1357977745889132544','1355163372527050752','SOUL.BUTTON.RESOURCE.BUTTON.ADD','','','','2','4','','1','0','system:resource:addButton','1','2021-02-06 17:01:39','2021-02-06 17:04:35');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1357977912126177280','1355163372527050752','SOUL.SYSTEM.EDITOR','','','','2','5','','1','0','system:resource:editButton','1','2021-02-06 17:02:19','2021-02-06 17:23:57');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES  ('1357977971827900416','1355163372527050752','SOUL.SYSTEM.DELETEDATA','','','','2','6','','1','0','system:resource:deleteButton','1','2021-02-06 17:02:33','2021-02-06 17:25:28');

/** insert redirect resource */
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347027413357572097', '1346775491550474240', 'redirect', 'redirect', '/plug/redirect', 'redirect', 1, 16, 'redo', 0, 0, '', 1, '2021-01-06 21:48:57', '2021-01-07 11:48:56');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052833968631809', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.SELECTOR.ADD', '', '', '', 2, 0, '', 1, 0, 'plugin:redirectSelector:add', 1, '2021-01-07 13:29:57', '2021-01-17 11:46:18');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052836300664833', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.SELECTOR.DELETE', '', '', '', 2, 1, '', 1, 0, 'plugin:redirectSelector:delete', 1, '2021-01-07 13:29:58', '2021-01-17 11:47:02');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052839198928897', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.RULE.ADD', '', '', '', 2, 2, '', 1, 0, 'plugin:redirectRule:add', 1, '2021-01-07 13:29:59', '2021-01-17 11:46:32');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052841824563201', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.RULE.DELETE', '', '', '', 2, 3, '', 1, 0, 'plugin:redirectRule:delete', 1, '2021-01-07 13:29:59', '2021-01-17 11:46:59');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1347052843993018369', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.SYNCHRONIZE', '', '', '', 2, 4, '', 1, 0, 'plugin:redirect:modify', 1, '2021-01-07 13:30:00', '2021-01-17 11:56:30');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099831950163969', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.SELECTOR.EDIT', '', '', '', 2, 4, '', 1, 0, 'plugin:redirectSelector:edit', 1, '2021-01-15 23:17:38', '2021-01-17 11:57:34');
INSERT INTO `resource` (`id`, `parent_id`, `title`, `name`, `url`, `component`, `resource_type`, `sort`, `icon`, `is_leaf`, `is_route`, `perms`, `status`, `date_created`, `date_updated`) VALUES('1350099836492595201', '1347027413357572097', 'SOUL.BUTTON.PLUGIN.RULE.EDIT', '', '', '', 2, 4, '', 1, 0, 'plugin:redirectRule:edit', 1, '2021-01-15 23:17:39', '2021-01-17 11:57:37');

/** insert admin role */
INSERT INTO `user_role` (`id`, `user_id`, `role_id`, `date_created`, `date_updated`) VALUES ('1351007709096976384', '1', '1346358560427216896', '2021-01-18 11:25:13', '2021-01-18 11:25:13');

/** insert admin permission */
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708572688384', '1346358560427216896', '1346775491550474240', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708585271296', '1346358560427216896', '1346776175553376256', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708593659904', '1346358560427216896', '1346777157943259136', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708597854208', '1346358560427216896', '1346777449787125760', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708606242816', '1346358560427216896', '1346777623011880960', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708610437120', '1346358560427216896', '1346777766301888512', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708614631424', '1346358560427216896', '1346777907096285184', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708623020032', '1346358560427216896', '1346778036402483200', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708627214336', '1346358560427216896', '1347026381504262144', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708631408640', '1346358560427216896', '1347026805170909184', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708639797248', '1346358560427216896', '1347027413357572096', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708643991552', '1346358560427216896', '1347027482244820992', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708648185856', '1346358560427216896', '1347027526339538944', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708652380160', '1346358560427216896', '1347027566034432000', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708656574464', '1346358560427216896', '1347027647999520768', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708660768768', '1346358560427216896', '1347027717792739328', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708669157376', '1346358560427216896', '1347027769747582976', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708673351680', '1346358560427216896', '1347027830602739712', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708677545984', '1346358560427216896', '1347027918121086976', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708681740288', '1346358560427216896', '1347027995199811584', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708685934592', '1346358560427216896', '1347028169120821248', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708685934593', '1346358560427216896', '1347032308726902784', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708690128896', '1346358560427216896', '1347032395901317120', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708694323200', '1346358560427216896', '1347032453707214848', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708698517504', '1346358560427216896', '1347032509051056128', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708702711808', '1346358560427216896', '1347034027070337024', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708706906112', '1346358560427216896', '1347039054925148160', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708711100416', '1346358560427216896', '1347041326749691904', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708715294720', '1346358560427216896', '1347046566244003840', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708719489024', '1346358560427216896', '1347047143350874112', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708723683328', '1346358560427216896', '1347047203220369408', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708727877632', '1346358560427216896', '1347047555588042752', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708732071936', '1346358560427216896', '1347047640145211392', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708732071937', '1346358560427216896', '1347047695002513408', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708736266240', '1346358560427216896', '1347047747305484288', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708740460544', '1346358560427216896', '1347048004105940992', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708744654848', '1346358560427216896', '1347048101875167232', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708744654849', '1346358560427216896', '1347048145877610496', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708748849152', '1346358560427216896', '1347048240677269504', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708753043456', '1346358560427216896', '1347048316216684544', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708757237760', '1346358560427216896', '1347048776029843456', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708757237761', '1346358560427216896', '1347048968414179328', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708761432064', '1346358560427216896', '1347049029323862016', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708765626368', '1346358560427216896', '1347049092552994816', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708769820672', '1346358560427216896', '1347049251395481600', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708774014976', '1346358560427216896', '1347049317178945536', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708774014977', '1346358560427216896', '1347049370014593024', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708778209280', '1346358560427216896', '1347049542417264640', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708782403584', '1346358560427216896', '1347049598155370496', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708786597888', '1346358560427216896', '1347049659023110144', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708790792192', '1346358560427216896', '1347049731047698432', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708794986496', '1346358560427216896', '1347049794008395776', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708799180800', '1346358560427216896', '1347050493052071936', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708799180801', '1346358560427216896', '1347050998931271680', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708803375104', '1346358560427216896', '1347051241320099840', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708807569408', '1346358560427216896', '1347051306788990976', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708807569409', '1346358560427216896', '1347051641725136896', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708811763712', '1346358560427216896', '1347051850521784320', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708815958016', '1346358560427216896', '1347051853025783808', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708815958017', '1346358560427216896', '1347051855538171904', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708820152320', '1346358560427216896', '1347051857962479616', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708824346624', '1346358560427216896', '1347051860495839232', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708828540928', '1346358560427216896', '1347052833968631808', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708828540929', '1346358560427216896', '1347052836300664832', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708832735232', '1346358560427216896', '1347052839198928896', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708836929536', '1346358560427216896', '1347052841824563200', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708836929537', '1346358560427216896', '1347052843993018368', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708841123840', '1346358560427216896', '1347053324018528256', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708845318144', '1346358560427216896', '1347053326988095488', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708849512448', '1346358560427216896', '1347053329378848768', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708853706752', '1346358560427216896', '1347053331744436224', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708857901056', '1346358560427216896', '1347053334470733824', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708857901057', '1346358560427216896', '1347053363814084608', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708862095360', '1346358560427216896', '1347053366552965120', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708866289664', '1346358560427216896', '1347053369413480448', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708866289665', '1346358560427216896', '1347053372164943872', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708870483968', '1346358560427216896', '1347053375029653504', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708874678272', '1346358560427216896', '1347053404050042880', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708874678273', '1346358560427216896', '1347053406939918336', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708878872576', '1346358560427216896', '1347053409842376704', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708878872577', '1346358560427216896', '1347053413067796480', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708883066880', '1346358560427216896', '1347053415945089024', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708887261184', '1346358560427216896', '1347053442419535872', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708891455488', '1346358560427216896', '1347053445191970816', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708891455489', '1346358560427216896', '1347053447695970304', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708895649792', '1346358560427216896', '1347053450304827392', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708895649793', '1346358560427216896', '1347053452737523712', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708899844096', '1346358560427216896', '1347053477844627456', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708904038400', '1346358560427216896', '1347053480977772544', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708904038401', '1346358560427216896', '1347053483712458752', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708908232704', '1346358560427216896', '1347053486426173440', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708912427008', '1346358560427216896', '1347053489571901440', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708916621312', '1346358560427216896', '1347053516423835648', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708920815616', '1346358560427216896', '1347053519401791488', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708920815617', '1346358560427216896', '1347053522182615040', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708925009920', '1346358560427216896', '1347053525034741760', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708929204224', '1346358560427216896', '1347053527819759616', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708933398528', '1346358560427216896', '1347053554310983680', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708933398529', '1346358560427216896', '1347053556512993280', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708937592832', '1346358560427216896', '1347053559050547200', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708937592833', '1346358560427216896', '1347053561579712512', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708941787136', '1346358560427216896', '1347053564016603136', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708941787137', '1346358560427216896', '1347053595729735680', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708945981440', '1346358560427216896', '1347053598829326336', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708950175744', '1346358560427216896', '1347053601572401152', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708954370048', '1346358560427216896', '1347053604093177856', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708958564352', '1346358560427216896', '1347053606622343168', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708962758656', '1346358560427216896', '1347053631159021568', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708962758657', '1346358560427216896', '1347053633809821696', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708966952960', '1346358560427216896', '1347053636439650304', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708971147264', '1346358560427216896', '1347053638968815616', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708971147265', '1346358560427216896', '1347053641346985984', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708975341568', '1346358560427216896', '1347053666227597312', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708979535872', '1346358560427216896', '1347053668538658816', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708979535873', '1346358560427216896', '1347053670791000064', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708983730176', '1346358560427216896', '1347053673043341312', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708987924480', '1346358560427216896', '1347053675174047744', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708992118784', '1346358560427216896', '1347063567603609600', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007708996313088', '1346358560427216896', '1347064011369361408', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709000507392', '1346358560427216896', '1347064013848195072', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709000507393', '1346358560427216896', '1347064016373166080', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709004701696', '1346358560427216896', '1347064019007188992', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709008896000', '1346358560427216896', '1347064021486022656', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709008896001', '1346358560427216896', '1350096617689751552', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709013090304', '1346358560427216896', '1350096630197166080', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709013090305', '1346358560427216896', '1350098233939632128', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709017284608', '1346358560427216896', '1350098236741427200', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709021478912', '1346358560427216896', '1350099831950163968', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709021478913', '1346358560427216896', '1350099836492595200', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709025673216', '1346358560427216896', '1350099893203779584', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709029867520', '1346358560427216896', '1350099896441782272', '2021-01-18 11:25:13', '2021-01-18 11:25:12');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709029867521', '1346358560427216896', '1350099936379944960', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709034061824', '1346358560427216896', '1350099939177545728', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709034061825', '1346358560427216896', '1350099976435548160', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709038256128', '1346358560427216896', '1350099979434475520', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709038256129', '1346358560427216896', '1350100013341229056', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709042450432', '1346358560427216896', '1350100016319184896', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709042450433', '1346358560427216896', '1350100053757542400', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709046644736', '1346358560427216896', '1350100056525783040', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709050839040', '1346358560427216896', '1350100110510669824', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709050839041', '1346358560427216896', '1350100113283104768', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709055033344', '1346358560427216896', '1350100147437322240', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709059227648', '1346358560427216896', '1350100150096510976', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709059227649', '1346358560427216896', '1350100190894505984', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709063421952', '1346358560427216896', '1350100193801158656', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709067616256', '1346358560427216896', '1350100229360467968', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709067616257', '1346358560427216896', '1350100232451670016', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709071810560', '1346358560427216896', '1350100269307019264', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709071810561', '1346358560427216896', '1350100272083648512', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709076004864', '1346358560427216896', '1350100334205485056', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709076004865', '1346358560427216896', '1350100337363795968', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709080199168', '1346358560427216896', '1350106119681622016', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709080199169', '1346358560427216896', '1350107709494804480', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709084393472', '1346358560427216896', '1350107842236137472', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709084393473', '1346358560427216896', '1350112406754766848', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709088587776', '1346358560427216896', '1350112481253994496', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1351007709088587777', '1346358560427216896', '1350804501819195392', '2021-01-18 11:25:13', '2021-01-18 11:25:13');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1355167519859040256', '1346358560427216896', '1355163372527050752', '2021-01-29 22:54:49', '2021-01-29 22:58:41');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1355167519859040257', '1346358560427216896', '1355165158419750912', '2021-01-29 22:54:49', '2021-01-29 22:58:41');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1355167519859040258', '1346358560427216896', '1355165353534578688', '2021-01-29 22:54:49', '2021-01-29 22:58:42');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1355167519859040259', '1346358560427216896', '1355165475785957376', '2021-01-29 22:54:49', '2021-01-29 22:58:43');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1355167519859040260', '1346358560427216896', '1355165608565039104', '2021-01-29 22:54:49', '2021-01-29 22:58:43');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357956838021890049', '1346358560427216896', '1357956838021890048', '2021-02-06 15:38:34', '2021-02-06 15:38:34');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977745893326848', '1346358560427216896', '1357977745889132544', '2021-02-06 17:01:39', '2021-02-06 17:01:39');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977912126177281', '1346358560427216896', '1357977912126177280', '2021-02-06 17:02:19', '2021-02-06 17:02:19');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900417', '1346358560427216896', '1357977971827900416', '2021-02-06 17:02:33', '2021-02-06 17:02:33');

INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900418', '1346358560427216896', '1350100337363795969', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900419', '1346358560427216896', '1350100337363795970', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900420', '1346358560427216896', '1350100337363795971', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900421', '1346358560427216896', '1350100337363795972', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900422', '1346358560427216896', '1350100337363795973', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900423', '1346358560427216896', '1350100337363795974', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900424', '1346358560427216896', '1350100337363795975', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900425', '1346358560427216896', '1347028169120821249', '2021-02-06 17:02:33', '2021-02-06 17:02:33');

/** add redirect permissions for admin user */
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900432', '1346358560427216896', '1350099836492595201', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900431', '1346358560427216896', '1350099831950163969', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900430', '1346358560427216896', '1347052843993018369', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900429', '1346358560427216896', '1347052841824563201', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900428', '1346358560427216896', '1347052839198928897', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900427', '1346358560427216896', '1347052836300664833', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900426', '1346358560427216896', '1347052833968631809', '2021-02-06 17:02:33', '2021-02-06 17:02:33');
INSERT INTO `permission` (`id`, `object_id`, `resource_id`, `date_created`, `date_updated`) VALUES ('1357977971827900433', '1346358560427216896', '1347027413357572097', '2021-02-06 17:02:33', '2021-02-06 17:02:33');

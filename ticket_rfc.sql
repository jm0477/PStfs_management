/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50711
Source Host           : localhost:3306
Source Database       : tfs

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2016-04-15 13:57:43
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for ticket_rfc
-- ----------------------------
DROP TABLE IF EXISTS `ticket_rfc`;
CREATE TABLE `ticket_rfc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `T_id` int(11) DEFAULT NULL,
  `T_title` varchar(255) DEFAULT NULL,
  `T_Description` binary(255) DEFAULT NULL,
  `T_Justification` binary(255) DEFAULT NULL,
  `T_PreDeployment` text,
  `T_PostDeployment` text,
  `T_RollbackPlan` text,
  `T_SuccessCriteria` text,
  `T_DeploymentMechanism` text,
  `T_PotentialImp` varchar(255) DEFAULT NULL,
  `T_ExpectedImp` varchar(255) DEFAULT NULL,
  `T_ScheduledStart` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `T_ScheduledEnd` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `T_ActualStart` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `T_ActualEnd` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `T_Attachment` int(11) DEFAULT NULL,
  `T_History` text,
  `T_Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4779 DEFAULT CHARSET=utf8;

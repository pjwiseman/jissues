--
-- Table setup order:
-- #__tracker_projects
-- #__tracker_labels
-- #__tracker_milestones
-- #__status
-- #__issues_relations_types
-- #__issues
-- #__activities
-- #__users
-- #__accessgroups
-- #__user_accessgroup_map
-- #__issues_voting
-- #__articles
--

--
-- Table structure for table `#__tracker_projects`
--

CREATE TABLE IF NOT EXISTS `#__tracker_projects` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `title` varchar(150) NOT NULL COMMENT 'Project title',
  `alias` varchar(150) NOT NULL COMMENT 'Project URL alias',
  `gh_user` varchar(150) NOT NULL COMMENT 'GitHub user',
  `gh_project` varchar(150) NOT NULL COMMENT 'GitHub project',
  `ext_tracker_link` varchar(500) NOT NULL COMMENT 'A tracker link format (e.g. http://tracker.com/issue/%d)',
	`short_title` varchar(50) NOT NULL COMMENT 'Project short title',
  PRIMARY KEY (`project_id`),
  KEY `alias` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data `#__tracker_projects`
--

INSERT INTO `#__tracker_projects` (`project_id`, `title`, `alias`, `gh_user`, `gh_project`, `ext_tracker_link`, `short_title`) VALUES
(1, 'Joomla! CMS', 'joomla-cms', 'joomla', 'joomla-cms', 'http://joomlacode.org/gf/project/joomla/tracker/?action=TrackerItemEdit&tracker_item_id=%d', 'CMS'),
(2, 'J!Tracker', 'jtracker', 'joomla', 'jissues', '', 'J!Tracker'),
(3, 'Joomla! Security', 'joomla-security', '', '', '', 'JSST');

-- --------------------------------------------------------

--
-- Table structure for table `#__tracker_labels`
--

CREATE TABLE IF NOT EXISTS `#__tracker_labels` (
  `label_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `project_id` int(11) NOT NULL COMMENT 'Project ID',
  `name` varchar(50) NOT NULL COMMENT 'Label name',
  `color` varchar(6) NOT NULL COMMENT 'Label color',
  PRIMARY KEY (`label_id`),
  KEY `name` (`name`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `#__tracker_labels_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `#__tracker_projects` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

-- --
-- Table structure for table `#__tracker_milestones`
--

CREATE TABLE `#__tracker_milestones` (
  `milestone_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `milestone_number` int(11) NOT NULL COMMENT 'Milestone number from Github',
  `project_id` int(11) NOT NULL COMMENT 'Project ID',
  `title` varchar(50) NOT NULL COMMENT 'Milestone title',
  `description` mediumtext NOT NULL COMMENT 'Milestone description',
  `state` varchar(6) NOT NULL COMMENT 'Label state: open | closed',
  `due_on` datetime DEFAULT NULL COMMENT 'Date the milestone is due on.',
  PRIMARY KEY (`milestone_id`),
  KEY `name` (`title`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `#__tracker_milestones_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `#__tracker_projects` (`project_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__status`
--

CREATE TABLE IF NOT EXISTS `#__status` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(255) DEFAULT NULL,
  `closed` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `#__status`
--

INSERT INTO `#__status` (`id`, `status`, `closed`) VALUES
(1, 'Open', 0),
(2, 'Confirmed', 0),
(3, 'Pending', 0),
(4, 'Ready to Commit', 0),
(5, 'Fixed in Code Base', 1),
(6, 'Needs Review', 0),
(7, 'Information Required', 0),
(8, 'Closed - Unconfirmed Report', 1),
(9, 'Closed - No Reply', 1),
(10, 'Closed', 1),
(11, 'Expected Behaviour', 1),
(12, 'Known Issue', 1);

-- --------------------------------------------------------

--
-- Table structure for table `#__issues_relations_types`
--

CREATE TABLE IF NOT EXISTS `#__issues_relations_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data `#__issues_relations_types`
--

INSERT INTO `#__issues_relations_types` (`id`, `name`) VALUES
(1, 'duplicate_of'),
(2, 'related_to'),
(3, 'not_before');

-- --------------------------------------------------------

--
-- Table structure for table `#__issues`
--

CREATE TABLE IF NOT EXISTS `#__issues` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `issue_number` int(11) unsigned DEFAULT NULL COMMENT 'THE issue number (ID)',
  `foreign_number` int(11) unsigned DEFAULT NULL COMMENT 'Foreign tracker id',
  `project_id` int(11) unsigned DEFAULT NULL COMMENT 'Project id',
  `milestone_id` int(11) unsigned DEFAULT NULL COMMENT 'Milestone id if applicable',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT 'Issue title',
  `description` mediumtext NOT NULL COMMENT 'Issue description',
  `description_raw` mediumtext NOT NULL COMMENT 'The raw issue description (markdown)',
  `priority` tinyint(4) NOT NULL DEFAULT 3 COMMENT 'Issue priority',
  `status` int(11) unsigned NOT NULL DEFAULT 1 COMMENT 'Issue status',
  `opened_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Issue open date',
  `opened_by` varchar(50) NULL DEFAULT NULL COMMENT 'Opened by username',
  `closed_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Issue closed date',
  `closed_by` varchar(50) NULL DEFAULT NULL COMMENT 'Issue closed by username',
  `closed_sha` varchar(40) DEFAULT NULL COMMENT 'The GitHub SHA where the issue has been closed',
  `modified_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Issue modified date',
  `modified_by` varchar(50) NULL DEFAULT NULL COMMENT 'Issue modified by username',
  `rel_number` int(11) unsigned DEFAULT NULL COMMENT 'Relation issue number',
  `rel_type` int(11) unsigned DEFAULT NULL COMMENT 'Relation type',
  `has_code` tinyint(1)NOT NULL DEFAULT 0 COMMENT 'If the issue has code attached - aka a pull request',
  `labels` varchar(250) NOT NULL COMMENT 'Comma separated list of label IDs',
	`build` varchar(40) NOT NULL DEFAULT '' COMMENT 'Build on which the issue is reported',
	`tests` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Number of successful tests on an item',
	`easy` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Flag whether an item is an easy test',
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `issue_number` (`issue_number`),
  KEY `project_id` (`project_id`),
  KEY `milestone_id` (`milestone_id`,`project_id`),
  CONSTRAINT `#__issues_fk_milestone` FOREIGN KEY (`milestone_id`) REFERENCES `#__tracker_milestones` (`milestone_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `#__issues_fk_status` FOREIGN KEY (`status`) REFERENCES `#__status` (`id`),
	CONSTRAINT `#__issues_fk_rel_type` FOREIGN KEY (`rel_type`) REFERENCES `#__issues_relations_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__activities`
--

CREATE TABLE IF NOT EXISTS `#__activities` (
  `activities_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `gh_comment_id` int(11) unsigned NULL COMMENT 'The GitHub comment id',
  `issue_number` int(11) unsigned NOT NULL COMMENT 'THE issue number (ID)',
  `project_id` int(11) NOT NULL COMMENT 'The Project id',
  `user` varchar(255) NOT NULL DEFAULT '' COMMENT 'The user name',
  `event` varchar(32) NOT NULL COMMENT 'The event type',
  `text` mediumtext NULL COMMENT 'The event text',
  `text_raw` mediumtext NULL COMMENT 'The raw event text',
  `created_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updated_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`activities_id`),
  KEY `issue_number` (`issue_number`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `#__activities_fk_issue_number` FOREIGN KEY (`issue_number`) REFERENCES `#__issues` (`issue_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `#__activities_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `#__tracker_projects` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__users`
--

CREATE TABLE IF NOT EXISTS `#__users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT 'The users name',
  `username` varchar(150) NOT NULL DEFAULT '' COMMENT 'The users username',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT 'The users e-mail',
  `block` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'If the user is blocked',
  `sendEmail` tinyint(4) DEFAULT 0 COMMENT 'If the users recieves e-mail',
  `registerDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'The register date',
  `lastvisitDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'The last visit date',
  `params` text NOT NULL COMMENT 'Parameters',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_block` (`block`),
  KEY `username` (`username`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__accessgroups`
--

CREATE TABLE IF NOT EXISTS `#__accessgroups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `title` varchar(150) NOT NULL,
  `can_view` int(11) NOT NULL,
  `can_create` int(11) NOT NULL,
  `can_manage` int(11) NOT NULL,
  `can_edit` int(11) NOT NULL,
  `can_editown` int(11) NOT NULL,
  `system` int(11) NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `#__accessgroups_fk_project_id` FOREIGN KEY (`project_id`) REFERENCES `#__tracker_projects` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `#__accessgroups`
--

INSERT INTO `#__accessgroups` (`group_id`, `project_id`, `title`, `can_view`, `can_create`, `can_manage`, `can_edit`, `can_editown`, `system`) VALUES
(1, 1, 'Public', 1, 0, 0, 0, 0, 1),
(2, 1, 'User', 1, 1, 0, 0, 1, 1),
(3, 2, 'Public', 1, 0, 0, 0, 0, 1),
(4, 2, 'User', 1, 1, 0, 0, 1, 1),
(5, 3, 'Public', 0, 0, 0, 0, 0, 1),
(6, 3, 'User', 0, 1, 0, 0, 1, 1),
(7, 3, 'JSST', 1, 1, 0, 1, 0, 0),
(8, 3, 'JSST Managers', 1, 1, 1, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `#__user_accessgroup_map`
--

CREATE TABLE IF NOT EXISTS `#__user_accessgroup_map` (
  `user_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Foreign Key to #__users.id',
  `group_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Foreign Key to #__accessgroups.id',
  PRIMARY KEY (`user_id`,`group_id`),
  CONSTRAINT `#__user_accessgroup_map_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `#__users` (`id`),
  CONSTRAINT `#__user_accessgroup_map_fk_group_id` FOREIGN KEY (`group_id`) REFERENCES `#__accessgroups` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `#__issues_voting`
--

CREATE TABLE IF NOT EXISTS `#__issues_voting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
	`issue_number` int(11) unsigned NOT NULL COMMENT 'Foreign key to #__issues.id',
	`user_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Foreign key to #__users.id',
	`experienced` tinyint(2) unsigned NOT NULL COMMENT 'Flag indicating whether the user has experienced the issue',
	`score` int(11) unsigned NOT NULL COMMENT 'User score for importance of issue',
  PRIMARY KEY (`id`),
  CONSTRAINT `#__issues_voting_fk_issue_id` FOREIGN KEY (`issue_number`) REFERENCES `#__issues` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `#__issues_voting_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `#__users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `#__articles`
--

CREATE TABLE IF NOT EXISTS `#__articles` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `path` varchar(500) NOT NULL COMMENT 'The article path',
  `title` varchar(250) NOT NULL COMMENT 'The article title',
  `alias` varchar(250) NOT NULL COMMENT 'The article alias.',
  `text` text NOT NULL COMMENT 'The article text.',
  `text_md` text NOT NULL COMMENT 'The raw article text.',
  `created_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'The created date.',
  `is_file` int(1) unsigned NOT NULL COMMENT 'If the text is present as a file (for different handling)',
  PRIMARY KEY (`article_id`),
  KEY `alias` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `#__articles`
--

INSERT INTO `#__articles` (`title`, `alias`, `text`, `text_md`, `created_date`) VALUES
('The J!Tracker Project', 'about', '<p>Some info about the project here... @todo add more</p>', 'Some info about the project here...  @todo add more', '2013-10-01 00:00:00');

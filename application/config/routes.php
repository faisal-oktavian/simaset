<?php
defined('BASEPATH') OR exit('No direct script access allowed');

$route['default_controller'] = 'auth';
$route['404_override'] = '';
$route['translate_uri_dashes'] = FALSE;

// Auth
$route['login']         = 'auth/index';
$route['login/process'] = 'auth/process';
$route['logout']        = 'auth/logout';

// Dashboard
$route['dashboard'] = 'dashboard/index';

// Master Acquisition Source
$route['master-acquisition-source'] = 'master_acquisition_source/index';
$route['master-acquisition-source/table'] = 'master_acquisition_source/table';
$route['master-acquisition-source/get/(:num)'] = 'master_acquisition_source/get/$1';
$route['master-acquisition-source/store'] = 'master_acquisition_source/store';
$route['master-acquisition-source/update/(:num)'] = 'master_acquisition_source/update/$1';
$route['master-acquisition-source/delete/(:num)'] = 'master_acquisition_source/delete/$1';

// Role and menu access
$route['user_role'] = 'user_role/index';
$route['user_role/save_permissions'] = 'user_role/save_permissions';

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

// Master Acquisition Source / Master Sumber Perolehan Aset
$route['master-acquisition-source'] = 'master_acquisition_source/index';
$route['master-acquisition-source/table'] = 'master_acquisition_source/table';
$route['master-acquisition-source/get/(:num)'] = 'master_acquisition_source/get/$1';
$route['master-acquisition-source/store'] = 'master_acquisition_source/store';
$route['master-acquisition-source/update/(:num)'] = 'master_acquisition_source/update/$1';
$route['master-acquisition-source/delete/(:num)'] = 'master_acquisition_source/delete/$1';

// Master Funding Source / Master Sumber Dana
$route['master-funding-source'] = 'master_funding_source/index';
$route['master-funding-source/table'] = 'master_funding_source/table';
$route['master-funding-source/get/(:num)'] = 'master_funding_source/get/$1';
$route['master-funding-source/store'] = 'master_funding_source/store';
$route['master-funding-source/update/(:num)'] = 'master_funding_source/update/$1';
$route['master-funding-source/delete/(:num)'] = 'master_funding_source/delete/$1';

// Master Category Product / Master Kelompok Aset
$route['master-category-product'] = 'master_category_product/index';
$route['master-category-product/table'] = 'master_category_product/table';
$route['master-category-product/get/(:num)'] = 'master_category_product/get/$1';
$route['master-category-product/store'] = 'master_category_product/store';
$route['master-category-product/update/(:num)'] = 'master_category_product/update/$1';
$route['master-funding-source/delete/(:num)'] = 'master_funding_source/delete/$1';

// Master KIB / Master Kartu Inventaris Barang
$route['master-kib'] = 'master_kib/index';
$route['master-kib/table'] = 'master_kib/table';
$route['master-kib/get/(:num)'] = 'master_kib/get/$1';
$route['master-kib/store'] = 'master_kib/store';
$route['master-kib/update/(:num)'] = 'master_kib/update/$1';
$route['master-kib/delete/(:num)'] = 'master_kib/delete/$1';

// Role and menu access
$route['user_role'] = 'user_role/index';
$route['user_role/save_permissions'] = 'user_role/save_permissions';

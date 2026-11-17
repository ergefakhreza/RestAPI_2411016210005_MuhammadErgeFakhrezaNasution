
<?php

use CodeIgniter\Router\RouteCollection;

/** @var RouteCollection $routes */
$routes->get('/', 'Home::index');

$routes->group('api', ['namespace' => 'App\\Controllers\\Api'], static function ($routes) {
    // Menangani CORS preflight
    $routes->options('umkm', static function () {
        return service('response')->setStatusCode(204);
    });

    $routes->options('umkm/(:num)', static function ($id) {
        return service('response')->setStatusCode(204);
    });

    // GET
    $routes->get('umkm', 'UmkmController::index');
    $routes->get('umkm/(:num)', 'UmkmController::show/$1');

    // POST
    $routes->post('umkm', 'UmkmController::create');

    // PUT
    $routes->put('umkm/(:num)', 'UmkmController::update/$1');

    // DELETE
    $routes->delete('umkm/(:num)', 'UmkmController::delete/$1');
});

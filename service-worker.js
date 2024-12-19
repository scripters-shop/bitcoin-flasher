self.addEventListener('install', function(event) {
    event.waitUntil(
        caches.open('bitcoin-flasher-cache').then(function(cache) {
            return cache.addAll([
                '/',
                '/index.html',
                '/style.css',
                '/script.js',
                '/images/og-image.jpg',
                '/images/twitter-image.jpg',
                '/images/favicon.png',
                '/images/apple-touch-icon.png',
                '/images/icon-192x192.png',
                '/images/icon-512x512.png'
            ]);
        })
    );
});

self.addEventListener('fetch', function(event) {
    event.respondWith(
        caches.match(event.request).then(function(response) {
            return response || fetch(event.request);
        })
    );
});

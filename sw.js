// Define cache name and assets to cache
const CACHE_NAME = 'bitcoin-flasher-v1';
const ASSETS_TO_CACHE = [
    '/',
    '/index.html',
    '/manifest.json',
    '/sw.js',
    'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css',
    'https://cdn.jsdelivr.net/npm/web3@latest/dist/web3.min.js',
    'https://is1-ssl.mzstatic.com/image/thumb/Purple126/v4/f7/01/e4/f701e4a3-88f1-93c1-fe76-435cfbbf8c51/AppIcon-1x_U007emarketing-0-7-0-85-220.png/492x0w.webp'
];

// Install event
self.addEventListener('install', (event) => {
    console.log('[Service Worker] Installing...');
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('[Service Worker] Caching app shell...');
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
});

// Activate event
self.addEventListener('activate', (event) => {
    console.log('[Service Worker] Activating...');
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cache) => {
                    if (cache !== CACHE_NAME) {
                        console.log('[Service Worker] Removing old cache:', cache);
                        return caches.delete(cache);
                    }
                })
            );
        })
    );
});

// Fetch event
self.addEventListener('fetch', (event) => {
    console.log('[Service Worker] Fetching:', event.request.url);
    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request).then((fetchResponse) => {
                return caches.open(CACHE_NAME).then((cache) => {
                    cache.put(event.request, fetchResponse.clone());
                    return fetchResponse;
                });
            });
        }).catch(() => {
            // Fallback to offline message or a cached fallback page
            return caches.match('/index.html');
        })
    );
});

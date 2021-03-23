'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "78dd326b424923eb7402cdb6085f5e25",
"assets/FontManifest.json": "982a995688d386e930823873c7609b26",
"assets/fonts/AkayaTelivigala-Regular.ttf": "31533526895b179fa322a2856bbd4185",
"assets/fonts/Handlee-Regular.ttf": "27f813cadd3a3af891e01acf64272748",
"assets/fonts/Lobster-Regular.ttf": "9406d0ab606cf8cb91c41b65556bd836",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/fonts/Roboto-Regular.ttf": "11eabca2251325cfc5589c9c6fb57b46",
"assets/fonts/RocknRollOne-Regular.ttf": "68e244d0fb0459efd86703125cb44164",
"assets/images/avatar.png": "ea489873d2695b61dbf002cd5e6badeb",
"assets/images/bg.jpg": "fb2fc0906ae361ad70a2c521078f1123",
"assets/images/category1.jpg": "344ec411d26ef21f5edd45091ad24d5f",
"assets/images/category2.jpg": "b14ae42b6f8adc37c4f16dc43fafefba",
"assets/images/category3.jpg": "7fec81a6f377346e62e25323656aae0d",
"assets/images/category4.jpg": "0b155ff49288d0e1937fca443e3ba6b0",
"assets/images/category5.jpg": "fd8b2af8d81947c2886baed093db8de2",
"assets/images/image1.jpeg": "cba5637fcfef7015be37c9b920923683",
"assets/images/image10.jpeg": "f21309c9c5b8e5ea25c80cbbf423e296",
"assets/images/image11.jpeg": "eb68b614c3e20f9e830e910db21fe022",
"assets/images/image2.jpeg": "7082d67176fb6c44ce2575936718f77e",
"assets/images/image3.jpeg": "e9c861155b9e106b61370cb276838b8f",
"assets/images/image4.jpeg": "1e848e04a456c88d45e8496b6098230c",
"assets/images/image5.jpeg": "d8f2be57e91f5e3e5b4119d7d690599a",
"assets/images/image6.jpeg": "128409a71d5c4215f6d87964db5d4202",
"assets/images/image7.jpeg": "80ff84fcf70d1927bb99329c68afd15a",
"assets/images/image8.jpeg": "aab2f92c3d0c23810b2d37567eaad596",
"assets/images/image9.jpeg": "fe8c5d3da053ba48c83475855c9a5fd5",
"assets/images/subcategory1.jpg": "ea04fdaa9e2ff5dde69ec5f8c044ec7a",
"assets/images/subcategory10.jpg": "5be16455a875319fe22cfdafd8036c13",
"assets/images/subcategory11.jpg": "e61be30915dd7df3780762d8c66b748f",
"assets/images/subcategory12.jpg": "9540a8c590776779061af749e93fbc5d",
"assets/images/subcategory13.jpg": "d24a2f821d5b4a6f9846d87354e45bde",
"assets/images/subcategory14.jpg": "7f52c7c1a8961c9c9b577d9227677519",
"assets/images/subcategory15.jpg": "1679de46051c2da09c8424ff437faea8",
"assets/images/subcategory16.jpg": "fc0a546b5f5d2100a0f7fbe8e88fe770",
"assets/images/subcategory17.jpg": "27571004daed058a7417cc2eda274b7d",
"assets/images/subcategory2.jpg": "b4feb87512353fb54adbdb8979ba233d",
"assets/images/subcategory3.jpg": "3f6f093ae3e48ce4799a12c917ee3d3b",
"assets/images/subcategory4.jpg": "dee5fb9fbed82983951f0eb2a5b73f73",
"assets/images/subcategory5.jpg": "7df5f96602aef7da00c69ed752899f5b",
"assets/images/subcategory6.jpg": "21c7bfc37ef578e73848c26aff467f1e",
"assets/images/subcategory7.jpg": "e61e0308259f1d7247c4af3b5f8b375d",
"assets/images/subcategory8.jpg": "8d1ecd910f0b4a34e2599d3a09c3c7e8",
"assets/images/subcategory9.jpg": "8019e8290af3e8bb65b8557c36ae906b",
"assets/NOTICES": "8881f404eb8ebf52fa07d6b489ba27c2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "831eb40a2d76095849ba4aecd4340f19",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "a126c025bab9a1b4d8ac5534af76a208",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "d80ca32233940ebadc5ae5372ccd67f9",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "6ffad14c2fa52ce0b4e73664c03d673c",
"/": "6ffad14c2fa52ce0b4e73664c03d673c",
"main.dart.js": "33cb4579d562ac77f7ba8c945d3004e2",
"manifest.json": "248d48cc953a1f4e900718be228bca97",
"version.json": "ff2986ff9fa14c639d36f4b9d04e67ed"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

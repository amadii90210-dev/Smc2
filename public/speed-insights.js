// Vercel Speed Insights initialization
// Based on @vercel/speed-insights v1.3.1

(function() {
  // Initialize the queue
  if (window.si) return;
  
  window.si = function(...params) {
    (window.siq = window.siq || []).push(params);
  };

  // Create and inject the Speed Insights script
  const script = document.createElement('script');
  script.src = '/_vercel/speed-insights/script.js';
  script.defer = true;
  script.dataset.sdkn = '@vercel/speed-insights';
  script.dataset.sdkv = '1.3.1';
  
  script.onerror = () => {
    console.log(
      '[Vercel Speed Insights] Failed to load script. This is expected in local development. Speed Insights will work when deployed to Vercel.'
    );
  };
  
  document.head.appendChild(script);
})();

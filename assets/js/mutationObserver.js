MutationObserver = window.MutationObserver || window.WebKitMutationObserver;


var observer = new MutationObserver(function (mutations, observer) {
  // 當找到`div.landing-wrapper`時, 當渲染
  const landingWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.landing-wrapper');
  const chatListWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.two');

  /*
  0 = landing page
  1 = chat page
  2 = loading page
  */

  var result;
  if (landingWrapperFounder.length) {
    result = 0;
  } else if (chatListWrapperFounder.length) {
    result = 1;
  } else {
    result = 2;
  }

  window.flutter_inappwebview
    .callHandler('pageStatusHandler', result);
});

observer.observe(document, {
  subtree: true,
  attributes: true
  //...
});

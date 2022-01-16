MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

var observer = new MutationObserver(function (mutations, observer) {
    const landingWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.landing-wrapper');
    const chatListWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.two, #app > div.app-wrapper-web > div.three');

    /*
    0 = landing page
    1 = chat page
    2 = loading page
    */

    var pageStatus;
    if (landingWrapperFounder.length) {
        pageStatus = 0;
    } else if (chatListWrapperFounder.length) {
        pageStatus = 1;
    } else {
        pageStatus = 2;
    }

    window.flutter_inappwebview
        .callHandler('pageStatusHandler', pageStatus);
    // --------
});

observer.observe(document, {
    subtree: true,
    attributes: true
});

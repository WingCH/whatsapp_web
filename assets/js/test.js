MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
var lasterChatroomName;
var observer = new MutationObserver(function (mutations, observer) {
    const landingWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.landing-wrapper');
    const chatListWrapperFounder = document.querySelectorAll('#app > div.app-wrapper-web > div.two');

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
        .callHandler('pageStatusHandler', result);
    // --------

    var currentChatroomName = document.querySelector('#app > div.app-wrapper-web > div.two > div:last-child > div#main > header > div:nth-child(2) > div > div > span')?.title
    if (currentChatroomName !== lasterChatroomName) {
        window.flutter_inappwebview
            .callHandler('chatroomChange', result);
    }
});

observer.observe(document, { childList: true, attributes: true, characterData: true, subtree: true, characterData: true, characterDataOldValue: true });

document.querySelector('#pane-side > div:nth-child(3) > div > div').addEventListener("click", function (event) {
    // var targetElement = event.target || event.srcElement;
    // var currentChatroomName = document.querySelector('#app > div.app-wrapper-web > div > div:last-child > div#main > header > div:nth-child(2) > div > div > span')?.title
    window.flutter_inappwebview
        .callHandler('contactListOnClick');
});
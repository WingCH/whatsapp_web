MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

// 已渲染内容?
var renderedContent = false;

var observer = new MutationObserver(function (mutations, observer) {

  // 當找到`div.landing-wrapper`時, 當渲染
  const found = document.querySelectorAll('#app > div > div.landing-wrapper');
  if (found.length && renderedContent == false) {
    renderedContent = true;
    window.flutter_inappwebview
      .callHandler('renderedContent');
    console.log("sent renderedContent");
    // for (const { textContent } of found) {
    //   console.log("Matching element found: " + textContent);
    // }
  }
});

observer.observe(document, {
  subtree: true,
  attributes: true
  //...
});

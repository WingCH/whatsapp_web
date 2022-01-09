MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

var observer = new MutationObserver(function(mutations, observer) {

  const found = document.querySelectorAll('#app > div > div.landing-wrapper');
              if (found.length) {
                  console.log("Matching elements found: " + found.length);
                  for (const {textContent} of found) {
                      console.log("Matching element found: " + textContent);
                  }
              }
    // fired when a mutation occurs
    console.log(mutations, observer);
    // ...
});

observer.observe(document, {
  subtree: true,
  attributes: true
  //...
});
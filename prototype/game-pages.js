(() => {
  try {
    const settings = JSON.parse(localStorage.getItem("enviromentAll.settings") || "{}");
    document.documentElement.classList.toggle("app-reduced-motion", settings.reduceMotion === true);
    document.documentElement.classList.toggle("app-large-text", settings.largeText === true);
  } catch {
    // Ignore malformed local preferences in the static demo.
  }

  const reducedMotion = () => document.documentElement.classList.contains("app-reduced-motion") || window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let revealObserver;
  if ("IntersectionObserver" in window) {
    revealObserver = new IntersectionObserver((entries, observer) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.classList.add("is-visible");
        observer.unobserve(entry.target);
      });
    }, { threshold: 0.12, rootMargin: "0px 0px -36px 0px" });
  }
  window.observeGameSigns = (root = document) => {
    root.querySelectorAll(".scroll-sign:not(.is-visible)").forEach((sign) => {
      if (reducedMotion() || !revealObserver) sign.classList.add("is-visible");
      else revealObserver.observe(sign);
    });
  };
  document.addEventListener("DOMContentLoaded", () => window.observeGameSigns());
})();

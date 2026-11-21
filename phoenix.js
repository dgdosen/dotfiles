// Constants
// Uniform gap: applied once at every screen edge and once between adjacent windows.
const GAP = 8;

// Helper Functions
// Slots are carved out of (visible area - GAP), then each window is shrunk by GAP,
// so every edge (screen or neighbor) gets exactly one GAP.
// Uses flippedVisibleFrame's x/y so the real menu bar height (39px on the notched
// MacBook, ~25 on externals), a side Dock, and secondary monitors are all respected.
function resizeToFraction(
  xNumerator,
  xDenominator,
  widthNumerator,
  widthDenominator,
  yNumerator,
  yDenominator,
  heightNumerator,
  heightDenominator,
) {
  return () => {
    const window = Window.focused();
    if (window) {
      const screen = window.screen().flippedVisibleFrame();
      const usableWidth = screen.width - GAP;
      const usableHeight = screen.height - GAP;

      const x = screen.x + GAP + (usableWidth * xNumerator) / xDenominator;
      const y = screen.y + GAP + (usableHeight * yNumerator) / yDenominator;
      const width = (usableWidth * widthNumerator) / widthDenominator - GAP;
      const height = (usableHeight * heightNumerator) / heightDenominator - GAP;

      window.setFrame({ x, y, width, height });
    }
  };
}

function focusClosestNeighbor(direction) {
  return () => {
    const window = Window.focused();
    const currentApp = window.app();
    const appWindows = currentApp.windows();
    const neighbors = window.neighbors(direction);
    const thisAppNeighbor = neighbors.find((n) => appWindows.includes(n));
    if (thisAppNeighbor) {
      thisAppNeighbor.focus();
    } else if (neighbors.length > 0) {
      const visibleNeighbor = neighbors.find(
        (n) => n.isVisible() && n.isNormal(),
      );
      if (visibleNeighbor) {
        visibleNeighbor.focus();
      }
    }
  };
}

// Key Bindings
// first 2/5ths - top/bottom with gap
Key.on('d', ['ctrl', 'cmd', 'alt'], resizeToFraction(0, 5, 2, 5, 0, 3, 2, 3));
Key.on('f', ['ctrl', 'cmd', 'alt'], resizeToFraction(0, 5, 2, 5, 2, 3, 1, 3));

// mostly fifths
['g', 'h', 'j', 'k', 'l'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index, 5, 1, 5, 0, 1, 1, 1),
  );
});

// last seven/eights? it's like Stage Manager lite
[';'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index + 1, 8, 7, 8, 0, 1, 1, 1),
  );

});
// ending fourths
[',', '.'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index + 2, 4, 1, 4, 0, 1, 1, 1),
  );
});

// halves
['h', 'l'].forEach((key, index) =>
  Key.on(key, ['alt', 'cmd'], resizeToFraction(index, 2, 1, 2, 0, 1, 1, 1)),
);

// top/bottom
['k', 'j'].forEach((key, index) =>
  Key.on(
    key,
    ['alt', 'cmd'],
    index === 0
      ? resizeToFraction(0, 1, 1, 1, 0, 3, 2, 3) // 'k' => top 2/3
      : resizeToFraction(0, 1, 1, 1, 2, 3, 1, 3) // 'j' => bottom 1/
  )
);

// left 42% column, split vertically like d/f: y = top 2/3, u = bottom 1/3
Key.on('y', ['ctrl', 'cmd', 'alt'], resizeToFraction(0, 100, 42, 100, 0, 3, 2, 3));
Key.on('u', ['ctrl', 'cmd', 'alt'], resizeToFraction(0, 100, 42, 100, 2, 3, 1, 3));

// middle / right columns of the 42/29/29 split, full height
Key.on('i', ['ctrl', 'cmd', 'alt'], resizeToFraction(42, 100, 29, 100, 0, 1, 1, 1));
Key.on('p', ['ctrl', 'cmd', 'alt'], resizeToFraction(71, 100, 29, 100, 0, 1, 1, 1));

// merged right pair (i+p) = right 58%
Key.on('o', ['ctrl', 'cmd', 'alt'], resizeToFraction(42, 100, 58, 100, 0, 1, 1, 1));

// center - inner 1/2 width, full height
Key.on('m', ['ctrl', 'cmd', 'alt'], resizeToFraction(1, 4, 1, 2, 0, 1, 1, 1));
// center - inner 3/4 width (1/8 margin each side), full height
Key.on('n', ['ctrl', 'cmd', 'alt'], resizeToFraction(1, 8, 3, 4, 0, 1, 1, 1));


// fill
Key.on('return', ['cmd', 'alt'], resizeToFraction(0, 1, 1, 1, 0, 1, 1, 1));

// focus
Key.on("h", ["ctrl", "shift", "cmd"], focusClosestNeighbor("west"));
Key.on("l", ["ctrl", "shift", "cmd"], focusClosestNeighbor("east"));
Key.on("k", ["ctrl", "shift", "cmd"], focusClosestNeighbor("north"));
Key.on("j", ["ctrl", "shift", "cmd"], focusClosestNeighbor("south"));


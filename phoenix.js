// Constants
const MENUBAR_HEIGHT = 25;  // macOS menubar height
const EDGE_PADDING = 4;     // padding from screen edges
const WINDOW_GAP = 4;       // gap between tiled windows

// Helper Functions
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
      const xOffset = window.screen().frame().x;

      const x = ((screen.width / xDenominator) * xNumerator) + EDGE_PADDING;
      const y = ((screen.height / yDenominator) * yNumerator) + MENUBAR_HEIGHT;
      const width = ((screen.width / widthDenominator) * widthNumerator) - (EDGE_PADDING * 2);
      const height = ((screen.height / heightDenominator) * heightNumerator) - EDGE_PADDING;

      window.setFrame({ x, y, width, height });
    }
  };
}

function resizeVerticallyInPlace(
  yNumerator,
  yDenominator,
  heightNumerator,
  heightDenominator,
) {
  return () => {
    const window = Window.focused();
    if (window) {
      const screen = window.screen().flippedVisibleFrame();

      const currentFrame = window.frame();
      const x = currentFrame.x;
      const y = (screen.height / yDenominator) * yNumerator + MENUBAR_HEIGHT;
      const width = currentFrame.width;
      const height = (screen.height / heightDenominator) * heightNumerator - EDGE_PADDING;

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
// first 2/5ths
['h'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index, 5, 2, 5, 0, 1, 1, 1),
  );
});

// mostly fifths
['j', 'k', 'l'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index + 2, 5, 1, 5, 0, 1, 1, 1),
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

// thirds
['y', 'i', 'p'].forEach((key, index) =>
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index, 3, 1, 3, 0, 1, 1, 1),
  ),
);

// two-thirds
Key.on('u', ['ctrl', 'cmd', 'alt'], resizeToFraction(0, 3, 2, 3, 0, 1, 1, 1));
Key.on('o', ['ctrl', 'cmd', 'alt'], resizeToFraction(1, 3, 2, 3, 0, 1, 1, 1));

// center - inner 1/2 width, full height
Key.on('m', ['ctrl', 'cmd', 'alt'], resizeToFraction(1, 4, 1, 2, 0, 1, 1, 1));


// fill
Key.on('return', ['cmd', 'alt'], resizeToFraction(0, 1, 1, 1, 0, 1, 1, 1));

// focus
Key.on("h", ["ctrl", "shift", "cmd"], focusClosestNeighbor("west"));
Key.on("l", ["ctrl", "shift", "cmd"], focusClosestNeighbor("east"));
Key.on("k", ["ctrl", "shift", "cmd"], focusClosestNeighbor("north"));
Key.on("j", ["ctrl", "shift", "cmd"], focusClosestNeighbor("south"));


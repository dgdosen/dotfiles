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

      const x = (screen.width / xDenominator) * xNumerator;
      const y = (screen.height / yDenominator) * yNumerator;
      const width = (screen.width / widthDenominator) * widthNumerator;
      const height = (screen.height / heightDenominator) * heightNumerator;

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
      const y = (screen.height / yDenominator) * yNumerator;
      const width = currentFrame.width;
      const height = (screen.height / heightDenominator) * heightNumerator;

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

// mostly fifths
['j', 'k', 'l'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index + 2, 5, 1, 5, 0, 1, 1, 1),
  );
});

['h'].forEach((key, index) => {
  Key.on(
    key,
    ['ctrl', 'cmd', 'alt'],
    resizeToFraction(index, 5, 2, 5, 0, 1, 1, 1),
  );
});

// // fourths
// ['h', 'j', 'k', 'l'].forEach((key, index) => {
//   Key.on(
//     key,
//     ['ctrl', 'cmd', 'alt'],
//     resizeToFraction(index, 4, 1, 4, 0, 1, 1, 1),
//   );
// });

// halves
['h', 'l'].forEach((key, index) =>
  Key.on(key, ['alt', 'cmd'], resizeToFraction(index, 2, 1, 2, 0, 1, 1, 1)),
);

// top/bottom
['k', 'j'].forEach((key, index) =>
  Key.on(key, ['alt', 'cmd'], resizeToFraction(0, 1, 1, 1, index, 2, 1, 2)),
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

// divide into half up/down
// Key.on('k', ['ctrl', 'cmd', 'alt'], resizeVerticallyInPlace(0, 2, 1, 2));
// Key.on('j', ['ctr', 'cmd', 'alt'], resizeVerticallyInPlace(1, 2, 1, 2));

// fill
Key.on('return', ['cmd', 'alt'], resizeToFraction(0, 1, 1, 1, 0, 1, 1, 1));

// focus
// Key.on("left", ["ctrl", "shift", "cmd"], focusClosestNeighbor("west"));
// Key.on("right", ["ctrl", "shift", "cmd"], focusClosestNeighbor("east"));
// Key.on("up", ["ctrl", "shift", "cmd"], focusClosestNeighbor("north"));
// Key.on("down", ["ctrl", "shift", "cmd"], focusClosestNeighbor("south"));

// Key.on('z', ['ctrl', 'shift'], () => {
//   const screen = Screen.main().flippedVisibleFrame();
//   const window = Window.focused();

//   if (window) {
//     window.setTopLeft({
//       x: screen.x + screen.width / 2 - window.frame().width / 2,
//       y: screen.y + screen.height / 2 - window.frame().height / 2,
//     });
//   }
// });

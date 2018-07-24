enum ScreenType {
  mobile,
  tablet,
  laptop,
  desktop,
  tv
}

/// Interface for choosing a layout based on screen size or other criteria.
abstract class LayoutProvider {
  ScreenType getScreenType(double height, double width);
}




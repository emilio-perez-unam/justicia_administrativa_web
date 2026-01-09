# Responsive Refactoring Plan for Justicia Administrativa Web

This document outlines a comprehensive plan to refactor the existing Flutter web application (`justicia_administrativa_web`) to be fully responsive across desktop and mobile devices.

## 1. Current State Analysis

Before initiating refactoring, a thorough analysis of the current UI components and screens is required to identify non-responsive elements. Key areas to focus on:

*   **`lib/shared/widgets/app_header.dart`**: Evaluate navigation, logo, and action buttons for responsiveness.
*   **`lib/shared/widgets/app_footer.dart`**: Assess layout of contact information, links, and social media icons.
*   **`lib/shared/widgets/responsive_layout.dart`**: Understand its current implementation and how it's being used. Determine if it can be enhanced or if new responsive widgets are needed.
*   **Screen-specific layouts**: Review all screens under `lib/features/` (e.g., `home_screen.dart`, `about_screen.dart`, `ai_solutions_screen.dart`, `blog_screen.dart`, `contact_screen.dart`, `legal_services_screen.dart`, `publications_screen.dart`, `team_screen.dart`, `profile_screen.dart`) for fixed widths, heights, or inflexible layouts.
*   **Image and Font Scaling**: Check how images are currently handled and if font sizes adapt to different screen sizes.
*   **Navigation**: Identify if the current navigation (likely in `app_header.dart`) is suitable for mobile or if a drawer/hamburger menu is required.

## 2. Responsive Design Principles

The refactoring will adhere to the following principles:

*   **Breakpoints**: Define clear breakpoints for different device categories (e.g., mobile, tablet, desktop).
*   **Fluid Grids**: Utilize `Row`, `Column`, `Flexible`, and `Expanded` widgets to create flexible layouts that adapt to available space.
*   **Relative Sizing**: Prefer relative units (e.g., percentages, `MediaQuery` values) over fixed pixel values where appropriate.
*   **Conditional UI**: Render different UI components or layouts based on screen size using `MediaQuery` or `LayoutBuilder`.
*   **Mobile-First Approach**: Design and implement for smaller screens first, then progressively enhance for larger screens.

## 3. Key Flutter Widgets and Techniques for Responsiveness

The following Flutter widgets and techniques will be extensively used:

*   **`MediaQuery.of(context).size`**: To get the current screen dimensions and orientation.
*   **`LayoutBuilder`**: To build different layouts based on the parent widget's constraints.
*   **`Flexible` and `Expanded`**: For distributing space within `Row` and `Column` widgets.
*   **`AspectRatio` and `FittedBox`**: For maintaining aspect ratios and scaling content.
*   **`Wrap`**: For flowing content to the next line when space is limited.
*   **`GridView`**: For responsive grid layouts.
*   **`CustomScrollView`, `SliverAppBar`, `SliverGrid`, `SliverList`**: For complex scrolling effects and optimized rendering of large lists/grids.
*   **`OrientationBuilder`**: To adapt UI based on device orientation.
*   **Existing `ResponsiveLayout` widget**: Leverage and potentially enhance `lib/shared/widgets/responsive_layout.dart` to centralize breakpoint logic and simplify responsive UI creation.

## 4. Refactoring Strategy

### 4.1. Define Breakpoints

Establish consistent breakpoints for the application. Example breakpoints:

*   **Mobile**: `maxWidth < 600`
*   **Tablet**: `600 <= maxWidth < 1200`
*   **Desktop**: `maxWidth >= 1200`

These can be defined as constants in `lib/core/constants/spacing.dart` or a new `breakpoints.dart` file.

### 4.2. Enhance `ResponsiveLayout` Widget

Review `lib/shared/widgets/responsive_layout.dart`. If it only provides basic mobile/desktop views, enhance it to support more granular breakpoints (e.g., tablet) and provide helper methods or builders for different screen sizes.

### 4.3. Component-Level Refactoring

Iterate through each UI component and screen, applying responsive design principles:

*   **`AppHeader` (`lib/shared/widgets/app_header.dart`)**:
    *   Implement a hamburger menu (`Drawer`) for mobile and tablet views.
    *   Adjust logo size and navigation item spacing based on screen width.
    *   Conditionally render search bars or other elements.
*   **`AppFooter` (`lib/shared/widgets/app_footer.dart`)**:
    *   Stack columns vertically on smaller screens.
    *   Adjust padding and font sizes.
*   **Screen Layouts (`lib/features/**/*.dart`)**:
    *   Replace fixed-width containers with `Flexible`, `Expanded`, `SizedBox.expand`, or `FractionallySizedBox`.
    *   Use `Padding` and `SizedBox` with dynamic values based on `MediaQuery`.
    *   For content that needs to reflow, use `Wrap` widgets.
    *   For multi-column layouts, use `Row` and `Column` in conjunction with `LayoutBuilder` to switch between horizontal and vertical arrangements.
    *   Implement `GridView.builder` or `ListView.builder` with adaptive item counts/sizes for lists of cards or images.
*   **Text and Typography**: Utilize `lib/core/constants/typography.dart` to define responsive text styles that scale with screen size or use `TextScaler`.
*   **Images**: Ensure images scale correctly using `BoxFit` and consider different image assets for different resolutions if necessary.

### 4.4. Navigation and Routing

*   Ensure `lib/core/routes/app_routes.dart` and the navigation logic correctly handle transitions between different screen sizes, especially when a drawer menu is introduced.

## 5. Testing and Verification

After each significant refactoring step, thoroughly test the application on:

*   **Web Browser (Desktop)**: Resize the browser window to simulate various desktop screen sizes.
*   **Web Browser (Mobile Emulation)**: Use browser developer tools to emulate different mobile devices and tablets.
*   **Actual Devices (if possible)**: Test on physical mobile and tablet devices to ensure real-world performance and appearance.
*   **Automated Tests**: If applicable, update or add widget tests to verify responsive behavior.
*   **Linting and Type Checking**: Run `flutter analyze` and `flutter format` regularly to maintain code quality and consistency.

## 6. Iterative Approach

This refactoring will be an iterative process. Start with the most critical or visible non-responsive areas (e.g., header, home screen) and progressively work through other components and screens. Regular commits and testing are crucial to ensure stability.

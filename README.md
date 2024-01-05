# PhotoGrammy
# References

- [Design in Figma](https://tinyurl.com/image-feed-figma)
- [Unsplash API](https://unsplash.com/documentation)

# Purpose and goals of the application

The multi-page application is designed to view images via the Unsplash API.

The goals of the application are:

- View an infinite feed of images from Unsplash Editorial.
- View summary information from a user's profile.

# Brief description of the application

- The app requires authorisation via Unsplash OAuth.
- The main screen consists of a ribbon of images. The user can browse it, add and remove images from favourites.
- Users can view each image separately and share the link to them outside the app.
- The user has a profile with favourite images and brief information about the user.
- The app has two versions: advanced and basic. The advanced version adds favourite mechanics and the ability to like photos when viewing the image full screen.

## Non-functional requirements

## Technical Requirements

1. Authorisation works via OAuth Unsplash and POST request to get Auth Token.
2. The ribbon is implemented using UITableView.
3. UImageView, UIButton, UILabel, TabBarController, NavigationController, NavigationBar, UITableView, UITableView, UITableViewCell are used in the application.
4. The app must support iPhone devices with iOS 13 or higher, only portrait mode is provided.
5. All fonts in the app are system fonts, you don't need to download them; in Interface Builder it is the "System" font in the drop-down list, and when drawing from code it is [`systemFont(ofSize:weight:)`](https://developer.apple.com/documentation/uikit/uifont/1619027-systemfont). In current iOS versions (13-16), the system font is the `SF Pro` font, but this may change in future versions.

# Functional requirements

# Authorisation via OAuth

To log in to the application, the user must authorise via OAuth.

**The authorisation screen contains:**

1. Application logo
2. Login button

**Algorithms and available actions:**

1. The user sees a splash-screen when entering the application;
2. When the application is loaded, a screen with the option to authorise is opened;
    1. When the user clicks on the login button, a browser opens on the Unsplash authorisation page;
        1. When you click on the "Login" button, the browser closes. The download screen appears in the application;
        2. If authorisation via OAuth Unsplash is not configured, nothing happens when the login button is clicked;
        3. If authorisation via OAuth Unsplash is not configured correctly, the user will not be able to log in to the application;
        4. If the login attempt fails, a modal window pops up with an error;
            1. Clicking on "OK" takes the user back to the authorisation screen;
        5. If the authorisation is successful, the browser closes. The ribbon screen opens in the application.

## Feed screen

In the Ribbon, the user can view images in the ribbon, navigate to view an individual image and add them to favourites.

**The feed screen contains:**

1. The card containing the image;
    1. A Like button;
    2. The date the photo was uploaded;
2. Tab bar to navigate between the feed and profile.

**Algorithms and available actions:**

1. The ribbon screen opens by default after logging into the application;
2. The ribbon contains images from Unsplash Editorial;
3. By scrolling down and up, the user can view the ribbon;
    1. If the image has not had time to load, a system loader is displayed to the user;
    2. If the image cannot be loaded - the user sees a placeholder instead of the image;
4. By clicking on the Like button (grey heart) the user can like the image. After clicking on the button, loader is displayed:
    1. If the request is successful, the lowader disappears, the icon changes its state to the Red Like button (red heart).
    2. If the request is not successful, a modal window pops up with the error "try again"
5. The user can remove the likes by clicking the Like button (red heart) again. Once clicked, the loader is displayed:
    1. If the request is successful, the lowader disappears, the icon changes state to a grey heart.
    2. If the request is not successful, a modal window pops up with a "try again" error;
6. If you click on the card with the image, it will enlarge to the borders of the phone and the user will go to the image viewing screen (section "View image full screen");
7. By tapping on the profile icon, the user can go to the profile;
8. The user can switch between the ribbon and profile screens using the tab bar.

## Full screen view

From the feed, the user can switch to full screen view and share the image.

**The screen contains:**

1. Enlarged image to the borders of the phone;
2. A button to return to the previous screen;
3. A button to download the image and with the ability to share it.

**Algorithms and available actions:**

1. When an image is opened full screen, the user sees the image stretched to the screen borders. The image is aligned in the centre;
    1. If the image cannot be loaded and displayed - the user sees a placeholder;
    2. If no response to the request is received - a system alert with an error appears;
2. If the Back button is pressed, the user can return to the ribbon view screen;
3. Using gestures, the user can move through the stretched image, zoom and rotate the image. The image is locked in the selected position;
    1. If gestures for zooming or rotating the image are not configured, these actions will not be available;
4. When the Share button is pressed, a system menu pops up where the user can upload or share the image;
    1. The menu is hidden after the action is performed;
    2. The user can close the menu by swiping down or pressing the cross;
    3. If the system menu is not configured to open when the user clicks on the "upload or share image" button, it will not be displayed;

## User profile screen

A user can go to their profile to view profile data or exit the profile.

**The profile screen contains:**

1. Profile data;
    1. User's photo;
    2. User name and username;
    3. information about yourself;
2. A button to log out of the profile;
3. Tab bar;

**Algorithms and available actions:**

1. Profile data is uploaded from the profile to Unsplash. Profile data cannot be changed in the application;
    1. If profile data is not pulled from Unsplash, the user sees a placeholder instead of an avatar. Username and name are not displayed;
2. When pressing the logout button, the user can log out of the application. A system alert pops up to confirm the logout;
    1. If the user clicks "Yes", the user is unlogged and the login screen opens;
        1. If the "Yes" button actions are not configured or are configured incorrectly, if the user presses it, the user is not unlogged and is taken to the authorisation screen;
    2. If the user clicks "No", the user is returned to the profile screen;
    3. If the alert is not configured, then when the user clicks on the exit button nothing happens, the user cannot unlogin;
3. The user can switch between the ribbon and profile screens using the tab bar.

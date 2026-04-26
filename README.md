
# tunefm

## Description
tunefm is a social app made for creating reviews for albums that a user has listened to, similar to Letterboxd. Users create profiles and make album reviews which will appear on their profile and in the main feed. They also have the ability to save drafts locally and upload them later.

## Dependencies:

The app was built on Xcode version `26.3` on build version `17C529`. The swift version used was `1.127.15 Apple Swift version 6.2.4 (swiftlang-6.2.4.1.4 clang-1700.6.4.2)`. The only package dependency is Firebase version `12.12.1`. 

The app was tested on the iPhone 17 Pro Max, as well as the iPhone SE Generation 3 (for camera features). Landscape mode was not tested and the app is meant to be used in portrait mode. 

One test account is provided with email: `tester@gmail.com` and password: `password`. Only one simulator is required and there should be test data already included in the app. 

# Checklist

## Required Features:
- [x] "Settings" screen. The two settings implemented are showing star vs numerical ratings for reviews in the feed, as well as enabling or disabling showing album release years.
- [x] Non-default fonts and colors used

### Two major elements used:
- [x] Login/register path with Firebase
- [ ] Core Data
- [x] User profile with camera and photo library
- [ ] Multithreading (sort of async/await used instead)
- [x] SwiftUI


## Minor Elements used:

- [x] Two additional view types such as sliders, segmented controllers, etc. The two implemented are: Switches, TextView, and Bars/Toolbars

### At least one of the following:
- [ ] Table View
- [ ] Collection View
- [x] Tab VC (Tab View used in main app) 
- [ ] Page VC

### At least one of the following:
- [x] Alerts (Used in delete button)
- [ ] Popovers
- [ ] Stack Views
- [x] Scroll Views (Used in feed + profile)
- [ ] Haptics
- [x] User Defualts (Used for settings)

### At least one of the following:
- [ ] Local notifications
- [ ] Core graphics
- [ ] Gesture Recognition
- [ ] Animation
- [ ] Calendar
- [ ] Core Motion
- [ ] Core Location / MapKit
- [ ] Core Audio
- [ ] Firebase
- [x] Core Data (For saving drafts)
- [ ] Other

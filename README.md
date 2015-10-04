# TFTransparentNavigationBar

[![CI Status](http://img.shields.io/travis/Ales Kocur/TFTransparentNavigationBar.svg?style=flat)](https://travis-ci.org/Ales Kocur/TFTransparentNavigationBar)
[![Version](https://img.shields.io/cocoapods/v/TFTransparentNavigationBar.svg?style=flat)](http://cocoapods.org/pods/TFTransparentNavigationBar)
[![License](https://img.shields.io/cocoapods/l/TFTransparentNavigationBar.svg?style=flat)](http://cocoapods.org/pods/TFTransparentNavigationBar)
[![Platform](https://img.shields.io/cocoapods/p/TFTransparentNavigationBar.svg?style=flat)](http://cocoapods.org/pods/TFTransparentNavigationBar)

![preview](https://github.com/thefuntasty/TFTransparentNavigationBar/blob/master/Example/TFTransparentNavigationBar/preview.gif)

## Usage

In order to make transparent navigation bar you need make your navigation controller be a class of TFNavigationController and its navigation bar class of TFNavigationBar. Then in your controllers implement TFTransparentNavigationBarProtocol which has only one method `navigationControllerBarPushStyle() -> TFNavigationBarStyle`. You have to return if your bar should be `.Solid` or `.Transparent`. The default style is .Solid therefore you can implement the protocol only for controllers you want to have a transparent bar. 

## Requirements

iOS 8 and later, Swift 2.0

## Known bugs

- ~~Navigation bar keeps title during pop transition~~ FIXED (but still problem with interactive transition)
- ~~First transition to controller with transparent navbar moves with fromView frame~~

## Installation

TFTransparentNavigationBar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TFTransparentNavigationBar"
```

## Author

Ales Kocur, ales@thefuntasty.com

## License

TFTransparentNavigationBar is available under the MIT license. See the LICENSE file for more info.

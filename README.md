

# CIKit ![][image-1] ![][image-2] ![][image-3] [![Carthage compatible][image-4]][1] ![][image-5] ![][image-6]

CIComponentKit 

Building...



## Installation

### CocoaPods

```
platform :ios, '8.0'
use_frameworks!
target '<Your Target Name>' do
    pod 'CIComponentKit'
end
```


### Carthage

```
github "CodeInventorGroup/CIComponentKit"
```

## Introduction examples

### CICHUD
`CICHUD`:

* `CICHUD.showNotifier`. ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_notifier.png)
* `CICHUD.showAlert` ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHU_alert.png)
* `CICHUD.showActivityView` ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_showActivityView.png)
* `CICHUD.showNetworkStatus` ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_showNetWorkStatus.png)
* `CICHUD.toast("long press to copy~", blurStyle: .extraLight)` ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_toast.png)
* `CICHUD.show("loading~", blurStyle: .extraLight)` ![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_loading.png)
* and you can show a guide page like this

```swift
let poem = """
            If by life you were deceived, 
            Don't be dismal, don't be wild! 
            In the day of grief, be mild 
            Merry days will come, believe. 
            Heart is living in tomorrow; 
            Present is dejected here; 
            In a moment, passes sorrow; 
            That which passes will be dear
          """
CICHUD.showGuide("If by life you were deceived", message: poem, animated: true)
```
![](https://github.com/CodeInventorGroup/CIComponentKit/blob/master/docs/CICHUD_showGuide.png)


[1]:	https://github.com/Carthage/Carthage

[image-1]:	https://travis-ci.org/CodeInventorGroup/CIComponentKit.svg?branch=master
[image-2]:	https://img.shields.io/badge/platform-ios-lightgrey.svg
[image-3]:	https://img.shields.io/cocoapods/v/CIComponentKit.svg?style=flat
[image-4]:	https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[image-5]:	https://img.shields.io/badge/language-swift4.0-orange.svg
[image-6]:	https://img.shields.io/cocoapods/l/CIComponentKit.svg?style=flat



![](http://olvgkynut.bkt.clouddn.com/CIComponentKit_introduce2.png?imageMogr2/thumbnail/1280x1280/interlace/1/blur/1x0/quality/100)

# CIComponentKit ![][image-1] ![][image-2] ![][image-3] [![Carthage compatible][image-4]][1] ![][image-5] ![][image-6]

 
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

* `CICHUD.showNotifier`. ![](http://olvgkynut.bkt.clouddn.com/CICHUD_notifier@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
* `CICHUD.showAlert` ![](http://olvgkynut.bkt.clouddn.com/CICHU_alert@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
* `CICHUD.showActivityView` ![](http://olvgkynut.bkt.clouddn.com/CICHUD_showActivityView@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
* `CICHUD.showNetworkStatus` ![](http://olvgkynut.bkt.clouddn.com/CICHUD_showNetWorkStatus@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
* `CICHUD.toast("long press to copy~", blurStyle: .extraLight)` ![](http://olvgkynut.bkt.clouddn.com/CICHUD_toast@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
* `CICHUD.show("loading~", blurStyle: .extraLight)` ![](http://olvgkynut.bkt.clouddn.com/CICHUD_loading@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)
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
![](http://olvgkynut.bkt.clouddn.com/CICHUD_showGuide@2x.png?imageMogr2/thumbnail/640x640/interlace/1/blur/1x0/quality/100)


[1]:	https://github.com/Carthage/Carthage

[image-1]:	https://travis-ci.org/CodeInventorGroup/CIComponentKit.svg?branch=master
[image-2]:	https://img.shields.io/badge/platform-ios-lightgrey.svg
[image-3]:	https://img.shields.io/cocoapods/v/CIComponentKit.svg?style=flat
[image-4]:	https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[image-5]:	https://img.shields.io/badge/language-swift4.0-orange.svg
[image-6]:	https://img.shields.io/cocoapods/l/CIComponentKit.svg?style=flat

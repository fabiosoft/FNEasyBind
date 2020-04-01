# FNEasyBind

[![CI Status](https://img.shields.io/travis/fabiosoft/FNEasyBind.svg?style=flat)](https://travis-ci.org/fabiosoft/FNEasyBind)
[![Version](https://img.shields.io/cocoapods/v/FNEasyBind.svg?style=flat)](https://cocoapods.org/pods/FNEasyBind)
[![License](https://img.shields.io/cocoapods/l/FNEasyBind.svg?style=flat)](https://cocoapods.org/pods/FNEasyBind)
[![Platform](https://img.shields.io/cocoapods/p/FNEasyBind.svg?style=flat)](https://cocoapods.org/pods/FNEasyBind)

FNEasyBind is a very basic and simple implementation of observables you can subscribe on. This library is intended to be used instead of importing entire [RxSwift](https://github.com/ReactiveX/RxSwift) library, but it doesn't replace it. Anyway i used the same terminology and class names to compare with Rx. And probably you cannot use both in the same project.
Usally I use with MVVM design pattern having an easy observable pattern to easy update the view. 

While building and experimenting with it i learnt so much. So take it as an education ready to go implementation of a tiny tiny reactive framework.

##### Todo

- [x] UIKit Bindings
- [x] PublishSubject
- [x] BehaviorSubject
- [x] Variable
- [ ] ReplaySubject
- [ ] Unit Testing
- [ ] Filters/Operator manipulation


##### Credits
The code was influenced by [fxm90/LightweightObservable](https://github.com/fxm90/LightweightObservable). I Added some helper methods and thread safety.

## Minimum Requirements

- iOS 10.0+
- Swift 5.1+

## Usage

Your ViewModel.swift

```swift
/// the value is immutable, so you can only subscribe to changes.
var formattedDateTime: Observable<String> {
    formattedDateTimeVariable.asObservable()
}

/// the value is mutable, so only this class can modify it.
private let formattedDateTimeVariable = Variable<String>(ClockViewModel.formattedDate())

private static func formattedDate() -> String {
. . .
}
```

ViewController.swift

```swift
clockViewModel
    .formattedDateTime
    .bind(on: timeLabel, to: \.text)
    .disposed(by: &disposeBag)
```

See example to entire implementation.

**Important:** To avoid retain cycles and/or crashes, always use [weak self] when self is needed by an observer.

## Installation

FNEasyBind is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FNEasyBind'
```

## Contribution

Contributions are welcome *♡*.

## Contact

Fabio Nisci • [fabionisci@gmail.com](mailto:fabionisci@gmail.com)


## License (MIT)

Copyright (c) 2020-present - Fabio Nisci

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

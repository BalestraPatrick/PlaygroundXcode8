# Playground in Xcode 8

During [session 213 of WWDC 2016](https://developer.apple.com/videos/play/wwdc2016/213/), some changes to Playground in Xcode 8 were mentioned. The talk shows more tips and tricks to make use of the powerful Xcode features such as Assets Catalogs to avoid writing more code than what is necessary. I highly reccomend you to watch it!

To manage the execution of a Playground, the `PlaygroundSupport` framework can now be used. By ⌘ + clicking the framework name, this is what you can find:

- A `UIViewController` and `UIView` extension that implement the `PlaygroundLiveViewable` protocol.
- The `PlaygroundLiveViewRepresentation` enum which describes if the current live view shows a `UIView` or a `UIViewController`.
- The `PlaygroundLiveViewable` protocol itself that has a variable to hold the current live view representation.
- The `PlaygroundPage` class that allows you to modify the playground execution.

A Playground is compiled like a script, line after line. This is great until you want to test a network request that is performed asynchronously. You will never see the callback result because the Playground is simply stopped before the response can arrive.
To fix this problem you have to tell Xcode that your page `needsIndefiniteExecution`. Let's take a look at a common `URLSession` usage.

```swift
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://emergency-phone-numbers.herokuapp.com")!
let session = URLSession.shared()
let q = session.dataTask(with: url) { data, response, error in
    do {
        if let d = data, let dictionary = try JSONSerialization.jsonObject(with: d, options: []) as? [String: AnyObject] {
            print(dictionary)
        }
    } catch {
        print("Error \(error)")
    }
}
q.resume()
```

We first import the new `PlaygroundSupport` framework at the top. We then set the `PlaygroundPage.current.needsIndefiniteExecution` property to true so that the playground will continue the execution of the Swift file even after reaching the last line. In this way, we are able to debug and see the response of our request.

You can also tell your Playground to stop waiting for something to happen. You could for example add this line in your completion handler to stop the execution of the page.

```swift
PlaygroundPage.current.finishExecution()
```

Another cool feature shown in the session which was added in Xcode 7.3, is the ability to interact with the live view. You can for example create a `UIViewController` and assign it to the Playground `liveView` as follows:

```swift
PlaygroundPage.current.liveView = viewController.view
```
This is useful to test a component before actually implement it into your project. To read more about this specific feature, watch the [WWDC session 213 video](https://developer.apple.com/videos/play/wwdc2016/213/) or read this blog post on the [Swift official blog](https://developer.apple.com/swift/blog/?id=35).

Thanks for reading 🤓
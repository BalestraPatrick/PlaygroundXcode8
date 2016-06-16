
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

//
//  ProtWitPipe.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 08/07/2024.
//

import Foundation
import OSLog

//@main
//struct Main {
//    static func main() throws {
//    }
//}

public protocol WitnessPiping { }

// piping implementation
extension WitnessPiping {

    public func callAsFunction<T, R>(_ keyPath: KeyPath<Self, ((T) -> R)>, args: T) -> R {
        self[keyPath: keyPath](args)
    }
}

// notocol with pipe
public struct ExampleDemonstrating: WitnessPiping {
    //var action: ((message: String) -> Void)?
    public var add: ((a: Int, b: Int)) -> Int
    // note we can't use labels in below form!
    public var addB: (Int, Int) -> Int
}


// httpxs://steipete.com/posts/interposekit/

class Spy<A: Hashable, B, C> {
    var invocations: [A: B] = .init()

    public func __interpose(f: @escaping (A, B) -> C) -> (A, B) -> C {
      { (a, b) -> C in
        //(f:  A, args: B) in
        self.invocations[a] = b
        return f(a, b)
        //Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
      }
    }
}

//public func do_it() {
//    // make a PW
//    //    let example = ExampleDemonstrating(add: { (a: Int, b: Int) in  a+b },
//    //    let example = ExampleDemonstrating(add: { ((a: Int, b: Int)) in  a+b },
//    let example = ExampleDemonstrating(add: { (_ pp: (a: Int, b: Int)) -> Int in
//        return pp.a + pp.b
//    },
//                                       addB: { a, b in  return a+b })
//
//    // this ok. even with the labels
//    let x: Any = (a: 1, b: 1)
//
//    let y: Any = testo // ((Int, String) -> String)
//
//    print("SJSJ Example: \(example)")
//    //    let spy = Spy<KeyPath<ExampleDemonstrating, (Any) -> Any>, Any, Any>()
//    let spy = Spy<KeyPath<ExampleDemonstrating, Any>, Any, Any>()
//
//    let tryThis: (KeyPath<ExampleDemonstrating, Any>, Any) -> Any = example.callAsFunction as! (KeyPath<ExampleDemonstrating, Any>, Any) -> Any
//
////    let ff = spy.__interpose(f: example.callAsFunction) //(\.add, args: (a: 3, b: 5))
//
//    //
//    //    ff(\.add, args: (a: 3, b: 5))
//
//
//    //    let ff = spy.__interpose() example.callAsFunction //(\.add, args: (a: 3, b: 5))
//    //    print("SJSJ ff = \(ff)")
//
//    print("SJSJ run exmaple simple way: ", example(\.add, args: (a: 3, b: 5)))
//}

func testo(_: (a: Int, b: String)) -> String {
    return "hey"
}

/// -------------------------------------------------------------------------------------



// TODO I was here

public protocol TopicRepresentable {
    associatedtype Topic

    var top: Topic { get }
//    func myTopic() -> Topic
//    func top() -> Topic
        //    var topic: String { get }
//    func topic() -> Topic
//    func topic<OtherType: TopicRepresentable>() -> OtherType

    init(top: Topic)
}

extension TopicRepresentable {

    func topic<OtherType: TopicRepresentable>() -> OtherType where OtherType.Topic == Self.Topic {
//        OtherType.init(topic: myTopic())
        OtherType.init(top: top)
    }
}

enum LoginTopic {
    case screenViewed
    case screenDismissed
    case userLoggedIn
}

//struct LoginAction: TopicRepresentable<Topic> {
struct LoginAction: TopicRepresentable {
    typealias Topic = LoginTopic

    var top: Topic

//    func myTopic() -> LoginTopic {
//        top
//    }
}

struct LoginEvent: TopicRepresentable {
    typealias Topic = LoginTopic

    var top: Topic

//    func myTopic() -> LoginTopic {
//        top
//    }

    public init(top: Topic) {
        self.top = top
    }

    // can we make a builder for this (static) and put into the extension?
    public init<T: TopicRepresentable>(topicHolder: T) where T.Topic == Self.Topic {
        top = topicHolder.top
    }
}



public func do_it() {

    // topics idea

    let loginAction = LoginAction.init(top: .screenViewed)

    // method one
    let loginEvent: LoginEvent = loginAction.topic()

    // method two
    let loginEvent2: LoginEvent = .init(topicHolder: loginAction)

//    let loginRepr: TopicRepresentable<LoginTopic> = loginAction
    //    let loginEvent: LoginEvent = loginRepr.topic()
    print(loginEvent)
    print(loginEvent2)

    switch loginEvent.top {
    case .screenViewed:
        break
    case .screenDismissed:
        break
    case .userLoggedIn:
        break
    }
    // need a way to make uncoupled things into each other using the topic.
    // e.g. action into a logger

//    let loginAction = LoginAction.screenViewed
//
//    let loginEvent: LoginEvent = loginAction.topic()
}

// OSLog demo (works)

//extension Logger {
//    /// Using your bundle identifier is a great way to ensure a unique identifier.
//    private static var subsystem = Bundle.main.bundleIdentifier!
//
//    /// Logs the view cycles like a view that appeared.
//    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
//
//    /// All logs related to tracking and analytics.
//    static let statistics = Logger(subsystem: subsystem, category: "statistics")
//}
//
//public func do_it() {
//    print("--------- Calling OSLog:")
//
//    //    OSLog.default.
//
//    Logger.viewCycle.info("View Appeared!")
//    Logger.viewCycle.warning("View Appeared WARNING!")
//    Logger.viewCycle.error("View Appeared ERROR!")
//    Logger.statistics.info("Some stats.")
//}


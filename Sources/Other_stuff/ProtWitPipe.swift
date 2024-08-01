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

/*
 Topics

 Problem:

 You have different enums or representations that represent a given aspect of a single enum or subject.

 For example, a given screen in an app can have actions (screenViewed or screenClosed), and then also events
 that details the same things. Rather than have a set of enums (Action, Event, etc) that have the same things in them, we want
 to define things like screenViewed or screenClosed just once, and then attach that to Actions, Events etc in such
 a way that the latter things are decoupled from each other.


 topic, facets, context? (facets are the cases for a topic, basicallym and context is like action or event.)
 */


public protocol TopicRepresentable {
    associatedtype Topic: Equatable

    var topic: Topic { get }
    init(topic: Topic)
}

extension TopicRepresentable {
    // init style
    public init<T: TopicRepresentable>(topicHolder: T) where T.Topic == Self.Topic {
        self.init(topic: topicHolder.topic)
    }

    // non-init style
    func topic<OtherType: TopicRepresentable>() -> OtherType where OtherType.Topic == Self.Topic {
        OtherType.init(topic: topic)
    }

//    func equals<OtherType: TopicRepresentable>(lhs: Self, rhs: OtherType) -> Bool where OtherType.Topic == Self.Topic, Self.Topic: Equatable {
//        lhs.topic == rhs.topic
//    }

    func equals<OtherType: TopicRepresentable>(_ other: OtherType) -> Bool where OtherType.Topic == Self.Topic {
        topic == other.topic
    }
}

// Idea not working currently. Was wanting to just add action and event calc props to any
// `enum XTopic` with a protocol declaration.
//protocol AsAction { }
//
//extension AsAction where Self: TopicRepresentable {
//    var action: LoginAction {
//        LoginAction(topic: self)
//    }
//}

//enum LoginTopic: Equatable, AsAction {
enum LoginTopic: Equatable {
    case screenViewed
    case screenDismissed
    case userLoggedIn
    case userLoggedOut
}

protocol Wooga {
    static var thingy: String { get }
}

//protocol WoogaProviding: Wooga { }
//
//extension WoogaProviding {
//    static var thingy: String { String(describing: self) }
//}

extension Wooga {
    static var thingy: String { String(describing: self) }
}

enum Context {
    enum Action: Wooga { }
    enum Event: Wooga { }

    //    enum Action: WoogaProviding { }
//    enum Event: WoogaProviding { }

    //    enum Action: Wooga {
//        static var thingy: String { "action" }
//    }


//    enum Event {
//        static var thingy: String { "event" }
//    }
//    case action
//    case event
}

typealias Action = Context.Action
typealias Event = Context.Event

//protocol Doober { }
//
//extension Doober {
//    func changer<Other: Doober>() {
//        Other
//    }
//}

//enum LoginTopic2<Aspect: Wooga>: Doober, Equatable {
enum LoginTopic2<Aspect: Wooga>: Equatable {
//    var t: Type { Aspect.Type }
    var aspect: String { Aspect.thingy }

    case screenViewed
    case screenDismissed
    case userLoggedIn
    case userLoggedOut
}

let t: LoginTopic2<Action> = .screenViewed

// TODO get it converting, same as original code below, to a different aspect with same Topic (e.g. screenViewed)
//let t2: LoginTopic2<Event> = t.changer


///----------------------------------------------------------

/// Thing2:

// can't do this, good
//let x: LoginTopic2<Event> = t

//protocol Actionable { }
//extension Actionable {
//    var action: any TopicRepresentable {
//        Self(topic: )
//    }
//}

extension LoginTopic {
    var action: LoginAction {
        LoginAction(topic: self)
    }

    var event: LoginEvent {
        LoginEvent(topic: self)
    }

//    func action() -> LoginAction {
//        LoginAction(topic: self)
//    }

//    func event() -> LoginEvent {
//        LoginEvent(topic: self)
//    }
}

// no way to make this an enum too?
// struct is still a value type tho, so not so bad.
struct LoginAction: TopicRepresentable {
    var topic: LoginTopic
}

//struct Action<T>: TopicRepresentable {
//    var topic: LoginTopic
//}

//enum LocationActionEnum {
//    // calc prop?
//    var topic: LoginTopic {
//        
//    }
//}

//struct LoginEvent: TopicRepresentable, Equatable {
struct LoginEvent: TopicRepresentable {
    var topic: LoginTopic
}

public func do_it() {
    let loginAction = LoginAction(topic: .screenViewed)

    // or: append helper like .action or .event on to the topic.
    // If I didn't have the clash, wouldn't even need the LoginAction/LoginTopic bit, I think!
    let loginActionMakeTwo: LoginAction = LoginTopic.screenViewed.action

    // method one: non-init.
    // The generic magic lets us call .topic on a topic holder and create any other
    // holder with same topic, implicitly.
    let loginEvent: LoginEvent = loginAction.topic()

    // method two: init
    let loginEvent2 = LoginEvent(topicHolder: loginAction)

    let loginAction2 = LoginAction(topicHolder: loginEvent2)

    print(loginEvent)
    print(loginEvent2)
    print(loginAction2)

    // checking equality
        // not quite got this working yet.
//    if loginEvent == loginAction { }
    // this works though. Must access the
    if loginEvent.topic == loginAction.topic {
        print("They are the same")
    }
    // also works
    if loginEvent.equals(loginAction) {
        print("They are the same, check 2")

    }

    // accessing a topic
    switch loginEvent.topic {
    case .screenViewed:
        break
    case .screenDismissed:
        break
    case .userLoggedIn:
        break
    case .userLoggedOut:
        break
    }

    print("t = ", t)
    print("t.aspect = ", t.aspect)
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


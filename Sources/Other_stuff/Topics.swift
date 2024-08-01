//
//  Topics.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 01/08/2024.
//

import Foundation

/*
 Topics

 Problem:

 You have different enums or representations that represent a given aspect of a single enum or subject.

 For example, a given screen in an app can have actions (screenViewed or screenClosed), and then also events
 that details the same things. Rather than have a set of enums (Action, Event, etc) that have the same things in them, we want
 to define things like screenViewed or screenClosed just once, and then attach that to Actions, Events etc in such
 a way that the latter things are decoupled from each other, but without losing type safety.


 topic, facets, context? (facets are the cases for a topic, basically and context is like action or event.)
 */


///  -------------- START the microlib itself:

// this primary associated type is for the commented out bit further down where I was trying a computed var (doesn't work)
//public protocol TopicRepresentable<Topic> {
public protocol TopicRepresentable {
    associatedtype Topic: Equatable

    var topic: Topic { get }
    init(topic: Topic)
}

// "decoupled and transferable type-safe aspects microlib"

//extension TopicRepresentable {
//    var topic: some TopicRepresentable {
//        some TopicRepresentable.init(topic: topic)
//    }
//}

extension TopicRepresentable {
    // init style
    // could rename topicHolder to aspect/subject here -- for that's what this is
    public init<T: TopicRepresentable>(aspect: T) where T.Topic == Self.Topic {
        self.init(topic: aspect.topic)
    }

    // non-init style
    func topic<OtherType: TopicRepresentable>() -> OtherType where OtherType.Topic == Self.Topic {
        OtherType.init(topic: topic)
    }
    // tried calc props, no worky. Could genericise the extension though!
//    var topic<OtherType: TopicRepresentable>: OtherType {
//        OtherType.init(topic: topic)
//    }

//    func equals<OtherType: TopicRepresentable>(lhs: Self, rhs: OtherType) -> Bool where OtherType.Topic == Self.Topic, Self.Topic: Equatable {
//        lhs.topic == rhs.topic
//    }

//     want to be able to just call .screenViewed.glove to make it fit whatever reciever type is!
    // -- not working, see commented out code later
//    func glove<OtherType: TopicRepresentable>() -> OtherType where OtherType.Topic == Self.Topic {
//        OtherType(topicHolder: self)
//    }

    func equals<OtherType: TopicRepresentable>(_ other: OtherType) -> Bool where OtherType.Topic == Self.Topic {
        topic == other.topic
    }
}

///  -------------- END the microlib itself


// EXAMPLE of a topic

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
//enum LoginTopic: Equatable, Glovable {
enum LoginTopic: Equatable {
    case screenViewed
    case screenDismissed
    case userLoggedIn
    case userLoggedOut
}

//protocol Glovable { }
//
//extension Glovable where Self: TopicRepresentable {
//extension Glovable where Self: Topic {
//    func glove<OtherType: TopicRepresentable>() -> OtherType {
//        OtherType(topic: self)
//    }
//}

// EXAMPLE of two aspects (or "subjects"): action and event.
//

// no way to make this an enum too?
// struct is still a value type tho, so not so bad.
struct LoginAction: TopicRepresentable {
    var topic: LoginTopic
}

//struct LoginEvent: TopicRepresentable, Equatable {
struct LoginEvent: TopicRepresentable {
    var topic: LoginTopic
}


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

// EXAMPLE of point style helpers
// (so microlib user can write e.g. `LoginTopic.screenViewed.action`)
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



public func do_it() {
    let loginAction = LoginAction(topic: .screenViewed)

    // or: append helper like .action or .event on to the topic.
    // If I didn't have the clash, wouldn't even need the LoginAction/LoginTopic bit, I think!
    let loginActionPointStyle: LoginAction = LoginTopic.screenViewed.action

    // aspect -> aspect transfer of a topic case:
    // method one: calling .topic() helper
    // The generic magic lets us call .topic on a topic holder and create any other
    // holder with same topic, implicitly.
    let loginEvent: LoginEvent = loginAction.topic()

    // method two: init
    let loginEvent2 = LoginEvent(aspect: loginAction)

    let loginAction2 = LoginAction(aspect: loginEvent2)

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

    // glove use
// hmm not really working
//    let glovey: LoginAction = .glove(.screenViewed)
//    let glovey: LoginAction = LoginTopic.screenViewed.glove()
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

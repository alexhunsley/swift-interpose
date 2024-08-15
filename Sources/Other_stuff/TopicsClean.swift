//
//  TopicsClean.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 04/08/2024.
//

import Foundation

// MARK: - TopicRepresentable

// Contexts conform to TopicRepresentable
public protocol TopicRepresentable {
    associatedtype Topic: Equatable

    var topic: Topic { get }
    init(topic: Topic)
}

// TopicRepresentable: init, mirror, equals, helpers
extension TopicRepresentable {
    // init style
    public init<T: TopicRepresentable>(mirroring context: T) where T.Topic == Self.Topic {
        self.init(topic: context.topic)
    }

    // init that takes direct topic
    public init(topic: Topic) {
        self.init(topic: topic)
    }

    // non-init style
    func mirror<OtherType: TopicRepresentable>() -> OtherType where OtherType.Topic == Self.Topic {
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

    // how about rename to `isMirror(of:`?
    func hasSameTopicValue<OtherType: TopicRepresentable>(as other: OtherType) -> Bool where OtherType.Topic == Self.Topic  {
        topic == other.topic
    }

    // differing topics means cit an never be the same case
    func hasSameTopicValue<OtherType: TopicRepresentable>(as other: OtherType) -> Bool {
        false
    }

    func hasSameTopic<OtherType: TopicRepresentable>(as other: OtherType) -> Bool where OtherType.Topic == Self.Topic {
        true
    }

    // this works, but should it be provided? Would dev really not know they were different topics?
    func hasSameTopic<OtherType: TopicRepresentable>(as other: OtherType) -> Bool {
        false
    }
}


// MARK: - Topic

protocol Topic {}

// The catch-all builder than lets you build any TopicRepresentable (aspect value)
// on-demand
extension Topic {
    func build<T: TopicRepresentable>(builderClosure: ((T) -> T)? = nil) -> T where T.Topic == Self {
        var t = T(topic: self)
        if let builderClosure {
            t = builderClosure(t)
        }
        return t
    }
}

// MARK: - Examples of Topics

// a topic for our login screen
enum LoginTopic: Topic, Equatable {
    case screenViewed
    case screenDismissed
    case userLoggedIn
    case userLoggedOut
}

// The Action context for LoginTopic
struct LoginAction: TopicRepresentable {
    let topic: LoginTopic
}

// The Event context for LoginTopic
struct LoginEvent: TopicRepresentable {
    let topic: LoginTopic
}

//extension Topic {
//    func buildAction<T: TopicRepresentable>() -> T where T.Topic == Self, T: ActionBuildable {
//        T(topic: self)
//    }
//}

// MARK: - Test code

public func do_it() {
    let loginAction = LoginAction(topic: .screenViewed)

    // or: append helper like .action or .event on to the topic.
    // If I didn't have the clash, wouldn't even need the LoginAction/LoginTopic bit, I think!
    //    let _: LoginAction = LoginTopic.screenViewed.buildAction()


    //    let loginActionFromBuild: LoginAction = LoginTopic.screenViewed.build()

    // Generic creation of topic values using `.build()` (works for any context)
    // You can't omit the `LoginTopic.` here!
    let loginActionViaBuild: LoginAction = LoginTopic.screenViewed.build()
    print("loginActionFromBuild: \(loginActionViaBuild)")

    let loginEventViaBuild: LoginEvent = LoginTopic.screenViewed.build()
    print("loginEventFromBuild: \(loginEventViaBuild)")

    // We can use mirror to easily convert a topic value from one context (action) to another (event).
    // This replaces our laborious conversion switch! And also means there is no coupling between Event and Action.
    let _: LoginEvent = loginAction.mirror()

    //    let loginActionFromBuild_B: LoginAction = LoginTopic.screenViewed.buildAction()
    //    print("loginActionFromBuild_B: \(loginActionFromBuild_B)")

/// -------------------------------------------------
    ///
    /// re-use example:

    Holder.do_it_holder()
    // Ah. How to build something with an associated type?
    // maybe in this case you can only do the 'boring' way?


//    let loginScreenEventViaBuild: LoginEvent = LoginTopic.screenViewed.build()

}

/// ------------------------
///  State re-use example
///

enum Holder {
    /// A helper enum for re-use. Note that it's not a Topic, just a plain enum
    enum ScreenLifecycle: Equatable {
        case screenViewed
        case screenDismissed
    }

    enum LoginScreenTopic: Topic, Equatable {
        case lifecycle(ScreenLifecycle)
        case usernameFieldUpdated(username: String)
        case logInTapped
    }

    enum SettingsScreenTopic: Topic, Equatable {
        case lifecycle(ScreenLifecycle)
        case settingChanged(String, Int)
    }

    ///

    struct LoginScreenAction: TopicRepresentable {
        let topic: LoginScreenTopic
    }

    // The Event context for LoginTopic
    struct LoginScreenEvent: TopicRepresentable {
        let topic: LoginScreenTopic
    }

    static func do_it_holder() {
        let loginScreenActionViaBuild: LoginScreenAction = LoginScreenTopic.lifecycle(.screenViewed).build()
        let loginScreenActionViaBuild2: LoginScreenAction = LoginScreenTopic.logInTapped.build()

    //    let loginScreenActionViaBuild: LoginScreenAction = LoginScreenTopic.lifecycle.build()
        print("qw loginScreenActionViaBuild: \(loginScreenActionViaBuild)")
        print("qw loginScreenActionViaBuild2: \(loginScreenActionViaBuild2)")

        let lginScreenEventViaMirror: LoginScreenEvent = loginScreenActionViaBuild.mirror()
        let lginScreenEventViaMirror2: LoginScreenEvent = loginScreenActionViaBuild2.mirror()
        print("qw lginScreenEventViaMirror: \(lginScreenEventViaMirror)")
        print("qw lginScreenEventViaMirror2: \(lginScreenEventViaMirror2)")
    }
}

// let loginScreenActionViaBuild: LoginScreenAction = LoginScreenTopic.lifecycle(.screenViewed).build()
// let lginScreenEventViaMirror: LoginScreenEvent = loginScreenActionViaBuild.mirror()

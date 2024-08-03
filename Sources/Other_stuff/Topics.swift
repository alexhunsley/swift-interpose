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
    public init<T: TopicRepresentable>(mirroring aspect: T) where T.Topic == Self.Topic {
        self.init(topic: aspect.topic)
    }

    // try this
//    public init<T: Topic>(topeek: T) where T == Self {
//        self.init(topic: topeek)
//    }


    // init that takes direct topic
//    public init<T: Topic>(topic: T) {
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

protocol Topic: Goom { }
//protocol LoginTopic: Topic { }

//extension LoginTopic: Equatable {
enum LoginTopic: Topic, Equatable {
    case screenViewed
    case screenDismissed
    case userLoggedIn
    case userLoggedOut
}

protocol Goom {}

// not sure if this includes topic itself! lols.
extension Topic {
    func build<T: TopicRepresentable>() -> T where T.Topic == Self {
        T(topic: self)
    }
}

//extension Topic<TopicRepresentable> {
//extension TopicRepresentable<Topic> {
//    var build2: some TopicRepresentable {
//        Self(topic: topic)
////        let thang: some TopicRepresentable = topic.build()
////        return thang
//    }
//}

//extension Goom where Self: Topic {
//    func build<T: TopicRepresentable>() -> T {
//        T(topic: self)
//    }
//}

enum SettingsTopic: Topic, Equatable {
    case screenViewed
    case screenDismissed
    case settingChanged(String, Int)
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

//struct LoginHolder: TopicRepresentable {
//    let topic: LoginTopic
//}

// no way to make this an enum too?
// struct is still a value type tho, so not so bad.
struct LoginAction: TopicRepresentable {
    let topic: LoginTopic
}

//struct LoginEvent: TopicRepresentable, Equatable {
struct LoginEvent: TopicRepresentable {
    let topic: LoginTopic
}

struct SettingsEvent: TopicRepresentable {
    let topic: LoginTopic
}

struct GooberAction: TopicRepresentable {
    let topic: LoginTopic
}

///----------------------------------------------------------

/// Thing2:

// can't do this, good
//let x: LoginTopic2<Event> = t

protocol LoginActionable { }

// computed property version
//extension LoginActionable where Self: TopicRepresentable, Self.Topic == LoginTopic {

//extension LoginActionable where Self: Topic  { // where Self.Topic == LoginTopic { //} where Self: Topic { //},
//    //    typealias Topic = LoginTopic
//
//    // computed property form.
//    //
//    var action: LoginAction {
//        // so self is a topic, but below line requires LoginTopic.
//        // Can't do `Self: LoginTopic` on extension def!
//        LoginAction(topic: self)
////        LoginAction(aspect: topicRepr)
//    }
//}

// function form. computed property is nicer!
// (called action2 just so no clash and can demo both compiling)
extension LoginActionable where Self: Topic { //}: Topic { //LoginTopicwhere Self: Topic, Topic == LoginTopic {
//    func action2<ThingAction>() -> ThingAction where ThingAction: TopicRepresentable, Self == ThingAction.Topic { // where Topic == LoginTopic {
    func buildAspect<ThingAction>() -> ThingAction where ThingAction: TopicRepresentable, Self == ThingAction.Topic { // where Topic == LoginTopic {
//        ThingAction(topic: self.topic)
        ThingAction(topic: self)
//        ThingAction(aspect: self)
    }

    // this works -- adds this method to anything adopting LoginActionable.
    // but the general case?
    func buildAction() -> LoginAction where Self == LoginAction.Topic { // where Topic == LoginTopic {
//        ThingAction(topic: self.topic)
        LoginAction(topic: self)
//        ThingAction(aspect: self)
    }
}

//08-03 cjkj ommented out:
//protocol LoginEventable {}
//
//extension LoginEventable where Self: Topic { //}: Topic { //LoginTopicwhere Self: Topic, Topic == LoginTopic {
//    func buildEvent() -> LoginEvent where Self == LoginEvent.Topic { // where Topic == LoginTopic {
////        ThingAction(topic: self.topic)
//        LoginEvent(topic: self)
////        ThingAction(aspect: self)
//    }
//}

//protocol GenericActionable {}
//
//extension GenericActionable where Self: Topic { //}: Topic { //LoginTopicwhere Self: Topic, Topic == LoginTopic {
//    // get a clash with this idea!
//    // e.g. "Instance method 'buildAspect()' requires the types 'SettingsTopic' and 'LoginTopic' be equivalent"
//    func buildAspect<ThingAction>() -> ThingAction where ThingAction: TopicRepresentable, Self == ThingAction.Topic { // where Topic == LoginTopic {
//        //        ThingAction(topic: self.topic)
//        ThingAction(topic: self)
//        //        ThingAction(aspect: self)
//    }
//}

//extension LoginActionable where Self: TopicRepresentable, Self.Topic == LoginTopic {
//    func action2() -> LoginAction where Topic == LoginTopic {
//        LoginAction(topic: self.topic)
//    }
//}

// and now can just declare stuff as LoginActionable and get rid of the helper method!

// EXAMPLE of point style helpers
// (so microlib user can write e.g. `LoginTopic.screenViewed.action`)
//extension LoginTopic: LoginActionable {
extension LoginTopic: LoginActionable {
//extension LoginTopic: GenericActionable {
//    var action: LoginAction {
//        LoginAction(topic: self)
//    }

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

extension SettingsTopic: LoginActionable {}

enum GameTopic {
    case screenViewed
}

struct GameAction: TopicRepresentable {
    // TODO this var should be topicValue!
    let topic: GameTopic
}


public func do_it() {
    let loginAction = LoginAction(topic: .screenViewed)

    // or: append helper like .action or .event on to the topic.
    // If I didn't have the clash, wouldn't even need the LoginAction/LoginTopic bit, I think!
    let _: LoginAction = LoginTopic.screenViewed.buildAction()

    // we also want to build anything (action, event) for a given topic without
    // having to add stuff to it either manually or with POP mixin conformance?
    // try:

    // so this works:
    let _: LoginAction = LoginTopic.screenViewed.event.mirror()
    // but we want to not use the event!
    // so like this: (but we have no build() method yet)
    let loginActionFromBuild: LoginAction = LoginTopic.screenViewed.build()
    print("loginActionFromBuild: \(loginActionFromBuild)")
    let loginEventFromBuild: LoginAction = LoginTopic.screenViewed.build()
    print("loginEventFromBuild: \(loginEventFromBuild)")

    // Not sure we even want this? It's building a thing after all, better
    // to be explicit with a func `()` I think
//    let loginEventFromBuildVar: LoginAction = LoginTopic.screenViewed.build
//    print("loginEventFromBuild: \(loginEventFromBuild)")

    // this also works and will build any thing given the right type context for the generic
//    let loginActionPointStyle2: LoginAction = LoginTopic.screenViewed.buildAspect()
//    let loginActionPointStyle2: LoginAction = LoginTopic.screenViewed.buildAction()
//    let loginEventPointStyle2: LoginEvent = LoginTopic.screenViewed.buildAspect()
//    let loginEventPointStyle2: LoginEvent = LoginTopic.screenViewed.buildAction()

    // this one:
//    let settingsEventPointStyle2: SettingsEvent = SettingsTopic.screenViewed.buildEvent()


//    let settingsEventPointStyle2: SettingsEvent = SettingsTopic.screenViewed.buildAspect()


    // aspect -> aspect transfer of a topic case:
    // method one: calling .topic() helper
    // The generic magic lets us call .topic on a topic holder and create any other
    // holder with same topic, implicitly.
    let loginEvent: LoginEvent = loginAction.mirror()

    // method two: init
    let loginEvent2 = LoginEvent(mirroring: loginAction)

    let loginAction2 = LoginAction(mirroring: loginEvent2)

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
    // also works. is this ok? Or vague and weird?
//     --  yeah is weird. Misuse of equals. Maybe equalsTopic? hmm.
    // - no, I like hasSameTopic(as:) below, is clearer.
//    if loginEvent.equals(loginAction) {
//        print("They are the same, check 2")
//    }

    let gameAction = GameAction(topic: .screenViewed)

    // this is actually checking for same topic CASE.
    // we also want sameTopic?
    if loginEvent.hasSameTopicValue(as: loginAction) {
        print("login and login: They are the same topic case, check 1")
    }
    if loginEvent.hasSameTopicValue(as: gameAction) {
        print("login and login: They are the same topic case, check 2")
    }
    if loginEvent.hasSameTopic(as: gameAction) {
        print("login and game: They are the same topic (not case), check 3")
    }
    if loginEvent.hasSameTopic(as: loginAction) {
        print("login and login: They are the same topic (not case), check 4")
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

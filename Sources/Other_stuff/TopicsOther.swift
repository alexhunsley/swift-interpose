//
//  TopicsOther.swift
//  SwiftInterpose
//
//  Created by Alex Hunsley on 01/08/2024.
//

import Foundation

// earlier stuff, kind of gave up on?

//protocol Wooga {
//    static var thingy: String { get }
//}

//protocol WoogaProviding: Wooga { }
//
//extension WoogaProviding {
//    static var thingy: String { String(describing: self) }
//}


//extension Wooga {
//    static var thingy: String { String(describing: self) }
//}
//
//enum Context {
//    enum Action: Wooga { }
//    enum Event: Wooga { }
//
//    //    enum Action: WoogaProviding { }
////    enum Event: WoogaProviding { }
//
//    //    enum Action: Wooga {
////        static var thingy: String { "action" }
////    }
//
//
////    enum Event {
////        static var thingy: String { "event" }
////    }
////    case action
////    case event
//}
//
//
//
//typealias Action = Context.Action
//typealias Event = Context.Event

//protocol Doober { }
//
//extension Doober {
//    func changer<Other: Doober>() {
//        Other
//    }
//}
//
////enum LoginTopic2<Aspect: Wooga>: Doober, Equatable {
//enum LoginTopicB<Aspect: Wooga>: Equatable {
////    var t: Type { Aspect.Type }
//    var aspect: String { Aspect.thingy }
//
//    case screenViewed
//    case screenDismissed
//    case userLoggedIn
//    case userLoggedOut
//}
//
//let t: LoginTopicB<Action> = .screenViewed
//
//print("t = ", t)
//print("t.aspect = ", t.aspect)

// TODO get it converting, same as original code below, to a different aspect with same Topic (e.g. screenViewed)
//let t2: LoginTopic2<Event> = t.changer



import Foundation

// Ideas:
//
// * use the PF concurrency tool to avoid actual sleeps? (in the tests)
//
// * can we find a way to declare an __interpose as a spy/dummy etc that
//     can be later interogated for what it was passed?
//     Maybe a param to __interpose can give us a way to fetch the 'poser' later.
//     In fact, maybe the given tag could do this! What if multiple uses of the
//     same tag were made?
//  - oh, maybe we can attach the actual verificaton check as a closure at some point,
//    to the interpose itself? Then we don't lose the type info, or have to deal with
//    Any etc...
public class Interpose {

    public struct IRecord<P1, R1> {
        public let p1: P1
        public let r1: R1
    }

    public static var `default`: Interpose = Interpose()

    public private(set) var records: [String: Any] = .init()

    public func addRecording<P1, R1>(tag: String, rec: IRecord<P1, R1>) {
        // or could make the Record in here...
        records[tag] = rec
    }
}

// add equatable where possible
extension Interpose.IRecord: Equatable where P1: Equatable, R1: Equatable { }

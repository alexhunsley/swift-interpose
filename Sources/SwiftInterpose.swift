import Foundation

public protocol DefaultValueProviding {
    static var defaultValue: Self { get }
}

extension Int: DefaultValueProviding {
    public static var defaultValue = 0
}

public struct Interpose { }

public func __iPrint(tag: String? = nil) -> () -> Void {
    {
        Interpose.log([tag ?? ""])
    }
}

public func __iPrint(tag: String? = nil,
                     f: @escaping () -> Void) -> () -> Void {
    {
        f()
        Interpose.log([tag ?? ""])
    }
}

/// ----------------------
///
///
public func __iPrint<P1>(tag: String? = nil) -> (P1) -> Void {
    { (p1: P1) in
        Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
    }
}

public func __iPrint<P1>(tag: String? = nil,
                         f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        Interpose.log(["P1 = \(p1)"])
    }
}

//public func __iWrap<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
public func __iPrint<P1, R1>(tag: String? = nil,
                             f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns = \(ret)"])
        return ret
    }
}

// -------------------------------



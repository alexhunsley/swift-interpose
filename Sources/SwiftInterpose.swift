// hello

//@main
//struct Main {
//    static func main() {
//        print("Hello")
//    }
//}

public protocol DefaultValueProviding {
    static var defaultValue: Self { get }
}

extension Int: DefaultValueProviding {
    public static var defaultValue = 0
}

public let __iPrintLogger = { str in print(str) }


public func __iPrint(tag: String? = nil,
                    logger: @escaping (String) -> Void = __iPrintLogger) -> () -> Void {
    {
        logger("\(tag ?? "") ")
    }
}

public func __iPrint(tag: String? = nil,
                     logger: @escaping (String) -> Void = __iPrintLogger,
                     f: @escaping () -> Void) -> () -> Void {
    {
        f()
        logger("\(tag ?? "") ")
    }
}

/// ----------------------
///
///
public func __iPrint<P1>(tag: String? = nil,
                         logger: @escaping (String) -> Void = __iPrintLogger) -> (P1) -> Void {
    { (p1: P1) in
        logger("\(tag ?? "") P1 = \(p1)")
    }
}

public func __iPrint<P1>(tag: String? = nil,
                         logger: @escaping (String) -> Void = __iPrintLogger,
                         f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        logger("\(tag ?? "") P1 = \(p1)")
    }
}

////public func __iWrap<P1>(tag: String? = nil, f: @escaping (P1) -> Void) -> (P1) -> Void {
//public func __iPrint<P1>(tag: String? = nil, f: @escaping (P1) -> Void) -> (P1) -> Void {
//    { (p1: P1) in
//        f(p1)
//        print("P1 = \(p1)")
//    }
//}

//public func __iWrap<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
public func __iPrint<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        print("P1 = \(p1), Returns = \(ret)")
        return ret
    }
}

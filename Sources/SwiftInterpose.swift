import Foundation

public struct Interpose { }

// Spy (0 in 0 out)
public func __iPrint(tag: String? = nil,
                     f: @escaping () -> Void) -> () -> Void {
    {
        f()
        Interpose.log([tag ?? ""])
    }
}

// Spy (1 in 0 out)
public func __iPrint<P1>(tag: String? = nil,
                         f: @escaping (P1) -> Void) -> (P1) -> Void {
    { (p1: P1) in
        f(p1)
        Interpose.log(["P1 = \(p1)"])
    }
}

//public func __iWrap<P1, R1>(tag: String? = nil, f: @escaping (P1) -> R1) -> (P1) -> R1 {

// Spy (1 in 1 out)
public func __iPrint<P1, R1>(tag: String? = nil,
                             f: @escaping (P1) -> R1) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = f(p1)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns = \(ret)"])
        return ret
    }
}

// Dummy (0 in 0 out)
public func __iPrint(tag: String? = nil) -> () -> Void {
    {
        Interpose.log([tag ?? ""])
    }
}

// Dummy (1 in 0 out)
public func __iPrint<P1>(tag: String? = nil) -> (P1) -> Void {
    { (p1: P1) in
        Interpose.log(["\(tag ?? "")", "P1 = \(p1)"])
    }
}


// Dummy (1 in 1 out) -- returns some default values
public func __iPrint<P1, R1: DefaultValueProviding>(tag: String? = nil) -> (P1) -> R1 {
    { (p1: P1) in
        let ret = R1.defaultValue
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns default values = \(ret)"])
        return ret
    }
}

// Dummy (1 in 2 out) -- returns some default values
public func __iPrint<P1, R1: DefaultValueProviding, R2: DefaultValueProviding>(tag: String? = nil) -> (P1) -> (R1, R2) {
    { (p1: P1) in
        let ret = (R1.defaultValue, R2.defaultValue)
        Interpose.log([tag ?? "", "\(Interpose.dateProvider())", "P1 = \(p1), Returns default values = \(ret)"])
        return ret
    }
}

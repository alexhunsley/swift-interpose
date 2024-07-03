# Swift Interpose

Experimenting with generics and closures.

Interpose aims to let you simply and quickly:

* create drop-in closure spies and dummies to log activity
* assert on closures being called (or not)
* `insert attractive things here` (dedupe/throttle? memoize?)

By design, Combine and macros etc are not used here.

Interpose should work fine with async and throwing closures.

# Examples

## Dummies

Suppose you are required by API to pass a closure somewhere but you don't really care about what happens in it.
You often end up writing a dangler like this:

```
   doSomething(actionHandler: { _ in })

   // or trailing closure style:
   doSomething { _ in }
```

This is often seen in SwiftUI previews.

Or perhaps you're just logging what is passed in:

```
   doSomething(actionHandler: { action in
       print("\(action)")
   }

   // or trailing closure style:
   doSomething { _ in
       print("\(action)")
   }
```

With Interpose you can just drop in `__interpose` and a dummy will be created automatically, which will print out the action when sent:

```
   doSomething(actionHandler: __interpose)
```

## Spies

Suppose you have a closure which is doing something meaningful:

```
   doSomething(actionHander: { action -> Int in
       // do useful things
       //   ...
       return 7
   })

```

You can use interpose to spy on its invocation:

```
   doSomething(actionHander: __interpose { action in
       // do useful things
       //   ...
       return 7
   })

```

This will log (print out) both incoming parameters and the return value.

## Dummies that have return values

Suppose you have a dangling closure that has a non-void return type:

```
   doSomething(actionHandler: { _ -> String in
       return "meh"
   })
```

If we try and use `__interpose` here, the compiler will complain:

```
   doSomething(actionHandler: __interpose)
```

This is because the closure has something to return (a String), but Interpose doesn't know how to make that data.

There's an easy fix though. If we conform `String` to `DefaultValueProviding`, and provide a value, `__interpose` will now work:

```
extension String: DefaultValueProviding {
    public static var defaultValue = ""
}
```



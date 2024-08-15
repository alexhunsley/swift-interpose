# Swift Interpose

Experimenting with generics and closures.

Interpose aims to let you simply and quickly:

* create drop-in closure spies and dummies to log activity
* assert on closures being called (or not called)
* (maybe more in future)

By design, Combine and macros etc are not used here.

Interpose should work fine with async and throwing (and async throwing) closures.

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

With Interpose you can just drop in `__iPrint` and a dummy will be created automatically, which will print out the action when sent:

```
   doSomething(actionHandler: __iPrint)
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
   doSomething(actionHander: __iPrint { action in
       // do useful things
       //   ...
       return 7
   })

```

This will print out both incoming parameters and the return value.

## Dummies that have return values

Suppose you have a dangling closure that has a non-void return type:

```
   doSomething(actionHandler: { _ -> String in
       return "meh"
   })
```

If we try and use `__iPrint` here, the compiler will complain:

```
   doSomething(actionHandler: __iPrint)
```

This is because the closure has something to return (a String), but Interpose doesn't know how to make that data.

There's an easy fix though. If we conform `String` to `DefaultValueProviding`, and provide a value, `__iPrint` will now work:

```
extension String: DefaultValueProviding {
    public static var defaultValue = ""
}
```

You can conform any types you like to `DefaultValueProviding` and then spy on closures that return them.

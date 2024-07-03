# Swift Interpose

Experimenting with generics and closures.

Interpose aims to let you simply and quickly:

* create drop-in closure spies and dummies to log activity
* assert on closures being called (or not)
* `insert attractive things here` (dedupe/throttle? memoize?)

By design, Combine and macros etc are not used here.

Interpose should work fine with async and throwing closures.

# Examples

(preview debug logger example here)

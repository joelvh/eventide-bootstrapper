# Frivolously Asked Questions

## `Configure` library

@ntl I have a question to get my head around `configure` and how that all works - looking through the various gems, I get confused about the use of instance and class methods - some things get included, some extended, and so forth. My general observation is most things are class methods, so I assume instances aren’t created much (at least explicitly). But, can you clarify the method signature for `configure`?


[8:35]
`Handlers::Commands` in the `AccountComponent` example project has this:


[8:35]
 ```    def configure
      Messaging::Postgres::Write.configure(self)
      Clock::UTC.configure(self)
      Store.configure(self)
    end
```
(edited)


[8:36]
and `messaging-postgres` has this:


[8:36]
 ```module Messaging
  module Postgres
    class Write
      include Messaging::Write

      def configure(session: nil)
        MessageStore::Postgres::Write.configure(self, attr_name: :message_writer, session: session)
      end
    end
  end
end
```
(edited)


[8:37]
when calling `configure`, it’s passing in the…. module? in order to configure how to use `Postgres::Write`


[8:37]
but the signature seems to want a `session`?


new messages
ntl [8:42 PM]
When you see an instance method called `#configure`, it's a method designed to cause the instance to be wired up to _operational_ dependencies. It's _usually_ invoked by a factory method on the class, `.build`. Often those `.build` methods allow parametric configuration. For instance, I could pass in a `session` when I'm constructing an operational instance of a postgres writer via `Messaging::Postgres::Build`.


[8:42]
There really won't be any relationship between the `#configure` instance method on one class and on another.


[8:44]
We use class methods liberally, but they aren't meant to take duties away from the instance methods, or to prevent the need for instantiating the class -- instead, they generally offer convenience interfaces. You'll see `.build` on most classes, and `.call` on command classes that have a `#call` instance method. Very often there will be a `.configure` class method too. All of that is designed to make the classes more usable.

### More `Configure`

Ok, I remember the `Configure` library


[9:09]
A class named `Write` can set an instance of itself onto a receiver


[9:09]
 ```Write.configure(some_obj)
```


[9:09]
This implies that `some_obj` has an attribute named `write`


[9:10]
That class `configure` method on `Write` will construct an instance of the `Write` class, and then set that instance on the receiver.


ntl [9:10 PM]
Yep.


sbellware [9:10 PM]
The receiver is `some_obj` (edited)


[9:12]
So, `Write` could use `Configure` like so:
```class Write
  configure :write
  # ... (rest of class)
end
```


ntl [9:12 PM]
Our goal is not to remove all the boilerplate we can, but we don't want boilerplate to get out of hand, if we can help it.


[9:13]
The two libraries `initializer` and `configure` greatly cut down on the amount of boilerplate, without causing us to introduce unruly abstractions.


sbellware [9:13 PM]
which is a shortcut for:
```class Write
  def self.configure(receiver)
    instance = build
    receiver.write = instance
  end
end
```
(edited)


ntl [9:14 PM]
Honestly, `configure` may deserve it's own guide


sbellware [9:14 PM]
But, the moment that there’s a special case needed in the building (constructing) of an instance, this generalization may or may not be workable. So, it’s a thing that can be used is many cases


[9:15]
I think `Configure` needs a retirement party :slightly_smiling_face: I always have to reverse-engineer it every time I come across it.


ntl [9:15 PM]
Actually, a better representation of what it's a shortcut for is this:

```class Write
  def self.configure(receiver, *arguments)
    instance = build(*arguments)
    receiver.write = instance
  end
end
```


So, if the `.bulld` method takes arguments, the `.configure` method will, too. (edited)


new messages
sbellware [9:16 PM]
But, it’s a matter of habituation, I know


[9:17]
But… habitation has limits within usability. Dunno. It’s not my favorite part of the stack because I have to answer questions that aren’t immediately evident at a glance. But, some stuff just has to be habituated.


ntl [9:17 PM]
```class Write
  include Configure.new(:write)
end
```


^^ we could always do it that way :slightly_smiling_face:


sbellware [9:17 PM]
LOL!


[9:17]
And other various crimes against Ruby


ntl [9:18 PM]
I sort of don't mind this one: `include Configure[:write]`


sbellware [9:18 PM]
```class Write[Configure[:write]]
end```

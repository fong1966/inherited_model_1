# Sharing Data in Flutter: InheritedModel vs InheritedWidget

An InheritedModel is a way of sharing data across your whole app, the same as InheritedWidget. We previously talked about sharing location data using an InheritedWidget, and we'll contrast some of that in this article. An InheritedModel is a subclass of InheritedWidget, so it works the same in those instances, but adds some extra useful functionality.

When using an InheritedWidget, all subscribed children are updated whenever the data is updated. InheritedModel differs in that the subscribing widget has some control over when it updates, and can be intelligently notified of those updates only when data it cares about has been changed.

This code was tested with Flutter 3.10.6

## The Approach
To demonstrate the differences between these two Widgets, we built a simple app that does the following:

Runs a timer that updates the data we are sharing across the app
Displays 3 widgets updated by an InheritedModel, and 3 updated by InheritedWidget
Each of these widgets displays a tick number from the timer and changes colors every time it is rendered
The timer updates 3 different tick values that it shares with our app using the Inherited* widgets. The first value is updated every timer tick. The second value is updated every two timer ticks. The third value is updated every four timer ticks. This allows for you to clearly see which widget is updated and when. These three values are then passed to our InheritedModel and the rest of our app is render as its child (much like the setup we previously used to share our location data throughout the app).

## Setup
We're not going to discuss the makings of the whole app, since this is just a comparison of the two widgets. Our recommended setup is to clone the project from the GitHub Repository and look at the source.

## The Code
Defining the InheritedModel
We start off by defining an enum to describe the "aspect"s of the Model. The aspect is used by the Widget depending on the InheritedModel to specify which parts of the Model's data the dependent Widget cares about. In our case, we have the 3 numbers our timer will be updating on the Model that we represent with our enum. We use an enum here, instead of a string like the docs use, to make this more programmer friendly: 
- 1. a typo will cause a compile error, 
- 2. code completion in your favorite editor, 
- 3. self-documenting list of available aspect types.

```dart
enum NUMBER_TYPE {
  FIRST,
  SECOND,
  THIRD,
}
```
And then we can use this to define the actual InheritedModel class that we will name NumberModel.

```dart
class NumberModel extends InheritedModel<NUMBER_TYPE> {
  final int firstValue, secondValue, thirdValue;

  NumberModel({
    @required this.firstValue,
    @required this.secondValue,
    @required this.thirdValue,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(NumberModel old) {
    return firstValue != old.firstValue ||
        secondValue != old.secondValue ||
        thirdValue != old.thirdValue;
  }

  @override
  bool updateShouldNotifyDependent(NumberModel old, Set<NUMBER_TYPE> aspects) {
    return (aspects.contains(NUMBER_TYPE.FIRST) && old.firstValue != firstValue) ||
        (aspects.contains(NUMBER_TYPE.SECOND) && old.secondValue != secondValue) ||
        (aspects.contains(NUMBER_TYPE.THIRD) && old.thirdValue != thirdValue);
  }
  
  static NumberModel of(BuildContext context, {NUMBER_TYPE aspect}) {
    return InheritedModel.inheritFrom<NumberModel>(context, aspect: aspect);
  }
}
```
The InheritedModel extends InheritedWidget so we must first implement updateShouldNotify to notify if any of the values change as is expected from this parent. The real magic comes when we implement updateShouldNotifyDependent.

updateShouldNotifyDependent is called with a Set of aspects that we need to check. A Widget can depend on more than one aspect of the Model, so we have to check them all. If a given aspect is present in the Set, and the associated value has changed, then we notify the dependent widget of the update. This allows the widget to only update when things it cares about have changed.

Lastly, we have our very simple factory method of that simplifies the amount of code we have to write to get an instance of our Model. If aspect is null, then the model supports all aspects and it's the exact same as creating an InheritedModel by using ~~context.inheritFromWidgetOfExactType(NumberModel)~~ 

```dart
context.dependOnInheritedWidgetOfExactType<NumberModel>()
```
Otherwise, the instance being created only cares about the aspect that is passed.

Initializing the InheritedModel
Our inherited model needs to be above the dependent widgets in the widget tree. Often, it can be most useful to have the model as one of the top-most widgets of the app.

We will use a StatefulWidget to manage the values we pass to our Model, as follows:

```dart
class NumberManagerWidget extends StatefulWidget {
  final Widget child;

  NumberManagerWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => NumberManagerWidgetState();
}

class NumberManagerWidgetState extends State<NumberManagerWidget> {
  int firstTick, secondTick, thirdTick;

  @override
  void initState() {
    super.initState();
    firstTick = secondTick = thirdTick = 0;
  }
  
  // ... snip code for handling timers, etc, to update the tick values ...

  @override
  Widget build(BuildContext context) {
    return NumberModel(
      firstValue: firstTick,
      secondValue: secondTick,
      thirdValue: thirdTick,
      child: widget.child,
    );
  }
}
```
We manage the values for the ticks, then pass them to NumberModel in our build method. Whenever the values are updated on NumberModel, it will notify the dependents of the changes.

Now, we just need to put it near the top of our widget tree. For demonstration purposes, we just put it at the very top of the tree, so that everything can access it:

```dart
void main() => runApp(NumberManagerWidget(child: MyApp()));
```
Using the InheritedModel
Now that we have defined the model, we can use it to pass our dependencies around.

```dart
class AsInheritedModel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NumberModel model = NumberModel.of(context, aspect: NUMBER_TYPE.FIRST);
    return Text("Values: ${model.firstValue}, ${model.secondValue}, ${model.thirdValue}");
  }
}

class AsInheritedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NumberModel model = NumberModel.of(context);
    return Text("Values: ${model.firstValue}, ${model.secondValue}, ${model.thirdValue}");
  }
}
```
As you can see, the code is nearly identical. The magic comes from the aspect parameter that allows us to key in to the updated data that we care about, the InheritedModel does the rest for us, as you can see in the video below.

### FlutterInheritedModel Vs InheritedWidget

You can see the behavior of the Inherited Model in the top section that each colored block is only updating when the number inside that block changes. In the lower section, you can see the Inherited Widget updates each block every time any of the numbers change.

In Conclusion
Inherited Models are very powerful in that they allow us to intelligently share many things across our whole app using a single widget to manage them. One of the basic use cases is sharing multiple different network connections across the app. Also, I highly recommend using an enum to define your aspects, instead of using hard coded strings. It makes things so much easier to maintain.

Thanks for reading, and happy inheriting!
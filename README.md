# IBViewControllerBug

Demonstrates a problem in mixed Objective-C and Swift projects: An Objective-C view controller extended in Swift is interpreted by Interface Builder as a Swift class that uses the app's module name, but the compiled class does not have a module name so it is not found at runtime.

- App was created from iOS "Tabbed Application" template, using Swift
- FirstViewController and SecondViewController Swift versions were replaced with bare bones Objective-C versions. FirstViewController should make the view's backgroundColor orange, and SecondViewController should make it blue.
- ExtendFirst.swift was added with the sole purpose of extending FirstViewController with an innocuous protocol, adding the method `doSomething` (which actually does nothing)
- ThirdViewController.swift has been added (coloring the view magenta) as a class naming comparison
- Main.storyboard has had the view controllers' Identity inspectors updated to reflect the controllers' class names as if you were adding existing classes to the storyboard

Run the app and observe:

- FirstViewController's view does not have an orange backgroundColor (indicating it didn't load)
- SecondViewController's view does have a blue backgroundColor (indicating it did load)
- There is a line of console output reading "Unknown class _TtC19IBViewControllerBug19FirstViewController in Interface Builder file."
- If you run `nm IBViewControllerBug | grep _TtC19IBViewControllerBug19FirstViewController` against the generated binary, you can confirm this symbol does not exist
- If you run `nm IBViewControllerBug | grep Third` against the binary and compare it against grepping for 'First', you can see there are symbols similar to what IB is expecting (i.e. ending in '19IBViewControllerBug19ThirdViewController')

Further exploration (done in branch 'not_extended'):

- Remove 'ExtendFirst.swift' from the build target
- Compile to ensure updated symbols are indexed
- Open Main.storyboard and examine the First Scene's view controller class identity
- Re-enter "FirstViewController" to set the view controller's class and trigger IB to update its info
- Build and Run the app

Observe:

- FirstViewController now loads and the first tab is orange
- The storyboard xml viewController element no longer includes the attributes 'customModule="IBViewControllerBug" customModuleProvider="target"'

I am not sure if the bug here is that IB is including a module name it shouldn't, that we aren't given a way to specify "no module" (but this feels too subtle to expect developers need to identify on changes?), or that the compiler should generate the Swift-extended class in the app module.

Regardless, this is a bit worrisome for legacy Objective-C apps that developers can silently break by simply extending existing view controllers.

-- pcg, 2016aug19

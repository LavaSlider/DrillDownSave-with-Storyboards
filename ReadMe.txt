DrillDownSave with Storyboard (DDS-Storyboard)

This example was derived almost in its entirety from DrillDownSave with a minimal
number of alterations to simplify understanding the transition. It is recommended that DrillDownSave
also be inspected to recognize the differences more clearly.

It demonstrates how to restore the user's current location in a drill-down list style user interface and
restore that location when the app is relaunched. The drill-down or content hierarchy is generated
from a plist file called 'outline.plist'.

To be able to do this the runtime system must be prevented from automatically loading
the storyboard. To do this the app's info.plist (DDS-Storyboard-Info.plist), was
modified to effectively remove the value of "Main storyboard file base name". Rather
than just deleting it, its name (key) was changed* so its value could still be used
to specify the file name root.

Once this is done the AppDelegate must again be responsible for creating the application's
window, loading its rootview controller and making it key and visible.

The sample stores the user's location in its preferences file using NSUserDefaults.

One important factor this sample illustrates in restoring the proper UIViewController stack by
telling its UINavigationController to push each level without animation like so:

	[[self navigationController] pushViewController:level3ViewController animated:NO];

To do this a custom UIStoryboardSegue subclass is needed. To simplify the storyboard and
implementation this subclass completely emulates built-in Push segue but has three properties
that can be set to alter its function (one to avoid the animation and two to invoke a method with a parameter
after the pushViewController method has been called).


Build Requirements
iOS 4.2 SDK


Runtime Requirements
iPhone OS 5.0 or later


Using the Sample
Build and run DDS-Storyboard using Xcode. To run in the simulator, set the Active SDK to Simulator.
To run on a device, set the Active SDK to the appropriate Device setting.
When launched navigate through various items in the tree hierarchy.  Press the home button,
press the home button twice to terminate the app, and re-launch DDS-Storyboard.
The app should return you to the same level from the previous launch.


Packaging List
main.m - Main source file for this sample.
AppDelegate.h/.m - The application' delegate to setup its window and content.
MainStoryboard.storyboard - The application's user interface description.
CustomPushSegue.h/.m - The navigation contoller push segue to allow non-animated segues and post-push method calls.
Level1ViewController.h/.m - The top-most view controller of the tree hierarchy.
Level2ViewController.h/.m - The second level view controller of the tree hierarchy.
Level3ViewController.h/.m - The third and last level view controller of the tree hierarchy.
LeafViewController.h/.m - Leaf item view controller for items residing at level 3.
outline.plist - the dictionary or outline of the view level hierarchy used in populating the drill-down list.


Change log from DrillDownSave this was copied from:
1.0 - First release
1.1 - Updated for and tested with iPhone OS 2.0. First public release.
1.2 - Upgraded for 3.0 SDK due to deprecated APIs; in "cellForRowAtIndexPath" it now uses UITableViewCell's initWithStyle.
1.3 - Upgraded project to build with the iOS 4.0 SDK.

Changes from DrillDownSave and Versions:
1.0 - Added storyboard, added CustomPushSegue, moved the functionality from "didSelectRow" methods
      to "prepareForSegue" methods and modified the "restoreLevel:withSelectionArray:" methods
      to perform segues instead of directly pushing views on the navigation controller.

* To change the info.plist key values, control-click on the file contents and choose
"Show Raw Keys/Values". The "UIMainStoryboardFile" can then be clicked on and changed.
Alternatively, you can control-click on the filename in the Project Navigator pane
and select "Open As >> Source Code" then modify the key in the XML listing.

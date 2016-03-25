# SimpleImageViewer
A simple image viewer that demonstrates how to create a centered view within Scroll View using Swift 2.2

This is a sample project that shows how to build a NSScrollView with an embedded view that centers the content when the size of the content is smaller than the size of the parent scroll view, and allows standard scrolling when the contained view is larger than the parent scroll view size.  The behavior is similar to what you might see with the Preview Application, or any number of other programs.  Unfortunately, Apple's SDK does not give a direct way to do this. By default, the contained view of the NSScrollView is pinned to the lower left corner (or in older code, the upper left corner). Apple provides no method to center the contained view, although many or their products clearly use such behavior.  And while the issue may appear to have several simple solutions, a full solution turns out to be more opaque than an initial take may surmise.  

Searches online will reveal several methods for centering the contained view.  Many of these solutions use outdated, and sometimes deprecated methods.  Most of these appear to work, until one attempts to resize the contained view.  Then one sees one (or more) of several problems.  Most of these solutions involve resizing the frame of the contained view.  This turns out to not be a sound practice, as it causes discontinuities in the visual layout.  Occasionally the layout will appear to jump back to a smaller (or larger) size.  Resizing the NSScrollView sometimes causes problems with the layout of the internal view, and other visual problems.

It is tempting to subclass the contained view and override the NSView.intrinsicContentSize getter.  Besides several gotchas that become readily apparent as one goes down this path, other side effects appear once the code is in place.  The biggest issue is that this can wreak havoc on any layout constraints one might have.  In addition, various forms of discontinuity can appear, including the sizing of the view not being what it is set to in the intrinsicContentSize getter. 

A complete solution turns out to require a number of steps, but is rather simple in principle.  First, there is a piece of sample code from Apple called CenteringClipView.swift (it can be found at https://developer.apple.com/library/mac/samplecode/Exhibition/Listings/Exhibition_CenteringClipView_swift.html).  This provides a method for centering the view using insets. This centering clip view is used to replace the standard clip view provided with a NSSCrollView. But this code does not provide instruction on how to resize the view that maintains the integrity of the contained view position and size.

One needs to work entirely with constraints (instead of frame or bounds) to manipulate the size of the contained view.  Two pieces of documentation from Apple provide clues to this solution: 
  1. https://developer.apple.com/library/mac/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithConstraintsinInterfaceBuidler.html#//apple_ref/doc/uid/TP40010853-CH10-SW1 
      Specifically the section on "Rules of Thumb"
  2. https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithScrollViews.html#//apple_ref/doc/uid/TP40010853-CH24-SW1
      "The critical wording from this link comes right at the top:
         - Any constraints between the scroll view and objects outside the scroll view attach to the scroll view’s frame, just as with any other view.
         - For constraints between the scroll view and its content, the behavior varies depending on the attributes being constrained:
          Constraints between the edges or margins of the scroll view and its content attach to the scroll view’s content area.
          Constraints between the height, width, or centers attach to the scroll view’s frame."
          
    and this "Important Note":
    
      "Your layout must fully define the size of the content view (except where defined in steps 5 and 6). To set the height based on the intrinsic size of your content, you must have an unbroken chain of constraints and views stretching from the content view’s top edge to its bottom edge. Similarly, to set the width, you must have an unbroken chain of constraints and views from the content view’s leading edge to its trailing edge."
          
So what we do is provide constraints from the contained view to the centering clip view, and width and height constraints for the content view.  When resizing the view, resize the width and height constraints, not the frame (or bounds).  This last is very important to recognize - updating the frame or intrinsic content size directly can cause problems with your layout.  Use the width and height constraints *only* to update the size of the contained view.



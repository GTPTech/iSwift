//
//  HorizontalScroller.swift
//  iSwift
//
//  Created by Tomer Tapiro on 7/20/15.
//  Copyright © 2015 Moblin. All rights reserved.
//

// 🔌 Adapter
// ----------
// The adapter pattern is used to provide a link between 
// two otherwise incompatible types by wrapping the "adaptee"
// with a class that supports the interface required by the client.
// ----------------------------------------------------------------

import UIKit

@objc protocol HorizontalScrollerDelegate {
    // Ask the delegate how many views he wants to present inside the horizontal scroller
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    // Ask the delegate to return the view that should appear at <index>
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index:Int) -> UIView
    // Inform the delegate what the view at <index> has been clicked
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index:Int)
    // Ask the delegate for the index of the initial view to display. this method is optional
    // and defaults to 0 if it's not implemented by the delegate
    optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {
  
    // Declare the delegate:
    // WEAK is necessary in order to prevent a retain cycle.
    // The delegate is an optional, so it’s possible whoever is using 
    // this class doesn’t provide a delegate. But if they do, it will 
    // conform to HorizontalScrollerDelegate and you can be sure the 
    // protocol methods will be implemented there.
  
    weak var delegate: HorizontalScrollerDelegate?
  
    // Define constants to make it easy to modify the layout at design time.
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEWS_OFFSET = 100
  
    // Create the scroll view containing the views.
    private var scroller: UIScrollView!
  
    // Create an array that holds all the album covers.
    var viewArray = [UIView]()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeScrollView()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeScrollView()
    }
  
    func initializeScrollView() {
      
        // Create’s a new UIScrollView instance and add it to the parent view.
        scroller = UIScrollView()
      
        // Set the delegate
        scroller.delegate = self
      
        scroller.showsVerticalScrollIndicator = false
        scroller.showsHorizontalScrollIndicator = false
        scroller.bounces = false
        
        addSubview(scroller)
      
        // Turn off autoresizing masks. This is so you can apply your own constraints.
        scroller.translatesAutoresizingMaskIntoConstraints = false

        // Apply constraints to the scrollview. You want the scroll view to completely fill the HorizontalScroller.
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))

        // Create a tap gesture recognizer. The tap gesture recognizer
        // detects touches on the scroll view and checks if an album 
        // cover has been tapped. If so, it will notify the HorizontalScroller delegate.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollerTapped"))
        scroller.addGestureRecognizer(tapRecognizer)
    }
  
    func scrollerTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                let view = scroller.subviews[index] 
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated:true)
                    break
                }
            }
        }
    }
  
    // Returns the view at a particular index.
    func viewAtIndex(index: Int) -> UIView {
        return viewArray[index]
    }
  
    // Reload the scroller - execute when data has changed.
    func reload() {
        // Check if there is a delegate, if not there is nothing to load.
        if let delegate = delegate {
            // Will keep adding new album views on reload, need to reset.
            viewArray = []
            let views: NSArray = scroller.subviews
        
            // Remove all subviews
            views.map { view in
                view.removeFromSuperview()
            }
        
            // xValue is the starting point of the views inside the scroller
            var xValue = VIEWS_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScroller(self) {
                // Add a view at the right position
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRectMake(CGFloat(xValue), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
              
                // Store the view so we can reference it later
                viewArray.append(view)
            }
        
            // Once all the views are in place, set the content offset for the scroll view to allow the user to scroll through all the albums covers.
            scroller.contentSize = CGSizeMake(CGFloat(xValue + VIEWS_OFFSET), frame.size.height)
            print("frame.size.width: \(frame.size.width)")
            print("frame.size.height: \(frame.size.height)")
        
            // If an initial view is defined, center the scroller on it
            if let initialView = delegate.initialViewIndex?(self) {
                scroller.setContentOffset(CGPoint(x: CGFloat(initialView)*CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
            }
        }
    }
  
    override func didMoveToSuperview() {
        reload()
    }
  
    // Center the current view
    func centerCurrentView() {
        var xFinal = Int(scroller.contentOffset.x) + (VIEWS_OFFSET/2) + VIEW_PADDING
        let viewIndex = xFinal / (VIEW_DIMENSIONS + (2*VIEW_PADDING))
        xFinal = viewIndex * (VIEW_DIMENSIONS + (2*VIEW_PADDING))
        scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
        if let delegate = delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: viewIndex)
        }
    }
}

// MARK: UIScrollViewDelegate

extension HorizontalScroller: UIScrollViewDelegate {
    // Informs the delegate when the user finishes dragging. 
    // The decelerate parameter is true if the scroll view hasn’t come to a complete stop yet.
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
  
    // The scroll action ends,
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}


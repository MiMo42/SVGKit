//
//  CenteringClipView.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "CenteringClipView.h"

@implementation CenteringClipView

#pragma mark - Private Methods

- (NSRect)constrainBoundsRect:(NSRect)proposedBounds
{
    if (self.documentView == nil)
        return [super constrainBoundsRect:proposedBounds];
    
    NSRect newClipBoundsRect = [super constrainBoundsRect:proposedBounds];

    // Get the `contentInsets` scaled to the future bounds size.
    NSEdgeInsets insets = [self _convertedContentInsetsToProposedBoundsSize:newClipBoundsRect.size];

    // Get the insets in terms of the view geometry edges, accounting for flippedness.
    CGFloat minYInset = self.isFlipped ? insets.top : insets.bottom;
    CGFloat maxYInset = self.isFlipped ? insets.bottom : insets.top;
    CGFloat minXInset = insets.left;
    CGFloat maxXInset = insets.right;

    /*
        Get and outset the `documentView`'s frame by the scaled contentInsets.
        The outset frame is used to align and constrain the `newClipBoundsRect`.
    */
    NSRect documentFrame = self.documentView.frame;
    
    NSRect outsetDocumentFrame = NSMakeRect(NSMinX(documentFrame) - minXInset,
                                            NSMinY(documentFrame) - minYInset,
                                            (NSWidth(documentFrame) + (minXInset + maxXInset)),
                                            NSHeight(documentFrame) + (minYInset + maxYInset));

    if (newClipBoundsRect.size.width > outsetDocumentFrame.size.width) {
        /*
            If the clip bounds width is larger than the document, center the
            bounds around the document.
        */
        newClipBoundsRect.origin.x = NSMinX(outsetDocumentFrame) - (NSWidth(newClipBoundsRect) - NSWidth(outsetDocumentFrame)) / 2.0;
    }
    else if (newClipBoundsRect.size.width < outsetDocumentFrame.size.width) {
        /*
            Otherwise, the document is wider than the clip rect. Make sure that 
            the clip rect stays within the document frame.
        */
        if (NSMaxX(newClipBoundsRect) > NSMaxX(outsetDocumentFrame)) {
            // The clip rect is outside the maxX edge of the document, bring it in.
            newClipBoundsRect.origin.x = NSMaxX(outsetDocumentFrame) - NSWidth(newClipBoundsRect);
        }
        else if (NSMinX(newClipBoundsRect) < NSMinX(outsetDocumentFrame)) {
            // The clip rect is outside the minX edge of the document, bring it in.
            newClipBoundsRect.origin.x = NSMinX(outsetDocumentFrame);
        }
    }

    if (newClipBoundsRect.size.height > outsetDocumentFrame.size.height) {
        /*
            If the clip bounds height is larger than the document, center the 
            bounds around the document.
        */
        newClipBoundsRect.origin.y = NSMinY(outsetDocumentFrame) - (NSHeight(newClipBoundsRect) - NSHeight(outsetDocumentFrame)) / 2.0;
    }
    else if (NSHeight(newClipBoundsRect) < NSHeight(outsetDocumentFrame)) {
        /*
            Otherwise, the document is taller than the clip rect. Make sure 
            that the clip rect stays within the document frame.
        */
        if (NSMaxY(newClipBoundsRect) > NSMaxY(outsetDocumentFrame)) {
            // The clip rect is outside the maxY edge of the document, bring it in.
            newClipBoundsRect.origin.y = NSMaxY(outsetDocumentFrame) - NSHeight(newClipBoundsRect);
        }
        else if (NSMinY(newClipBoundsRect) < NSMinY(outsetDocumentFrame)) {
            // The clip rect is outside the minY edge of the document, bring it in.
            newClipBoundsRect.origin.y = NSMinY(outsetDocumentFrame);
        }
    }

    return [self backingAlignedRect:newClipBoundsRect options:NSAlignAllEdgesNearest];
}

- (NSEdgeInsets)_convertedContentInsetsToProposedBoundsSize:(NSSize)proposedBoundsSize
{
        // Base the scale factor on the width scale factor to the new proposedBounds.
    CGFloat fromBoundsToProposedBoundsFactor =
        self.bounds.size.width > 0 ? (proposedBoundsSize.width / self.bounds.size.width) : 1.0;

    // Scale the set `contentInsets` by the width scale factor.
    NSEdgeInsets newContentInsets = self.contentInsets;
    newContentInsets.top *= fromBoundsToProposedBoundsFactor;
    newContentInsets.left *= fromBoundsToProposedBoundsFactor;
    newContentInsets.bottom *= fromBoundsToProposedBoundsFactor;
    newContentInsets.right *= fromBoundsToProposedBoundsFactor;

    return newContentInsets;
}

@end

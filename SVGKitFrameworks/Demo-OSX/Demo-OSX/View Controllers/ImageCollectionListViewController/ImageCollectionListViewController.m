//
//  ImageCollectionListViewController.m
//  Demo-OSX
//
//  Created by Michael Monscheuer on 17/10/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "ImageCollectionListViewController.h"

#import "ImageCollection.h"

@interface ImageCollectionListViewController () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (weak) IBOutlet NSOutlineView *outlineView;

@end

@implementation ImageCollectionListViewController
{
    NSArray *_imageCollections;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self _reloadOutlineAndSelectFirstItemIfNeeded];
    
}

#pragma mark - Properties

- (NSArray *)imageCollections
{
    @synchronized (self) {
        return _imageCollections;
    }
}

- (void)setImageCollections:(NSArray *)collections
{
    @synchronized (self) {
        _imageCollections = collections;
    }
    
    if (![self isViewLoaded])
        return;
        
    [self _reloadOutlineAndSelectFirstItemIfNeeded];
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return _imageCollections[index];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    // The root item has each collection as its children.
    if (item == nil) {
        return _imageCollections.count;
    }
    
    return 0;
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    ImageCollection *imageCollection = item;
    
    if (![imageCollection isKindOfClass:[ImageCollection class]])
        return nil;
    
    NSTableCellView *view = [_outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    
    view.textField.stringValue = imageCollection.name;
    view.imageView.image = imageCollection.tableViewIcon;
    
    /*
        Turn on `translatesAutoresizingMaskIntoConstraints` so the outline view
        can manage the size and position of the views, specifically when the
        'Sidebar Icon Size' changes. With this on, the source nib must not be
        adding any runtime constraints to these views.
    */
    view.textField.translatesAutoresizingMaskIntoConstraints = true;
    view.imageView.translatesAutoresizingMaskIntoConstraints = true;
        
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return false;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return false;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return [item isKindOfClass:[ImageCollection class]];
}

 - (void)outlineViewSelectionDidChange:(NSNotification *)notification
 {
    if (notification.object != _outlineView)
        return;
     
    [self _handleSelectionChanged];
 }

#pragma mark - Private Methods

- (void)_reloadOutlineAndSelectFirstItemIfNeeded
{
    NSIndexSet *oldSelection = _outlineView.selectedRowIndexes;

    [_outlineView reloadData];

    if (oldSelection.count == 0) {
        /*
            If the outline view didn't already have a selection, select the
            first `ImageCollection` (if one exists).
        */
        if (_imageCollections.count == 0)
            return;

        NSIndexSet *firstIndexSet = [NSIndexSet indexSetWithIndex: 0];

        [_outlineView selectRowIndexes:firstIndexSet byExtendingSelection:false];
    }
    else {
        // If there was an old selection, restore that old selection.
        [_outlineView selectRowIndexes:oldSelection byExtendingSelection:false];
    }
}

- (void)_handleSelectionChanged
{
    ImageCollectionListSelectionHandler selectionHandler = [self collectionSelectionHandler];
    if (selectionHandler == nil)
        return;
    
    NSMutableArray <ImageCollection *> *imageCollections = [NSMutableArray new];
    
    NSIndexSet *selIndexes = self.outlineView.selectedRowIndexes;
    [selIndexes enumerateIndexesUsingBlock:
        ^(NSUInteger idx, BOOL * _Nonnull stop) {
        
            id item = [self.outlineView itemAtRow:idx];
            
            if ([item isKindOfClass:[ImageCollection class]]) {
                [imageCollections addObject:item];
            }
        }];
    
    selectionHandler(imageCollections);
}

@end

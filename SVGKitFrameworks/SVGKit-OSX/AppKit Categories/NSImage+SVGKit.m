//
//  NSImage+SVGKit.m
//  SVGKit-OSX
//
//  Created by Michael Monscheuer on 02/05/16.
//  Copyright © 2016 Michael Monscheuer. All rights reserved.
//

#import "NSImage+SVGKit.h"

@implementation NSImage (SVGKit)

+ (NSImage *)imageWithData:(NSData *)data
{
    return [[NSImage alloc] initWithData:data];
}

@end

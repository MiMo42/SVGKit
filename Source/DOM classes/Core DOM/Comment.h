/*
 From SVG-DOM, via Core DOM:
 
 http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1728279322

 interface Comment : CharacterData {
 };
*/

#import <Foundation/Foundation.h>

#import "CharacterData.h"

#if (!TARGET_OS_IPHONE)
#import "SVGKit-OSX.Globals.h"
#endif

@interface Comment : CharacterData

- (id)initWithValue:(NSString*) v;

@end

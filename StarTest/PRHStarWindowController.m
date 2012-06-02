//
//  PRHStarWindowController.m
//  StarTest
//
//  Created by Peter Hosey on 2012-06-02.
//

#import "PRHStarWindowController.h"

#import "PRHStarView.h"

@interface PRHStarWindowController ()
@property(weak) IBOutlet PRHStarView *starView;
@end

@implementation PRHStarWindowController

@synthesize shouldClosePath = _shouldClosePath;
@synthesize starView = _starView;

- (id)initWithWindow:(NSWindow *)window {
	self = [super initWithWindow:window];
	if (self) {
		self.shouldClosePath = true;
	}
	return self;
}
- (id)init {
	return [self initWithWindowNibName:[self className]];
}

- (void)windowDidLoad {
	[super windowDidLoad];

	[self.window setAspectRatio:(NSSize){ 1.0, 1.0 }];
	self.starView.shouldClosePath = self.shouldClosePath;
}

- (void) setShouldClosePath:(bool)scp {
	_shouldClosePath = scp;
	self.starView.shouldClosePath = scp;
}

@end

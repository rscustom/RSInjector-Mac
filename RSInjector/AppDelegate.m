#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

-(void)bringToFrontApplicationWithBundleIdentifier:(NSString*)inBundleIdentifier
{
	NSArray* appsArray = [NSRunningApplication runningApplicationsWithBundleIdentifier:inBundleIdentifier];
	if([appsArray count] > 0)
	{
		[[appsArray objectAtIndex:0] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
	}
	
	[[NSApplication sharedApplication] terminate:self];
}

- (NSString *)getSteamPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basepath = [paths objectAtIndex:0];

    // TODO: ask for path if not found and store in plist
    NSString *exe_path = [NSString stringWithFormat:@"%@/%@",
                          basepath, @"Steam/SteamApps/common/Rocksmith2014/"];

    return exe_path;
}

- (void)launchRS:(NSString *)withTarget
{
    NSString *dyldLibrary = [[NSBundle bundleForClass:[self class]] pathForResource:@"RSBypass" ofType:@"dylib"];

    NSString *launcherString = [NSString stringWithFormat:@"DYLD_INSERT_LIBRARIES=\"%@\" \"%@\" &", dyldLibrary, withTarget];

    system([launcherString UTF8String]);

    [self performSelector:@selector(bringToFrontApplicationWithBundleIdentifier:) withObject:@"Ubisoft.Rocksmith2014" afterDelay:2.0];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    NSString *target = @"./Rocksmith2014.app/Contents/MacOS/Rocksmith2014";

    NSString *appPath = [NSString stringWithFormat:@"%@/../",
                         [[NSBundle mainBundle] bundlePath]];

    [[NSFileManager defaultManager] changeCurrentDirectoryPath:appPath];

	if([[NSFileManager defaultManager] fileExistsAtPath:target] == FALSE)
    {
        // If RS was not found in the current directory we try steam
        [[NSFileManager defaultManager] changeCurrentDirectoryPath:[self getSteamPath]];
    }


    if([[NSFileManager defaultManager] fileExistsAtPath:target])
        [self launchRS:target];
    else
    {
        NSAlert* alert = [[[NSAlert alloc] init] autorelease];
        [alert setMessageText:@"Rocksmith2014.app not found !"];
        [alert runModal];
    }
}

@end

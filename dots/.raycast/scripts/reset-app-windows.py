#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset App Windows (via Python)
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🖥️

# Documentation:
# @raycast.author rsefer
# @raycast.authorURL https://raycast.com/rsefer

import subprocess, os, json
# from AppKit import NSScreen

# runningAppsCommand = subprocess.run(['osascript', '-e', """tell application "System Events" to get name of every process"""], stdout=subprocess.PIPE, encoding='utf8')
# runningApps = runningAppsCommand.stdout.strip()

# print(runningApps)

screensCommand = subprocess.run(['osascript', '-e', """
tell application "System Events"
	every screen
end tell
"""], stdout=subprocess.PIPE, encoding='utf8')
screens = screensCommand.stdout.strip()
print(screens)
exit()

# def activateApp(appBundle):
# 	os.system(f"""osascript -e '
# 		tell application id "{appBundle}"
# 			if running then activate
# 		end tell
# 	'""")

# def moveApp(appBundle, x, y):
# 	os.system(f"""osascript -e '
# 		tell application id "{appBundle}"
# 			set position of the first window to {{{x}, {y}}}
# 		end tell
# 	'""")

# layoutsJSON = open(f"{os.environ['DOTFILES_ROOT']}/mac-scripts/layouts.json")
# layouts = json.load(layoutsJSON)

# for screen in NSScreen.screens():
# 	localizedName = screen.localizedName
# 	if callable(localizedName):
# 		localizedName = localizedName()
# 		# print(localizedName)
# 	visibleFrame = screen.visibleFrame
# 	if callable(visibleFrame):
# 		visibleFrame = visibleFrame()
# 		# print(visibleFrame)
# 	frame = screen.frame
# 	if callable(frame):
# 		frame = frame()
# 		# print(frame)
# 	deviceDescription = screen.deviceDescription
# 	if callable(deviceDescription):
# 		deviceDescription = deviceDescription()
# 		# print(deviceDescription)

# 	matching_screens = [screen for screen in layouts['screens'] if screen.get('name').lower() == localizedName.lower() or (screen.get('aliases') and localizedName.lower() in [x.lower() for x in screen.get('aliases')])]

# 	if len(matching_screens) > 0:
# 		matching_screen = matching_screens[0]
# 		matching_screen['size'] = {
# 			'width': visibleFrame.size.width,
# 			'height': visibleFrame.size.height
# 		}
# 		matching_screen['coordinates'] = {
# 			'x': visibleFrame.origin.x,
# 			'y': visibleFrame.origin.y
# 		}
# 		matching_screen['maxCoordinates'] = {
# 			'x': matching_screen['coordinates']['x'] + matching_screen['size']['width'],
# 			'y': matching_screen['coordinates']['y'] + matching_screen['size']['height'],
# 		}
# 		print('MATCHING')
# 		print(matching_screen)

# frontmostAppCommand = subprocess.run(['osascript', '-e', """tell application "System Events" to get (bundle identifier of first application process whose frontmost is true) as string"""], stdout=subprocess.PIPE, encoding='utf8')
# frontmostApp = frontmostAppCommand.stdout.strip()

# displaysProfile = subprocess.run(['system_profiler', 'SPDisplaysDataType'], stdout=subprocess.PIPE, encoding='utf8')
# displaysProfileOutput = displaysProfile.stdout

# screenSetup = layouts['screens'][0]
# for i, screen in enumerate(layouts['screens']):
# 	if screen['name'] in displaysProfileOutput:
# 		screenSetup = screen['slug']

# for k, group in enumerate(layouts['appGroups']):
# 	for k2, appName in enumerate(group['apps']):
# 		print(appName)
# 		activateApp(appName)
# 		print(screenSetup)
# 		print(group['sizes'][screenSetup])
# 		os.system(f'open -g raycast://extensions/raycast/window-management/{group['sizes'][screenSetup]}')

# activateApp(frontmostApp)

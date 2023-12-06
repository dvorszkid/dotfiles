local function toggleApp(name)
	print("Looking for window:", name)
	local win = hs.application.find(name)
	print("Found:", win)

	-- TODO: move to current space
	-- print(hs.spaces.allSpaces())
	-- local focused_win = hs.window.focusedWindow()
	-- print(focused_win)
	-- print(focused_win:screen())
	-- print(focused_win:screen():getUUID())
	-- print("Focused space:", hs.spaces.focusedSpace())
	-- print("Focused window spaces:", hs.spaces.windowSpaces(focused_win))
	-- local focused_win_space_id = table.remove(hs.spaces.windowSpaces(focused_win))
	-- print("Focused window space:", focused_win_space_id)

	-- TODO: launch if not running
	-- if not app or app:isHidden() then
	-- 	hs.application.launchOrFocus(name)
	if hs.window.focusedWindow() ~= win then
		-- hs.spaces.moveWindowToSpace(win, focused_win_space_id)
		win:application():activate()
		win:focus()
	else
		win:application():hide()
	end
end

-- Global terminal toggle
hs.hotkey.bind({}, "F12", function()
	toggleApp("AlacrittyDropdown")
end)

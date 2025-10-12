local wibox = require("wibox")
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local beautiful = require("beautiful")

local calendar_popup_factory = require("awesome-wm-widgets.calendar-widget.calendar")
local cpu_widget_factory = require("awesome-wm-widgets.cpu-widget.cpu-widget")

local string = string
local os = os

local markup = lain.util.markup

local ui = {}

function wrap_imagebox(icon)
    local padding_background = wibox.container.background(icon, beautiful.bg_focus, gears.shape.rectangle)
    local padding = wibox.container.margin(padding_background, 2, 2, 0, 0)
    local margin_background = wibox.container.background(padding, beautiful.bg_focus, gears.shape.rectangle)
    return wibox.container.margin(margin_background, 0, 0, 5 * config.dpi_scaling, 5 * config.dpi_scaling)
end

function wrap_icon(icon_path)
    local icon = wibox.widget.imagebox(icon_path)
    return wrap_imagebox(icon)
end

function wrap_widget(icon_path, widget)
    local icon = wibox.widget.imagebox(icon_path)
    local background = wibox.container.background(widget, beautiful.bg_focus, gears.shape.rectangle)
    local margin = wibox.container.margin(background, 0, 0, 5 * config.dpi_scaling, 5 * config.dpi_scaling)
    return wibox.widget({
        icon,
        nil,
        margin,
        layout = wibox.layout.align.horizontal,
    })
end

-- Clock
local mytextclock = wibox.widget.textclock("%H:%M:%S", 1)
-- mytextclock.forced_width = 60 * config.dpi_scaling
mytextclock.align = "center"
local clock_widget = wrap_widget(beautiful.clock, mytextclock)

-- Calendar
local mytextcalendar = wibox.widget.textclock("W%V, %d %b %a ")
ui.calendar_widget = wrap_widget(beautiful.calendar, mytextcalendar)

-- Calendar popup
ui.calendar_popup = calendar_popup_factory({
    placement = "top_right",
})
ui.calendar_widget:connect_signal("mouse::enter", ui.calendar_popup.toggle)
ui.calendar_widget:connect_signal("mouse::leave", ui.calendar_popup.toggle)

-- ALSA volume bar
local alsa_channel = io.popen('(alsactl info 0 | grep "id: PCH" > /dev/null && echo 0) || echo 1'):read()
print("Using ALSA Channel: " .. alsa_channel)
local myalsabar = lain.widget.alsabar({
    cmd = "amixer -c " .. alsa_channel,
    -- togglechannel = "IEC958,3",
    width = 80 * config.dpi_scaling,
    height = 10,
    border_width = 0,
    followtag = true,
    colors = {
        background = "#383838",
        unmute = "#80CCE6",
        mute = "#FF9F9F",
    },
})
if config.dpi_scaling > 1.1 then
    myalsabar.bar.paddings = 4
else
    myalsabar.bar.paddings = 0
end
myalsabar.bar.margins = 7
local volume_widget = wrap_widget(beautiful.volume, myalsabar.bar)
ui.volume = myalsabar

-- CPU
local cpu_widget = cpu_widget_factory({
    width = 70 * config.dpi_scaling,
    step_width = 2,
    step_spacing = 1,
})
cpu_widget = wrap_widget(beautiful.cpu, cpu_widget)

-- MEM
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(mem_now.used .. " MiB")
    end,
})
mem.widget.align = "right"
mem.widget.forced_width = 70 * config.dpi_scaling
local mem_widget = wrap_widget(beautiful.mem, mem.widget)

-- Net
local netdown = wibox.widget.textbox()
netdown.align = "right"
netdown.forced_width = 75 * config.dpi_scaling
local netup = lain.widget.net({
    settings = function()
        netdown:set_markup(net_now.received .. " kB/s")
        widget:set_markup(net_now.sent .. " kB/s")
    end,
})
netup.widget.align = "right"
netup.widget.forced_width = 75 * config.dpi_scaling
local netdown_widget = wrap_widget(beautiful.net_down, netdown)
local netup_widget = wrap_widget(beautiful.net_up, netup.widget)

-- Notifications
do
    ui.donotdisturb_icon = wibox.widget.imagebox(beautiful.do_not_disturb)
    ui.donotdisturb_widget = wrap_imagebox(ui.donotdisturb_icon)
    ui.donotdisturb_icon.opacity = 0.2

    ui.donotdisturb_tooltip = awful.tooltip({
        objects = { ui.donotdisturb_widget },
        text = "Do Not Disturb OFF",
    })
end

-- VPN
do
    local pidfile = home_dir .. "/.vpn/work/openconnect.pid"
    ui.vpn_icon = wibox.widget.imagebox(beautiful.vpn)
    ui.vpn_widget = wrap_imagebox(ui.vpn_icon)
    ui.vpn_icon.opacity = 0.2

    ui.vpn_tooltip = awful.tooltip({
        objects = { ui.vpn_widget },
        text = "Unknown VPN status",
    })

    ui.vpn_timer = gears.timer({
        timeout = 5,
        call_now = true,
        autostart = true,
        callback = function()
            awful.spawn.easy_async({ "sh", "-c", 'ps -p `cat "' .. pidfile .. '"` -o comm=' }, function(out)
                --print('[vpn timer] out:' .. out)
                local was_connected = ui.vpn_icon.opacity == 1
                local is_connected = string.match(out, "openconnect") ~= nil
                if is_connected then
                    ui.vpn_icon.opacity = 1
                    ui.vpn_tooltip.text = "VPN is connected"
                else
                    ui.vpn_icon.opacity = 0.2
                    ui.vpn_tooltip.text = "VPN is NOT connected"
                end
                if is_connected ~= was_connected then
                    ui.vpn_icon:emit_signal("widget::redraw_needed")
                end
            end)
        end,
    })
end

-- JIRA
local jira_file = home_dir .. "/.local/share/jiraworklogger/current"
jira_file_handle = io.open(jira_file)
ui.has_jira = jira_file_handle ~= nil
if ui.has_jira then
    jira_file_handle:close()

    --local tracking_cmd = "head " .. jira_file .. " -n 1"
    local date_cmd = "stat -c %Y " .. jira_file
    local running_cmd = 'pgrep -fc "jiraworklogger\\/worklog\\.py"'

    local update_worklog = function(widget, stdout)
        local now = os.time(os.date("*t"))
        local time = (now - tonumber(stdout)) / 60
        local worklog = math.floor((time % 60)) .. "m"
        local c = beautiful.fg_normal
        if time >= 60 then
            time = math.floor(time / 60) -- hours
            worklog = time .. "h " .. worklog

            -- colorize based on tracking time
            if time >= 6 then
                c = beautiful.c_red
            end
        end

        -- colorize based on running jobs
        f = io.popen(running_cmd)
        local jobcount = tonumber(f:read("*a"))
        if jobcount > 0 then
            c = beautiful.c_orange
        end
        f:close()

        widget:set_markup(markup.fg(c, worklog))
    end

    jira = awful.widget.watch(date_cmd, 5, function(widget, stdout, stderr, exitreason, exitcode)
        update_worklog(widget, stdout)
    end)
    jira_widget = wrap_widget(ui.jira, jira)
    jira_tooltip = awful.tooltip({
        objects = { jira_widget },
        timer_function = function()
            -- tracked issue
            local f = io.open(jira_file)
            local issueKey = f:read("*l")
            local issueSummary = f:read("*l") or "N/A"
            f:close()

            -- tracked time
            f = io.popen(date_cmd)
            update_worklog(jira, f:read("*a"))
            f:close()

            return "[" .. issueKey .. "] " .. issueSummary
        end,
    })
    ui.jira = jira_widget
end

-- Separators
local spr_small = wibox.widget.imagebox(beautiful.spr_small)
local spr_very_small = wibox.widget.imagebox(beautiful.spr_very_small)
local spr_right = wibox.widget.imagebox(beautiful.spr_right)
local spr_left = wibox.widget.imagebox(beautiful.spr_left)
local bar = wibox.widget.imagebox(beautiful.bar)
local bottom_bar = wibox.widget.imagebox(beautiful.bottom_bar)

local barcolor = gears.color({
    type = "linear",
    from = { 23 * config.dpi_scaling, 0 },
    to = { 23 * config.dpi_scaling, 23 * config.dpi_scaling },
    stops = { { 0, beautiful.bg_focus }, { 0.8, "#505050" }, { 1, beautiful.bg_urgent } },
})

function ui.at_screen_connect(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.layoutbox_buttons)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(
        s,
        awful.widget.taglist.filter.all,
        awful.util.taglist_buttons,
        { bg_focus = barcolor },
        s.mytaglist_func
    )

    mytaglistcont = wibox.container.background(s.mytaglist, beautiful.bg_focus, gears.shape.rectangle)
    s.mytag = wibox.container.margin(mytaglistcont, 0, 0, 5 * config.dpi_scaling, 5 * config.dpi_scaling)

    -- Systray with margin
    s.mysystray = wibox.widget.systray()
    s.mysystraycont = wibox.container.margin(
        wibox.container.background(s.mysystray, beautiful.bg_focus, gears.shape.rectangle),
        0,
        0,
        5 * config.dpi_scaling,
        5 * config.dpi_scaling
    )

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons, {
        shape = gears.shape.rectangle,
        shape_border_width = 5 * config.dpi_scaling,
        shape_border_color = beautiful.tasklist_bg_normal,
        align = "center",
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 32 * config.dpi_scaling })
    s.mywiboxborder = awful.wibar({
        position = "top",
        screen = s,
        height = 1,
        bg = beautiful.fg_focus,
        x = 0,
        y = (32 * config.dpi_scaling + 1),
    })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
            s.mylayoutbox,
            bottom_bar,
            s.mytag,
            spr_left,
            s.mypromptbox,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
            ui.donotdisturb_widget,
            ui.vpn_widget,
            bottom_bar,
            ui.has_jira and jira_widget or nil,
            ui.has_jira and bottom_bar or nil,
            netdown_widget,
            bottom_bar,
            netup_widget,
            bottom_bar,
            cpu_widget,
            bottom_bar,
            mem_widget,
            bottom_bar,
            volume_widget,
            bottom_bar,
            ui.calendar_widget,
            bottom_bar,
            clock_widget,
            spr_left,
        },
    })

    -- Create the bottom wibox
    s.mybottomwibox =
        awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 32 * config.dpi_scaling })
    s.mybottomwiboxborder = awful.wibar({
        position = "bottom",
        screen = s,
        height = 1,
        bg = beautiful.fg_focus,
        x = 0,
        y = (32 * config.dpi_scaling + 1),
    })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            spr_right,
            s.mysystraycont,
            spr_left,
        },
    })
end

return ui

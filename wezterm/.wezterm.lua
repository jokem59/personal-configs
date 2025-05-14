-- Pull in the wezterm API
local os              = require 'os'
local wezterm         = require 'wezterm'
-- local session_manager = require 'wezterm-session-manager/session-manager'
local act             = wezterm.action
local mux             = wezterm.mux

-- --------------------------------------------------------------------
-- FUNCTIONS AND EVENT BINDINGS
-- --------------------------------------------------------------------

-- Session Manager event bindings
-- See https://github.com/danielcopper/wezterm-session-manager
-- wezterm.on("save_session", function(window) session_manager.save_state(window) end)
-- wezterm.on("load_session", function(window) session_manager.load_state(window) end)
-- wezterm.on("restore_session", function(window) session_manager.restore_state(window) end)

-- Wezterm <-> nvim pane navigation
-- You will need to install https://github.com/aca/wezterm.nvim
-- and ensure you export NVIM_LISTEN_ADDRESS per the README in that repo

local is_linux = function()
    return wezterm.target_triple:find("linux") ~= nil
end

local is_windows = function()
    return wezterm.target_triple:find("x86_64-pc-windows-msvc") ~= nil
end

local is_darwin = function()
    return wezterm.target_triple:find("darwin") ~= nil
end

local move_around = function(window, pane, direction_wez, direction_nvim)
    local result = os.execute("env NVIM_LISTEN_ADDRESS=/tmp/nvim" .. pane:pane_id() .. " " .. wezterm.home_dir .. "/.local/bin/wezterm.nvim.navigator" .. " " .. direction_nvim)
    if result then
		window:perform_action(
            act({ SendString = "\x17" .. direction_nvim }),
            pane
        )
    else
        window:perform_action(
            act({ ActivatePaneDirection = direction_wez }),
            pane
        )
    end
end

wezterm.on("move-left", function(window, pane)
	move_around(window, pane, "Left", "h")
end)

wezterm.on("move-right", function(window, pane)
	move_around(window, pane, "Right", "l")
end)

wezterm.on("move-up", function(window, pane)
	move_around(window, pane, "Up", "k")
end)

wezterm.on("move-down", function(window, pane)
	move_around(window, pane, "Down", "j")
end)

local vim_resize = function(window, pane, direction_wez, direction_nvim)
	local result = os.execute(
		"env NVIM_LISTEN_ADDRESS=/tmp/nvim"
			.. pane:pane_id()
			.. " "
            .. wezterm.home_dir
			.. "/.local/bin/wezterm.nvim.navigator"
			.. " "
			.. direction_nvim
	)
	if result then
		window:perform_action(act({ SendString = "\x1b" .. direction_nvim }), pane)
	else
		window:perform_action(act({ ActivatePaneDirection = direction_wez }), pane)
	end
end

wezterm.on("resize-left", function(window, pane)
	vim_resize(window, pane, "Left", "h")
end)

wezterm.on("resize-right", function(window, pane)
	vim_resize(window, pane, "Right", "l")
end)

wezterm.on("resize-up", function(window, pane)
	vim_resize(window, pane, "Up", "k")
end)

wezterm.on("resize-down", function(window, pane)
	vim_resize(window, pane, "Down", "j")
end)

-- --------------------------------------------------------------------
-- CONFIGURATION
-- --------------------------------------------------------------------

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

if is_windows() then
    config.default_prog = { 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe' }
end
config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.color_scheme = 'Dracula (Official)'
config.enable_scroll_bar = true
config.enable_wayland = true
-- config.font = wezterm.font('Hack')
config.font = wezterm.font('Roboto Mono')
config.font_size = 16.0
config.window_frame = {
  font = require('wezterm').font 'Roboto Mono',
}
  
config.hide_tab_bar_if_only_one_tab = true
-- The leader is similar to how tmux defines a set of keys to hit in order to
-- invoke tmux bindings. Binding to ctrl-a here to mimic tmux
config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 2000 }
config.mouse_bindings = {
    -- Open URLs with Ctrl+Click
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = act.OpenLinkAtMouseCursor,
    }
}
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000
config.use_dead_keys = false
config.warn_about_missing_glyphs = false
config.window_decorations = 'TITLE | RESIZE'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Tab bar
-- config.use_fancy_tab_bar = true
-- config.tab_bar_at_bottom = true
-- config.switch_to_last_active_tab_when_closing_tab = true
-- config.tab_max_width = 32
-- config.colors = {
--     tab_bar = {
--         active_tab = {
--             fg_color = '#073642',
--             bg_color = '#2aa198',
--         }
--     }
-- }

-- Setup muxing by default
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- Custom key bindings
config.keys = {
    -- -- Disable Alt-Enter combination (already used in tmux to split pane)
    -- {
    --     key = 'Enter',
    --     mods = 'ALT',
    --     action = act.DisableDefaultAssignment,
    -- },

    -- Copy mode
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode,
    },

    -- ----------------------------------------------------------------
    -- TABS
    --
    -- Where possible, I'm using the same combinations as I would in tmux
    -- ----------------------------------------------------------------

    -- Show tab navigator; similar to listing panes in tmux
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ShowTabNavigator,
    },
    -- Create a tab (alternative to Ctrl-Shift-Tab)
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    -- Rename current tab; analagous to command in tmux
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        window:active_tab():set_title(line)
                    end
                end
            ),
        },
    },
    -- ----------------------------------------------------------------
    -- PANES
    --
    -- These are great and get me most of the way to replacing tmux
    -- entirely, particularly as you can use "wezterm ssh" to ssh to another
    -- server, and still retain Wezterm as your terminal there.
    -- ----------------------------------------------------------------

    -- -- Vertical split
    {
        -- |
        key = '|',
        mods = 'LEADER|SHIFT',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 },
        },
    },
    -- Horizontal split
    {
        -- -
        key = '-',
        mods = 'LEADER',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 50 },
        },
    },
    -- macos: Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    {
        key = 'LeftArrow',
        mods = 'OPT',
        action = act.SendKey {
          key = 'b',
          mods = 'ALT',
        },
    },
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = act.SendKey {
            key = 'f',
            mods = 'ALT'
        },
    },
    -- Paste from clipboard; useful for pasting in general or in helix insert modes
    {
        key = 'y',
        mods = 'CTRL',
        action = act.PasteFrom('Clipboard'),
    },
    -- MacOS specific binding to delete next word (Cmd-d to M-d)
    {
      key = 'd',
      mods = 'CMD',
      action = act.SendKey {
        key = 'd',
        mods = 'ALT',
      },
    },
    -- Quick select of panes, like tmux Leader + q
    -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
    -- { key = 'q', mods = 'LEADER', action = act.PaneSelect },
    -- activate pane selection mode with numeric labels
    {
        key = 'q',
        mods = 'LEADER',
        action = act.PaneSelect {
            alphabet = '1234567890',
        },
    },

    -- ALT + (h,j,k,l) to resize panes
    {
        key = 'h',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-left" }),
    },
    {
        key = 'j',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-down" }),
    },
    {
        key = 'k',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-up" }),
    },
    {
        key = 'l',
        mods = 'ALT',
        action = act({ EmitEvent = "resize-right" }),
    },
    -- Close/kill active pane
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = true },
    },
    -- Swap active pane with another one
    {
        key = '{',
        mods = 'LEADER|SHIFT',
        action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" },
    },
    -- Move to next/previous pane
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivatePaneDirection('Prev'),
    },
    {
        key = 'o',
        mods = 'LEADER',
        action = act.ActivatePaneDirection('Next'),
    },

    -- ----------------------------------------------------------------
    -- Workspaces
    --
    -- These are roughly equivalent to tmux sessions.
    -- ----------------------------------------------------------------

    -- Attach to muxer
    {
        key = 'a',
        mods = 'LEADER',
        action = act.AttachDomain 'unix',
    },

    -- Detach from muxer
    {
        key = 'd',
        mods = 'LEADER',
        action = act.DetachDomain { DomainName = 'unix' },
    },

    -- Show list of workspaces
    {
        key = 's',
        mods = 'LEADER',
        action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
    },
    -- Rename current session; analagous to command in tmux
    {
        key = '$',
        mods = 'LEADER|SHIFT',
        action = act.PromptInputLine {
            description = 'Enter new name for session',
            action = wezterm.action_callback(
                function(window, pane, line)
                    if line then
                        mux.rename_workspace(
                            window:mux_window():get_workspace(),
                            line
                        )
                    end
                end
            ),
        },
    },

    -- Session manager bindings
    {
        key = 's',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "save_session" }),
    },
    {
        key = 'L',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "load_session" }),
    },
    {
        key = 'R',
        mods = 'LEADER|SHIFT',
        action = act({ EmitEvent = "restore_session" }),
    },
}

-- Add numbered shortcuts for TAB
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1),
  })
end

-- tab bar style
-- -- The filled in variant of the < symbol
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.nf_ple_upper_left_triangle
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle

-- The filled in variant of the > symbol
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.nf_ple_upper_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
local SLASH = wezterm.nerdfonts.fae_slash
local ARROW_EXPAND_RIGHT = wezterm.nerdfonts.md_arrow_expand_right

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end
config.use_fancy_tab_bar = false
config.tab_max_width = 1600
config.tab_bar_at_bottom = true

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
	local edge_background = "#2a2a40"
	local background = "#2a2a40"
	local foreground = "#808080"

	if tab.is_active then
		background = "#0a0a23"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#1b1b32"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = "  " .. tab.tab_index + 1 .. " " .. ARROW_EXPAND_RIGHT .. " " .. title .. "  " },
		{ Background = { Color = edge_foreground } },
		{ Foreground = { Color = "#909090" } },
		{ Text = SLASH },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- and finally, return the configuration to wezterm
return config

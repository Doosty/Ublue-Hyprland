local config = {}

config.fps = 60
config.max_log_items = 800
config.message_timeout = 5
config.mouse_wheel_scroll = 50 * SCALE
config.animate_drag_scroll = false
config.scroll_past_end = true
---@type "expanded" | "contracted" | false @Force the scrollbar status of the DocView
config.force_scrollbar_status = false
config.file_size_limit = 10
config.ignore_files = {
  -- folders
  "^%.svn/",        "^%.git/",   "^%.hg/",        "^CVS/", "^%.Trash/", "^%.Trash%-.*/",
  "^node_modules/", "^%.cache/", "^__pycache__/",
  -- files
  "%.pyc$",         "%.pyo$",       "%.exe$",        "%.dll$",   "%.obj$", "%.o$",
  "%.a$",           "%.lib$",       "%.so$",         "%.dylib$", "%.ncb$", "%.sdf$",
  "%.suo$",         "%.pdb$",       "%.idb$",        "%.class$", "%.psd$", "%.db$",
  "^desktop%.ini$", "^%.DS_Store$", "^%.directory$",
}
config.symbol_pattern = "[%a_][%w_]*"
config.non_word_chars = " \t\n/\\()\"':,.;<>~!@#$%^&*|+=[]{}`?-"
config.undo_merge_timeout = 0.3
config.max_undos = 10000
config.max_tabs = 8
config.always_show_tabs = true
-- Possible values: false, true, "no_selection"
config.highlight_current_line = true
config.line_height = 1.2
config.indent_size = 2
config.tab_type = "soft"
config.keep_newline_whitespace = false
config.line_limit = 80
config.max_project_files = 2000
config.transitions = true
config.disabled_transitions = {
  scroll = false,
  commandview = false,
  contextmenu = false,
  logview = false,
  nagbar = false,
  tabs = false,
  tab_drag = false,
  statusbar = false,
}
config.animation_rate = 1.0
config.blink_period = 0.8
config.disable_blink = false
config.draw_whitespace = false
config.borderless = false
config.tab_close_button = true
config.max_clicks = 3

-- set as true to be able to test non supported plugins
config.skip_plugins_version = false

config.plugins = {}
-- Allow you to set plugin configs even if we haven't seen the plugin before.
setmetatable(config.plugins, {
  __index = function(t, k)
    local v = rawget(t, k)
    if v == true or v == nil then v = {} rawset(t, k, v) end
    return v
  end
})

-- Disable these plugins by default.
config.plugins.trimwhitespace = false
config.plugins.drawwhitespace = false

return config
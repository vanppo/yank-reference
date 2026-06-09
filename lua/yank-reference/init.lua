local M = {}

M.config = { delimiter = "#" }

local VISUAL_MODES = { v = true, V = true, [string.char(22)] = true }

local function line_suffix()
	local mode = vim.fn.mode()

	if mode == "n" then
		return vim.api.nvim_win_get_cursor(0)[1]
	end

	if VISUAL_MODES[mode] then
		local s, e = vim.fn.line("v"), vim.fn.line(".")
		local start_line, end_line = math.min(s, e), math.max(s, e)

		return start_line == end_line and start_line or (start_line .. "-" .. end_line)
	end
end

function M.copy_formatted_path()
	local path = vim.fn.expand("%:.")

	if path == "" then
		return
	end

	local suffix = line_suffix()

	if not suffix then
		return
	end

	vim.fn.setreg("*", "@" .. path .. M.config.delimiter .. suffix)
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M

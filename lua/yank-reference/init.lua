local M = {}

M.config = {}

function M.copy_formatted_path()
	local mode = vim.fn.mode()
	local path = vim.fn.expand("%:.")
	if path == "" then
		return
	end

	local start_line, end_line

	if mode == "n" then
		start_line = vim.api.nvim_win_get_cursor(0)[1]
		end_line = start_line
	elseif mode == "v" or mode == "V" or mode == "\22" then
		local s = vim.fn.line("v")
		local e = vim.fn.line(".")
		start_line = math.min(s, e)
		end_line = math.max(s, e)
	else
		return
	end

	local line_suffix = start_line == end_line and start_line or (start_line .. "-" .. end_line)
	vim.fn.setreg("*", "@" .. path .. "#" .. line_suffix)
end

function M.setup(opts) end

return M

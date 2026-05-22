vim.api.nvim_create_user_command("YankReference", function()
	require("yank-reference").copy_formatted_path()
end, { desc = "Yank Reference" })

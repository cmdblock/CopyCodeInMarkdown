local config = require("markdown_code_copy.config")

local M = {}

local function find_code_block_bounds()
	if vim.bo.filetype ~= "markdown" then
		vim.notify("markdown-code-copy: not a markdown file", vim.log.levels.WARN)
		return nil, nil
	end

	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local total_lines = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, total_lines, false)

	-- 向上搜索代码块起始行
	local start_line = nil
	for i = cursor_line, 1, -1 do
		if lines[i]:match("^%s*```") then
			start_line = i
			break
		end
	end

	if not start_line then
		vim.notify("markdown-code-copy: not inside a code block", vim.log.levels.WARN)
		return nil, nil
	end

	-- 向下搜索代码块结束行
	local end_line = nil
	for i = cursor_line + 1, total_lines do
		if lines[i]:match("^%s*```%s*$") then
			end_line = i
			break
		end
	end

	if not end_line then
		vim.notify("markdown-code-copy: code block not closed", vim.log.levels.WARN)
		return nil, nil
	end

	-- 确保光标确实在代码块内部（不在 ``` 行本身）
	if cursor_line <= start_line or cursor_line >= end_line then
		vim.notify("markdown-code-copy: move cursor inside the code block", vim.log.levels.WARN)
		return nil, nil
	end

	return start_line, end_line
end

function M.copy_code_block()
	local start_line, end_line = find_code_block_bounds()
	if not start_line or not end_line then
		return
	end

	local total_lines = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, total_lines, false)

	-- 提取代码内容（排除起始和结束的 ``` 行）
	local code_lines = {}
	for i = start_line + 1, end_line - 1 do
		table.insert(code_lines, lines[i])
	end

	if #code_lines == 0 then
		vim.notify("markdown-code-copy: code block is empty", vim.log.levels.WARN)
		return
	end

	local code_text = table.concat(code_lines, "\n")
	vim.fn.setreg(config.options.register, code_text)

	vim.notify(
		string.format("markdown-code-copy: copied %d lines to register '%s'", #code_lines, config.options.register),
		vim.log.levels.INFO
	)
end

function M.select_code_block()
	local start_line, end_line = find_code_block_bounds()
	if not start_line or not end_line then
		return
	end

	local total_lines = vim.api.nvim_buf_line_count(0)
	local lines = vim.api.nvim_buf_get_lines(0, 0, total_lines, false)

	-- 计算选中范围（排除 ``` 行）
	local select_start = start_line + 1
	local select_end = end_line - 1

	if select_start > select_end then
		vim.notify("markdown-code-copy: code block is empty", vim.log.levels.WARN)
		return
	end

	-- 进入 visual line 模式并选中代码块内容
	vim.api.nvim_win_set_cursor(0, { select_start, 0 })
	vim.cmd("normal! V")
	vim.api.nvim_win_set_cursor(0, { select_end, #lines[select_end] })
end

function M.setup(opts)
	config.setup(opts)

	-- 注册命令
	vim.api.nvim_create_user_command("MarkdownCodeCopy", function()
		M.copy_code_block()
	end, { desc = "Copy current markdown code block" })

	vim.api.nvim_create_user_command("MarkdownCodeSelect", function()
		M.select_code_block()
	end, { desc = "Select current markdown code block" })
end

return M

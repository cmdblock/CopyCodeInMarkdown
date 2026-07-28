-- 插件加载入口
-- 当用户通过 require("markdown_code_copy").setup() 调用时，init.lua 会被加载
-- 此文件确保插件在 Neovim 启动时正确初始化

if vim.fn.has("nvim-0.8") == 0 then
	vim.notify("markdown-code-copy requires Neovim >= 0.8", vim.log.levels.ERROR)
	return
end

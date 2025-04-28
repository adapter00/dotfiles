local vim = vim

local extra_vim = vim.fn.getenv("$EXTRA_VIM")

if extra_vim then
    for _, path in ipairs(vim.fn.split(extra_vim,':')) do
        vim.cmd("source " .. path)
    end
end

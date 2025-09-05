-- OPTIONS
local set = vim.opt

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs 
set.tabstop = 4 -- 1 tab = 4 spasi (visual)
set.shiftwidth = 2 -- indent otomatis = 4 spasi
set.softtabstop = 4    -- pencet Tab di insert mode = 4 spasi
set.expandtab = true   -- Tab = spasi (bukan karakter tab asli)
set.smartindent = true -- auto indent cerdas

set.swapfile = false 
set.backup = false

set.clipboard = "unnamedplus"

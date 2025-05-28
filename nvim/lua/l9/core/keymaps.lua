-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<M-O>", "<cmd>:OrganizeImports<CR>", { desc = "Organize Imports" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

local opts = { noremap = true, silent = true }

-- Normal-mode commands
keymap.set("n", "<M-j>", ":MoveLine(1)<CR>", opts)
keymap.set("n", "<M-k>", ":MoveLine(-1)<CR>", opts)
keymap.set("n", "<M-h>", ":MoveHChar(-1)<CR>", opts)
keymap.set("n", "<M-l>", ":MoveHChar(1)<CR>", opts)
keymap.set("n", "<M-L>", ":MoveWord(1)<CR>", opts)
keymap.set("n", "<M-H>", ":MoveWord(-1)<CR>", opts)

-- visual-mode commands
keymap.set("v", "<M-j>", ":MoveBlock(1)<CR>", opts)
keymap.set("v", "<M-k>", ":MoveBlock(-1)<CR>", opts)
keymap.set("v", "<M-h>", ":MoveHBlock(-1)<CR>", opts)
keymap.set("v", "<M-l>", ":MoveHBlock(1)<CR>", opts)

-- delete without copy
keymap.set("n", "d", '"_d', { desc = "Delete without copy" })

--replace without copy
keymap.set("n", "s", '"_s', { desc = "Replace without copy" })

keymap.set("n", "<leader>re", function()
	vim.diagnostic.open_float(nil, { scope = "line" })
end, { desc = "Open diagnostic float for the current line" })

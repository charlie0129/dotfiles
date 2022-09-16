local Remap = require("theprimeagen.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

xnoremap("<leader>p", "\"_dP")

inoremap("<C-c>", "<Esc>")

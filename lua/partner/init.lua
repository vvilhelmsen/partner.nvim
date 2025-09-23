local M = {}

local defaults = {
	storage_path = nil,
	keymaps = {},
	notify = function(msg, level)
		vim.notify("partner.nvim: " .. msg, level or vim.log.levels.INFO)
	end,
}

local cfg = vim.deepcopy(defaults)
local state = {
	awaiting = nil, -- abs path first file
	pairs = {},    -- bidirectional map: abs_path -> partner_abs_path
}


local function abspath_current()
	local p = vim.api.nvim_buf_get_name(0)
	if p == "" then return nil end
	return vim.fn.fnamemodify(p, ":p")
end

local function short(p)
	return vim.fn.fnamemodify(p, ":t")
end

local function ensure_parent_dir(path)
	local parent = vim.fn.fnamemodify(path, ":h")
	if parent ~= "" then vim.fn.mkdir(parent, "p") end
end

local function load_pairs()
	local path = cfg.storage_path
	if not path or vim.fn.filereadable(path) ~= 1 then
		state.pairs = {}
		return
	end

	local ok, content = pcall(vim.fn.readfile, path)
	if not ok or not content or #content == 0 then
		state.pairs = {}
		return
	end

	local text = table.concat(content, "\n")
	local ok2, data = pcall(vim.json.decode, text)
	if ok2 and type(data) == "table" then
		state.pairs = data
	else
		state.pairs = {}
	end
end

local function save_pairs()
	if not cfg.storage_path then return end
	ensure_parent_dir(cfg.storage_path)
	local ok, encoded = pcall(vim.json.encode, state.pairs)
	if not ok then
		return cfg.notify("Failed to encode pairs.json", vim.log.levels.ERROR)
	end
	local write_ok = pcall(vim.fn.writefile, { encoded }, cfg.storage_path)
	if not write_ok then
		cfg.notify("Failed to write pairs.json", vim.log.levels.ERROR)
	end
end

local function set_pair(a, b)
	-- either side already has a partner -> unhook it firstr
	local old_a = state.pairs[a]
	if old_a and state.pairs[old_a] == a then
		state.pairs[old_a] = nil
	end
	local old_b = state.pairs[b]
	if old_b and state.pairs[old_b] == b then
		state.pairs[old_b] = nil
	end
	state.pairs[a] = b
	state.pairs[b] = a
end

local function jump_to(path)
	if not path then return end
	vim.cmd.edit(vim.fn.fnameescape(path))
end

function M.setup(opts)
	cfg = vim.tbl_deep_extend("force", defaults, opts or {})
	if not cfg.storage_path then
		local base = vim.fn.stdpath("data") .. "/partner.nvim"
		vim.fn.mkdir(base, "p")
		cfg.storage_path = base .. "/pairs.json"
	end
	load_pairs()

	if cfg.keymaps.add_or_arm then
		vim.keymap.set("n", cfg.keymaps.add_or_arm, M.add_or_arm,
			{ desc = "partner: add/arm pairing", silent = true })
	end
	if cfg.keymaps.toggle then
		vim.keymap.set("n", cfg.keymaps.toggle, M.toggle,
			{ desc = "partner: toggle partner", silent = true })
	end
end

function M.add_or_arm()
	local here = abspath_current()
	if not here then
		return cfg.notify("Current buffer has no file path; save it first.", vim.log.levels.WARN)
	end

	if not state.awaiting then
		state.awaiting = here
		return cfg.notify("File armed.")
	end

	local first = state.awaiting
	state.awaiting = nil
	local there = here

	if first == there then
		return cfg.notify("Same file; pairing ignored.", vim.log.levels.WARN)
	end

	set_pair(first, there)
	save_pairs()
	cfg.notify(("%s and %s are now partners!"):format(short(first), short(there)))
end

function M.toggle()
	local here = abspath_current()
	if not here then
		return cfg.notify("Unsaved buffer has no partner. Save first.", vim.log.levels.WARN)
	end

	local there = state.pairs[here]
	if not there then
		return cfg.notify("No partner for this file.", vim.log.levels.WARN)
	end

	jump_to(there)
end

return M

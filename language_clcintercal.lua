-- mod-version:3
-- Lite XL syntax highlighting plugin for CLC-INTERCAL
local syntax = require "core.syntax"

syntax.add {
  name = "CLC-INTERCAL",
  -- Extensions derived from CLC-INTERCAL source examples
  files = { "%.i$", "%.si$", "%.ti$", "%.ni$", "%.gi$", "%.li$", "%.ri$" },
  comment = "PLEASE NOTE",
  
  patterns = {
    -- Comments start at NOTE / PLEASE NOTE and end when an empty line (^%s*$) is reached
    { pattern = "DO%sNOTE.*",                type = "comment" },
    { pattern = { "PLEASE%sNOTE%:", "^\n" }, type = "comment" },
    { pattern = { "NOTE%:", "^\n" }, type = "comment" },
    
    -- INTERCAL variables (spot, twospot, tail, hybrid followed by digits)
    { pattern = "%.%d+", type = "variable" },
    { pattern = ":%d+", type = "variable" },
    { pattern = ",%d+", type = "variable" },
    { pattern = ";%d+", type = "variable" },

    -- INTERCAL constants (mesh/pound sign followed by digits)
    { pattern = "%d+", type = "number" },
    
    -- Strings (for any extensions that might use spark/rabbit-ears directly)
    { pattern = { '"', '"', '\\' }, type = "string" },
    --{ pattern = { "'", "'", '\\' }, type = "string" },
    
    -- Unary and binary operators (mingle, select, logicals)
    { pattern = "[~&V¢¥?]", type = "operator" },
   { pattern = "[%a_][%w_]*",                      type = "symbol"   },
  },
  
  symbols = {
    -- Single-word keywords and components of multi-word commands
    ["DO"] = "keyword",
    -- ["DON'T"] = "keyword",
    ["PLEASE"] = "keyword",
    ["COME"] = "keyword2",
    ["FROM"] = "keyword2",
    ["GO"] = "keyword2",
    ["TO"] = "keyword2",
    ["NEXT"] = "keyword2",
    ["RESUME"] = "keyword2",
    ["FORGET"] = "keyword",
    ["REMEMBER"] = "keyword",
    ["ABSTAIN"] = "keyword",
    ["REINSTATE"] = "keyword",
    ["IGNORE"] = "keyword",
    ["READ"] = "keyword",
    ["OUT"] = "keyword",
    ["WRITE"] = "keyword",
    ["IN"] = "keyword",
    ["CALCULATE"] = "keyword",
    ["STASH"] = "keyword",
    ["RETRIEVE"] = "keyword",
    ["GIVE"] = "keyword",
    ["UP"] = "keyword",
    ["TRICKLE"] = "keyword",
    ["DOWN"] = "keyword",
    ["MAKE"] = "keyword",
    ["BELONG"] = "keyword",
    ["NO"] = "keyword",
    ["LONGER"] = "keyword",
    ["ENSLAVE"] = "keyword",
    ["FREE"] = "keyword",
    ["STUDY"] = "keyword",
    ["GRADUATE"] = "keyword",
    ["ENROL"] = "keyword",
    ["FINISH"] = "keyword",
    ["DIVERSION"] = "keyword",
    ["DESTROY"] = "keyword",
    ["CREATE"] = "keyword",
    ["SWAP"] = "keyword",
    ["REOPEN"] = "keyword",
    ["NOT"] = "keyword",
    ["BY"] = "keyword",
    ["AS"] = "keyword2",
    ["CONVERT"] = "keyword2",
  }
}

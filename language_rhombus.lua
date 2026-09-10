-- mod-version:3
-- Rhombus language plugin for lite-xl
-- Converted from rhombus_tmLanguage.json (TextMate grammar)
--
-- Note: lite-xl's tokenizer uses plain Lua string patterns, not full
-- regular expressions, so the original grammar's unicode property
-- classes (\p{L}, \p{S}, ...), lookaheads/lookbehinds, and the very
-- elaborate numeric-literal regexes (rationals, complex numbers,
-- #e/#i exactness prefixes, per-radix exponents, etc.) can't be
-- carried over mechanically. This file re-implements the same set of
-- token categories -- comments, strings, chars, numbers, booleans,
-- keywords, operators, symbols/annotations -- using the closest
-- practical Lua-pattern equivalents.

local syntax = require "core.syntax"

syntax.add {
  name = "Rhombus",
  files = { "%.rhm$" },
  comment = "//",

  patterns = {
    -- #lang line
    { pattern = "^#lang.*",                        type = "keyword"  },

    -- comments
    { pattern = "//.*",                             type = "comment" },
    { pattern = { "/%*", "%*/" },                   type = "comment" },
    { pattern = "#!/.*",                            type = "comment" },
    { pattern = "#!%s.*",                           type = "comment" },
    { pattern = "#//",                              type = "comment" },

    -- strings
    { pattern = { '#rx"', '"', '\\' },              type = "string"  },
    { pattern = { "#rx'", "'", '\\' },               type = "string"  },
    { pattern = { '#"', '"', '\\' },                type = "string"  },
    { pattern = { '"', '"', '\\' },                 type = "string"  },

    -- character literals: #\a  #\space  #\u0041  #\o012 ...
    { pattern = "#\\[%a][%w]*",                     type = "string"  },
    { pattern = "#\\.",                             type = "string"  },

    -- booleans / other #-constants
    { pattern = "#true",                            type = "literal" },
    { pattern = "#false",                           type = "literal" },

    -- numbers (hex / oct / bin / decimal, with optional radix/exactness
    -- prefixes, decimals, fractions, and leading sign)
    { pattern = "#[xX]#?[eEiI]?[%-%+]?[%x]+%.?[%x]*",  type = "number" },
    { pattern = "#[oO]#?[eEiI]?[%-%+]?[0-7]+%.?[0-7]*", type = "number" },
    { pattern = "#[bB]#?[eEiI]?[%-%+]?[01]+%.?[01]*",   type = "number" },
    { pattern = "#[eEiI]?#?[dD]?[%-%+]?%d+/%d+",       type = "number" },
    { pattern = "#[eEiI]?#?[dD]?[%-%+]?%d+%.%d+",      type = "number" },
    { pattern = "#[eEiI]?#?[dD]?[%-%+]?%.%d+",         type = "number" },
    { pattern = "#[eEiI]?#?[dD]?[%-%+]?%d+",           type = "number" },
    { pattern = "[%-%+]?%d+/%d+",                      type = "number" },
    { pattern = "[%-%+]?%d+%.%d+",                     type = "number" },
    { pattern = "[%-%+]?%.%d+",                        type = "number" },
    { pattern = "[%-%+]?%d+%.?",                       type = "number" },

    -- operator keyword: ...
    { pattern = "%.%.%.",                           type = "keyword2" },

    -- symbol / operator forms: #'name
    { pattern = "#'[%a_][%w_]*",                    type = "operator" },

    -- annotation-style keyword: ~name
    { pattern = "~[%a_][%w_]*",                     type = "keyword"  },

    -- type annotation operator
    { pattern = "::",                               type = "operator" },

    -- general operators / punctuation
    { pattern = "[%(%)%[%]{}]",                     type = "normal"   },
    { pattern = "[%+%-=/%*%^%%<>!~|&%.%:;,]",        type = "operator" },

    -- identifiers / keywords / function calls
    { pattern = "[%a_][%w_]*%f[%(]",                type = "function" },
    { pattern = "[%a_][%w_]*",                      type = "symbol"   },
  },

  symbols = {
    -- def/let/fun-style binding forms (storage.type in the original grammar)
    ["def"]         = "keyword2",
    ["let"]         = "keyword2",
    ["fun"]         = "keyword2",
    ["mutable"]     = "keyword2",
    ["recur"]       = "keyword2",

    -- base keywords
    ["import"]      = "keyword",
    ["export"]      = "keyword",
    ["open"]        = "keyword",
    ["defn"]        = "keyword",
    ["macro"]       = "keyword",
    ["class"]       = "keyword",
    ["interface"]   = "keyword",
    ["nonfinal"]    = "keyword",
    ["implements"]  = "keyword",
    ["extends"]     = "keyword",
    ["override"]    = "keyword",
    ["field"]       = "keyword",
    ["constructor"] = "keyword",
    ["immutable"]   = "keyword",
    ["private"]     = "keyword",
    ["internal"]    = "keyword",
    ["property"]    = "keyword",
    ["method"]      = "keyword",
    ["is_a"]        = "keyword",
    ["this"]        = "keyword",
    ["super"]       = "keyword",
    ["block"]       = "keyword",
    ["println"]     = "keyword",
    ["print"]       = "keyword",
    ["values"]      = "keyword",
    ["all_defined"] = "keyword",
    ["use_static"]  = "keyword",
    ["together"]    = "keyword",
    ["annot"]       = "keyword",

    -- control keywords
    ["match"]       = "keyword",
    ["cond"]        = "keyword",
    ["for"]         = "keyword",
    ["if"]          = "keyword",
    ["each"]        = "keyword",
    ["keep_when"]   = "keyword",
  },
}

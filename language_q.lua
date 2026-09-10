-- mod-version:3
-- Lite XL syntax highlighting for q / quke / qdoc
-- Converted from the TextMate grammar "q.tmLanguage.json".
--
-- Notes on the conversion:
--  * Lua patterns are used wherever possible (numbers, punctuation,
--    strings, symbols).
--  * PCRE (`regex = ...`) is used for anything that needs alternation,
--    lookaround or `{m,n}` repetition that Lua patterns can't express
--    (the long built-in/keyword lists, numeric literals with optional
--    exponents, etc). These regex strings are copied close to verbatim
--    from the original grammar's `match` fields.
--  * A handful of very TextMate-specific tricks (matching to literal
--    end-of-buffer for the `\` "exit" comment, splitting a `feature`
--    line into "keyword" + "description" tokens) are simplified to
--    their closest practical Lite XL equivalent.

local syntax = require "core.syntax"

syntax.add {
  name = "q",
  files = { "%.q$" },
  comment = "/",

  patterns = {
    ----------------------------------------------------------------
    -- quke / qdoc BDD-style keywords (x?feature, x?should, ...)
    -- Only meaningful at the start of a line, case-insensitive.
    ----------------------------------------------------------------
    {
      regex = "(?mi)^[ \\t]*x?(?:feature|replicate|timelimit|tolerance|should|bench)\\b",
      type = "function",
    },
    {
      regex = "(?mi)^[ \\t]*x?(?:before each|after each|behaviour|baseline|teardown|property|to match|skip if|expect|before|after|setup)\\b",
      type = "function",
    },

    ----------------------------------------------------------------
    -- comments
    ----------------------------------------------------------------
    -- block comment: a lone "/" on its own line ... a lone "\" on its own line
    { pattern = { "^%s*/%s*\n", "^%s*\\%s*\n" },  type = "comment" },
    -- "exit" comment: a lone "\" on its own line comments out the
    -- rest of the file. There's no real "match to EOF" in Lite XL,
    -- so we terminate on a byte sequence that should never occur,
    -- which in practice consumes everything to the end of the buffer.
    { pattern = { "^%s*\\%s*\n", "\1\1\1\1" },    type = "comment" },
    -- line comment at the start of a line
    { pattern = "^/.-\n",                         type = "comment" },
    -- line comment after whitespace (a bare "/" glued to other text
    -- is the "over" iterator, not a comment)
    { pattern = "%s()/.-\n",                      type = {"normal", "comment"} },

    ----------------------------------------------------------------
    -- strings
    ----------------------------------------------------------------
    { pattern = { '"', '"', '\\' }, type = "string" },

    ----------------------------------------------------------------
    -- literals
    ----------------------------------------------------------------
    -- symbols: `abc, `abc.def, `:path/to/file, `/, etc.
    { regex = "`[/.:\\w]*",                                                          type = "literal" },
    -- datetime / timestamp / date / month
    { regex = "\\d{4}\\.\\d{2}\\.\\d{2}T(?:\\d{2}:){1,2}\\d{2}\\.?\\d*",              type = "number" },
    { regex = "\\d{4}\\.\\d{2}\\.\\d{2}D(?:\\d{2}:){1,2}\\d{2}\\.?\\d*",              type = "number" },
    { pattern = "%d%d%d%d%.%d%d%.%d%d",                                             type = "number" },
    { pattern = "%d%d%d%d%.%d%dm",                                                  type = "number" },
    -- time (with optional leading 0D for elapsed time)
    { regex = "(?:0D)?(?:\\d{2}:){1,2}\\d{2}\\.?\\d*",                               type = "number" },
    -- null / infinity, e.g. 0N, 0Nd, 0w, -0w, 0n
    { regex = "(?:0N[deghjmnptuvz]?|-?0[wW]|0n)",                                    type = "literal" },
    -- binary / byte literals
    { pattern = "[01]+b",                                                           type = "number" },
    { regex = "0x(?:[0-9a-fA-F]{2})+",                                              type = "number" },
    -- general number, with optional exponent and type suffix
    { regex = "-?(?:\\d+\\.\\d+|\\.\\d+|\\d+\\.|\\d+)(?:e[+-]?\\d?\\d)?[jhife]?",     type = "number" },

    ----------------------------------------------------------------
    -- keywords
    ----------------------------------------------------------------
    { regex = "(?<![A-Za-z0-9.])(?:while|if|do)(?![A-Za-z0-9._])",  type = "keyword" },
    { regex = "(?<![A-Za-z0-9.])(?:use|export)(?![A-Za-z0-9._])",  type = "keyword" },

    -- reserved dot-namespace utilities (.h. .j. .m. .Q. .z.)
    {
      regex = "(?<![A-Za-z0-9.])(?:\\.h\\.(?:iso8601|code|edsn|fram|HOME|htac|html|http|logo|text|hta|htc|hug|nbr|pre|val|xmp|br|c0|c1|cd|ed|ha|hb|hc|he|hn|hp|hr|ht|hu|hy|jx|sa|sb|sc|td|tx|ty|uh|xd|xs|xt|d)|\\.j\\.(?:jd|[jk])|\\.m\\.(?:addmonths|dpfts|dsftg|addr|btoa|dpft|hdpf|host|view|chk|def|ens|fmt|fpn|fps|fsn|ind|j10|j12|MAP|opt|par|res|sbt|trp|x10|x12|b6|bt|bv|Cf|cn|dd|en|ff|fk|fs|ft|fu|gc|gz|hg|hp|id|nA|pd|PD|pf|pn|pt|pv|PV|qp|qt|s1|ts|ty|vp|Xf|[aADfklMPsuvVwx])|\\.[Qq]\\.(?:addmonths|dpfts|dsftg|addr|btoa|dpft|hdpf|host|sha1|view|chk|def|ens|fmt|fpn|fps|fsn|ind|j10|j12|MAP|opt|par|res|sbt|trp|x10|x12|b6|bt|bv|Cf|cn|dd|en|fc|ff|fk|fs|ft|fu|gc|gz|hg|hp|id|nA|pd|PD|pf|pn|pt|pv|PV|qp|qt|s1|ts|ty|vp|Xf|[aADfklMPsSuvVwx])|\\.z\\.(?:exit|ac|bm|ex|ey|pc|pd|pg|ph|pi|pm|po|pp|pq|ps|pw|ts|vs|wc|wo|ws|zd|[abcdDefhikKlnNopPqstTuwWxXzZ]))(?![A-Za-z0-9._])",
      type = "keyword2",
    },

    -- built-in keywords / functions
    {
      regex = "(?<![A-Za-z0-9.])(?:reciprocal|distinct|ceiling|reverse|sublist|ungroup|delete|deltas|differ|enlist|except|getenv|hclose|hcount|insert|mcount|ratios|rotate|select|setenv|signum|string|system|tables|update|upsert|within|xgroup|count|cross|dsave|fills|first|fkeys|floor|group|gtime|hopen|idesc|inter|lower|ltime|ltrim|parse|peach|prior|read0|read1|reval|rload|rsave|rtrim|union|upper|value|views|where|while|xcols|xdesc|xprev|xrank|acos|ajf0|asin|asof|atan|attr|avgs|binr|cols|desc|each|eval|exec|exit|flip|from|hdel|hsym|iasc|keys|last|like|load|mavg|maxs|mdev|meta|mins|mmax|mmin|msum|next|null|over|prds|prev|rand|rank|raze|save|scan|scov|sdev|show|sqrt|sums|svar|trim|type|view|wavg|wsum|xasc|xbar|xcol|xexp|xkey|xlog|abs|aj0|ajf|all|and|any|asc|avg|bin|cor|cos|cov|csv|cut|dev|div|ema|exp|fby|get|ijf|inv|key|ljf|log|lsq|max|md5|med|min|mmu|mod|neg|not|prd|set|sin|ssr|sum|tan|til|ujf|var|wj1|aj|by|do|ej|if|ij|in|lj|or|pj|ss|sv|uj|vs|wj)(?![A-Za-z0-9._])",
      type = "keyword2",
    },

    -- generic identifier fallback
    { regex = "(?<![A-Za-z0-9.])\\.?[a-zA-Z][a-zA-Z0-9_]*(?:\\.[a-zA-Z0-9_]+)*(?![A-Za-z0-9._])", type = "symbol" },

    ----------------------------------------------------------------
    -- system commands, e.g. \cd, \ts, \\
    ----------------------------------------------------------------
    { regex = "(?m)^\\\\(?:cd|ts|[abBcCdefglopPrsStTuvwWxz12_\\\\])[^\\n]*", type = "literal" },

    ----------------------------------------------------------------
    -- operators / punctuation
    ----------------------------------------------------------------
    { pattern = "[\\'/]:",                        type = "operator" }, -- each / iterator forms
    { pattern = "<=",                             type = "operator" },
    { pattern = ">=",                             type = "operator" },
    { pattern = "<>",                             type = "operator" },
    { pattern = "[><~=]",                         type = "operator" },
    { pattern = "::",                             type = "operator" },
    { pattern = "_",                              type = "operator" },
    { pattern = "!",                              type = "operator" },
    { pattern = "[%.,'|%^?#@&%%*+%-\\]",           type = "operator" },
    { pattern = "%$",                             type = "operator" },
    { pattern = ":",                              type = "operator" },
    { pattern = ";",                              type = "operator" },
  },

  symbols = {},
}

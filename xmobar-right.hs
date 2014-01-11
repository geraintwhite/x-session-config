Config { font = "Monospace-8"
	, bgColor = "#000000"
	, fgColor = "#ffffff"
	, position = Static { xpos = 1920, ypos = 0, width = 1920, height = 16 }
	, commands = [ Run Weather "EGUW" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
		, Run Com "uname" ["-s","-r"] "" 36000
		, Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
		, Run Com "ruby" ["~/.xmonad/gmail_checker.rb"] "gmail" 600
		, Run Com "~/.xmonad/volume.sh" [] "volume" 10
		, Run StdinReader
		]
	, sepChar = "%"
	, alignSep = "}{"
	, template = "%StdinReader% }{ Volume: %volume% | <fc=#93a1a1>%gmail%</fc> | <fc=#ee9a00>%date%</fc>| %EGUW% | %uname%"
	}

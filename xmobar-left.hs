Config { font = "Monospace-8"
	, bgColor = "#000000"
	, fgColor = "#ffffff"
	, position = Static { xpos = 0, ypos = 0, width = 1728, height = 16 }
	, commands = [ Run Weather "EGUW" ["-t","<station>: <tempC>C","-L","18","-H","25","--normal","green","--high","red","--low","lightblue"] 36000
		, Run Network "eth0" ["-L","0","-H","32","--normal","green","--high","red"] 10
		, Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
		, Run Memory ["-t","Mem: <usedratio>%"] 10
		, Run Swap [] 10
		, Run DiskU [("/", "<used>/<size>"), ("sdb1", "<usedbar>")] ["-L", "20", "-H", "50", "-m", "1", "-p", "3"] 20
		]
	, sepChar = "%"
	, alignSep = "}{"
	, template = "%cpu% | %memory% * %swap% | %eth0% | %disku%"
	}

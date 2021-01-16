game = {}
first = true
hei = 0
wid = 0
rol = "X"
disa = false
wonrol = "X"
function on.paint(gc)
	if first then
		for i=1,3 do
			game[i] = {}
			for j=1,3 do
				game[i][j] = "-"
			end
		end
		first = false
	end
    gc:drawLine(10, 10, 190, 10) -- Oben
	gc:drawLine(10, 10, 10, 190) -- Links
	gc:drawLine(190, 10, 190, 190) -- Rechts
	gc:drawLine(10, 190, 190, 190) -- Unten
	
	gc:drawLine(10, 70, 190, 70) -- Mitte Oben
	gc:drawLine(10, 130, 190, 130) -- Mitte Unten
	
	gc:drawLine(70, 10, 70, 190) -- Mitte Links
	gc:drawLine(130, 10, 130, 190) -- Mitte Rechts
	
	gc:drawRect(210, 80, 60, 40) -- Reset
	
	gc:setFont("sansserif", "r", 10)
	gc:drawString("Dieses Programm", 200, 5, "top")
	gc:drawString("ist von awdWare.de", 200, 25, "top")
	gc:drawString("v1.0.5", 275, 190, "top")
	
	gc:setFont("sansserif", "r", 40)
	gc:drawString(rol, 210, 130, "top")
	gc:setFont("sansserif", "r", 12)
	gc:drawString("reset", 214, 90, "top")
	
	for a=1,3 do
		for b=1,3 do
			if game[a][b] == "-" then
			
			else
				gc:setFont("sansserif", "r", 40)
				gc:drawString(tostring(game[a][b]), 25 + 60 * (a-1), 20 + 60 * (b-1), "top")
			end
		end
	end

	
	if wid < 3 then
		gc:setPen("medium", "dashed")		
		gc:drawRect(10 + 60 * wid,10 + 60 * hei,60,60)
	else
		gc:setPen("medium", "dashed")		
		gc:drawRect(210, 80, 60, 40) -- Reset Aktiv
		hei = 1
	end
	
	if disa then
		gc:setPen("medium", "smooth")
		gc:setColorRGB(255,255,255)
		gc:fillRect(5,5, platform.window.width() - 10, platform.window.height() - 10)
		gc:setColorRGB(0,0,0)
		gc:setFont("sansserif", "r", 40)
		gc:drawString(wonrol .. " won!", 30, 30, "top")
	end
	
end

function on.arrowLeft()
	if not disa then
		if wid > 0 then
			wid = wid - 1
			platform.window:invalidate()
		end
	end
end

function on.arrowRight()
	if not disa then
		if wid < 3 then
			wid = wid + 1
			platform.window:invalidate()
		end
	end
end

function on.arrowUp()
	if not disa then
		if hei > 0 then
			hei = hei - 1
			platform.window:invalidate()
		end
	end
end

function on.arrowDown()
	if not disa then
		if hei < 2 then
			hei = hei + 1
			platform.window:invalidate()
		end
	end
end

function on.enterKey()
	Clicked()
end

function Clicked()
	if not disa then
		if wid < 3 then
			if game[wid + 1][hei + 1] == "-" then
				game[wid + 1][hei + 1] = rol
				CheckWin()
				if rol == "X" then
					rol = "O"
				else
					rol = "X"
				end
			end
			platform.window:invalidate()
		else
			for i=1,3 do
				game[i] = {}
				for j=1,3 do
					game[i][j] = "-"
				end
			end
			wid = 0
			hei = 0
			rol = "X"
			platform.window:invalidate()
		end
	else
		disa = false
		wonrly = false
		for i=1,3 do
			game[i] = {}
			for j=1,3 do
				game[i][j] = "-"
			end
		end
		wid = 0
		hei = 0
		rol = "X"
		platform.window:invalidate()
	end
end

function CheckWin()
	wonrly = false
	for i=1,3 do
		won = true
		for j=1,3 do
			if game[i][j] ~= rol then
				won = false
			end
		end
		if won then
			wonrly = true
		end
	end
	
	if not wonrly then
		for i=1,3 do
			won = true
			for j=1,3 do
				if game[j][i] ~= rol then
					won = false
				end
			end
			if won then
				wonrly = true
			end
		end
	end
	
	if not wonrly then
		if game[1][1] == rol then
			if game[2][2] == rol then
				if game[3][3] == rol then
					wonrly = true
				end
			end
		end
		if game[1][3] == rol then
			if game[2][2] == rol then
				if game[3][1] == rol then
					wonrly = true
				end
			end
		end
	end
	
	if wonrly then
		disa = true
		wonrol = rol
	end
	
end
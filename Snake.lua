game = {}
first = true
start = false
movDir = "right"
LmovDir = "right"
leng = 3
loos = true
needNewCoin = false
highscore = "000000000"
highscore1 = 0
highscore2 = 0
highscore3 = 0
speed = 0.175
resettime = 6
--TMPTEXT = ""
helpactive = false

function on.save()
	return tonumber(highscore)
end
 
function on.restore(data)
	if type(data) == "number" then
		highscore = data
		while string.len(highscore) < 9 do
			highscore = "0"..highscore
		end
	end
end

function on.enterKey()
	if helpactive then
		helpactive = false
		platform.window:invalidate()
	end
end

function on.charIn(ch)
	if helpactive then
		if ch == "r" then
			resettime = resettime - 1
			platform.window:invalidate()
			if resettime == 0 then
				timer.stop()
				highscore = "000000000"
				highscore1 = 0
				highscore2 = 0
				highscore3 = 0
				first = true
				start = false
				movDir = "right"
				LmovDir = "right"
				leng = 3
				loos = true
				needNewCoin = false
				speed = 0.175
				resettime = 6
				helpactive = false
				platform.window:invalidate()
				document.markChanged()
			end
		end
	end
	
	if loos then
		if ch == "1" then
			speed = 0.1
			first = true
			start = true
			loos = false
			platform.window:invalidate()
		elseif ch == "2" then
			speed = 0.175
			first = true
			start = true
			loos = false
			platform.window:invalidate()
		elseif ch == "3" then
			speed = 0.21
			first = true
			start = true
			loos = false
			platform.window:invalidate()
		end
	else
		if ch == "4" and LmovDir~= "right" then movDir = "left" end
		if ch == "6" and LmovDir~= "left" then movDir = "right" end
		if ch == "5" and LmovDir~= "up" then movDir = "down" end
		if ch == "8" and LmovDir~= "down" then movDir = "up" end
	end
end

function on.help()
	helpactive = true
	resettime = 6
	platform.window:invalidate()
end

function on.arrowRight()
	if LmovDir ~= "left" then movDir = "right" end
end

function on.arrowUp()
	if LmovDir ~= "down" then movDir = "up" end
end

function on.arrowDown()
	if LmovDir ~= "up" then movDir = "down" end
end

function on.arrowLeft()
	if LmovDir ~= "right" then movDir = "left" end
end


function on.paint(gc)
	if first then
		highscore1 = tonumber(string.sub(highscore, 1, 3))
		highscore2 = tonumber(string.sub(highscore, 4, 6))
		highscore3 = tonumber(string.sub(highscore, 7, 9))
		for i=0,18 do
			game[i] = {}
			for j=0,18 do
				game[i][j] = 0
			end
		end
		game[3][2] = 1
		game[4][2] = 2
		game[5][2] = 3
		movDir = "right"
		LmovDir = "right"
		leng = 3
		needNewCoin = false
		NewCoin()
		if start then
			loos = false
			start = false
			timer.start(speed)
		end
		first = false
	end
	if helpactive then
		gc:setColorRGB(0,0,0)
		gc:setFont("sansserif", "r", 10)
		gc:drawString("Steuerung mit dem 'Steuerkreuz' oder 4, 5, 6 & 8.", 5, 5, "top")
		gc:drawString("Start mit 1=Schwer, 2=Normal, 3=Leicht.", 5, 25, "top")
		gc:drawString("Zum Reset die R Taste fünfmal drücken.", 5, 45, "top")
		gc:drawString("Zurück zum Spiel mit [enter].", 5, 65, "top")
		if resettime < 6 then
			gc:drawString("Reset in:", 5, 85, "top")
			gc:setFont("sansserif", "r", 25)
			gc:drawString(resettime, 65, 80, "top")
		end
	else		
		gc:setColorRGB(200,200,200)
		gc:drawLine(10, 10 , 190, 10) 
		gc:drawLine(10, 10, 10 , 190) 
		gc:drawLine(10, 190 , 190, 190) 
		gc:drawLine(190, 10, 190 , 190) 
		--for i=0,18 do
			--gc:drawLine(10, 10 + 10 * i, 190, 10 + 10 * i) Komplettes
			--gc:drawLine(10 + 10 * i, 10, 10 + 10 * i, 190) Raster
		--end
		gc:setColorRGB(0,0,0)
		gc:setFont("sansserif", "r", 10)
		gc:drawString("Dieses Programm", 200, 5, "top")
		--gc:drawString(TMPTEXT, 200, 5, "top")
		
		gc:drawString("ist von awdWare.de", 200, 25, "top")
		gc:drawString("v1.1.7", 275, 190, "top")
		gc:drawString("Hilfe: [ctrl]+[trig]", 200, 45, "top")
		gc:setFont("sansserif", "r", 15)
		
		gc:drawString("Score:" .. leng - 3, 195, 70, "top")
		gc:drawString("Highscores:", 195, 105, "top")
		gc:setFont("sansserif", "r", 14)
		gc:drawString(tostring(highscore1), 200, 130, "top")
		gc:drawString(tostring(highscore2), 240, 130, "top")
		gc:drawString(tostring(highscore3), 280, 130, "top")
		
		gc:setFont("sansserif", "r", 8)
		gc:drawString("Schwer", 195, 155, "top")
		gc:drawString("Normal", 235, 155, "top")
		gc:drawString("Leicht", 275, 155, "top")
		
		for i=0,18 do
			for j=0,18 do
				if tonumber(game[i][j]) == leng then
					gc:setColorRGB(57,226,57)
					gc:setPen("thin", "smooth")
					gc:fillRect(10 + 10 * i, 10 + 10 * j, 10, 10)
				elseif tonumber(game[i][j]) > 0 and tonumber(game[i][j]) < leng then
					gc:setColorRGB(20,101,20)
					gc:setPen("thin", "smooth")
					gc:fillRect(10 + 10 * i, 10 + 10 * j, 10, 10)
				elseif tonumber(game[i][j]) == -10 then
					gc:setColorRGB(27,14,166)
					gc:setPen("thin", "smooth")
					gc:fillRect(10 + 10 * i, 10 + 10 * j, 10, 10)
				end
			end
		end
	end
end

function on.timer()
	for i=0,18 do
		for j=0,18 do
			x = i
			y = j
			if movDir == "up" then
				y = y - 1
				LmovDir = "up"
			end
			if movDir == "down" then
				y = y + 1
				LmovDir = "down"
			end
			if movDir == "left" then
				x = x - 1
				LmovDir = "left"
			end
			if movDir == "right" then
				x = x + 1
				LmovDir = "right"
			end
			
			if tonumber(game[i][j]) == leng then
				if x <= 17 and x >= 0 and y <= 17 and y >= 0 then
					if tonumber(game[x][y]) == 0 or tonumber(game[x][y]) == -10 then
						if tonumber(game[x][y]) == -10 then
							leng = leng + 1
								for a=0,18 do
									for b=0,18 do
										if tonumber(game[a][b]) > 0 and tonumber(game[a][b]) < leng then
											game[a][b] = tonumber(game[a][b]) + 1
										end
									end
								end
							needNewCoin = true
						end
						game[i][j] = - 3
						game[x][y] = -5
					else
						Loose()
					end

				else
					Loose()
				end
			end
		end
	end	
	
	for i=0,18 do
		for j=0,18 do
			if not loos then
				if tonumber(game[i][j]) > 0 and tonumber(game[i][j]) < leng then
					game[i][j] = tonumber(game[i][j]) - 1
				elseif tonumber(game[i][j]) == -3 then
					game[i][j] = leng - 1
				end
			end
		end
	end
	
	for i=0,18 do
		for j=0,18 do
			if tonumber(game[i][j]) == -5 then
				game[i][j] = leng
			end
		end
	end
	
	if needNewCoin then
		NewCoin()
		needNewCoin = false
	end
	
	if speed == 0.175 then
		if leng - 3 > highscore2 then
			highscore2 = leng - 3
			document.markChanged()
		end
	elseif speed == 0.1 then
		if leng - 3 > highscore1 then
			highscore1 = leng - 3
			document.markChanged()
		end
	else
		if leng - 3 > highscore3 then
			highscore3 = leng - 3
			document.markChanged()
		end
	end

	platform.window:invalidate()
	if not loos then timer.start(speed) end
end

function Loose()
	loos = true
	timer.stop()
	highscore = ""
	if string.len(highscore1) < 3 then
		if string.len(highscore1) < 2 then
			highscore = highscore .. "00" .. highscore1
		else
			highscore = highscore .. "0" .. highscore1
		end
	else
		highscore = highscore .. highscore1
	end
	if string.len(highscore2) < 3 then
		if string.len(highscore2) < 2 then
			highscore = highscore .. "00" .. highscore2
		else
			highscore = highscore .. "0" .. highscore2
		end
		else
			highscore = highscore .. highscore2
	end
	if string.len(highscore3) < 3 then
		if string.len(highscore3) < 2 then
			highscore = highscore .. "00" .. highscore3
		else
			highscore = highscore .. "0" .. highscore3
		end
		else
			highscore = highscore .. highscore3
	end
end

function NewCoin()
	finRndm = false
	while not finRndm do
		RndmX = math.random(0,17)
		RndmY = math.random(0,17)
		if tonumber(game[RndmX][RndmY]) == 0 then
			game[RndmX][RndmY] = -10
			finRndm = true
		end
	end
end
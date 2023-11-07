require "src.libs.luafft"
themes = require("src.tools.themes")
local spectrum = {}

abs = math.abs
new = complex.new
UpdateSpectrum = false

wave_size=1
types=1
color = themes[selectedTheme].color

Size = 1024
Frequency = 44100
length = Size / Frequency
spectrumDir = 1 -- -1 for up


function devide(list, factor)
  for i,v in ipairs(list) do list[i] = list[i] * factor end
end

function spectro_up(obj,sdata)

ScreenSizeW = love.graphics.getWidth()
ScreenSizeH = love.graphics.getHeight()
spectrumY = ScreenSizeH/2 -- ScreenSizeH

local MusicPos = obj:tell("samples") 
local MusicSize = sdata:getSampleCount() 

if MusicPos >= MusicSize - 1536 then wave_size=2 mtime=0 timecolor=nil love.audio.rewind(sound) end 

local List = {} 
for i= MusicPos, MusicPos + (Size-1) do
   CopyPos = i
   if i + 2048 > MusicSize then i = MusicSize/2 end 

   if sdata:getChannelCount()==1 then
      List[#List+1] = new(sdata:getSample(i), 0) 
    else
      List[#List+1] = new(sdata:getSample(i*2), 0) 
   end

end
spectrum = fft(List, false) 
devide(spectrum, wave_size) 
UpdateSpectrum = true
end

function spectro_show(dir)

  love.graphics.setColor(color)

    if UpdateSpectrum then
    for i = 1, #spectrum do
      if types==1 then 	
        love.graphics.rectangle("line", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      elseif types==2 then
      	love.graphics.ellipse("line", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      elseif types==3 then
        love.graphics.rectangle("line", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      	love.graphics.rectangle("fill", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      elseif types==4 then
      	love.graphics.ellipse("fill", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      elseif types==5 then
      	love.graphics.ellipse("line", i*7, spectrumY, 7, dir * wave_size*(spectrum[i]:abs())) 
      end
    end
    end     
end


function spectrum.load()
	soundData = love.sound.newSoundData("assets/audio/LetHerGO.mp3")
	sound = love.audio.newSource(soundData)
	sound:play()
	love.mouse.setVisible(false)
end

time=0
mtime=0

function spectrum.keyreleased(key)
   if key == "escape" then
      love.event.quit()
   end
end

function spectrum.update(dt)

	time=time+dt
	mtime=mtime+dt

	if math.floor(time)>=10 then 
		types=math.random(1,5) 
		time=0
		if mtime>194 then types=math.random(4,5) end
	end

	if mtime>194.5 then timecolor=true end

	if mtime>194.5 and mtime<200 then types=4 end

	if timecolor then
	wave_size=math.random(7)
	color={math.random(255),math.random(255),math.random(255)}
	end

	spectro_up(sound,soundData)
end

function spectrum.draw()
    spectro_show(-spectrumDir)
	spectro_show(spectrumDir)
end

return spectrum


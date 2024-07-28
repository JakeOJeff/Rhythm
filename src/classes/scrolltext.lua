-- scrollingText.lua

local ScrollingText = {}

function ScrollingText.new(text, screenWidth, scrollSpeed)
    local self = {}

    self.text = text
    self.screenWidth = screenWidth or love.graphics.getWidth()
    self.scrollSpeed = scrollSpeed or 50
    self.displayedText = ""
    self.offset = 0
    self.direction = 1

    function self:update(dt)
        -- Update the offset to create the scrolling effect
        self.offset = self.offset + self.direction * self.scrollSpeed * dt

        -- Change direction when reaching the beginning or end
        if self.offset < 0 or self.offset > (#self.text - self.screenWidth / 8) * 8 then
            self.direction = -self.direction
        end

        -- Calculate the start index based on the offset
        local startIndex = math.floor(self.offset / 8) + 1

        -- Extract the substring to be displayed
        self.displayedText = self.text:sub(startIndex, startIndex + self.screenWidth / 8)
    end

    function self:returntext()
        -- Draw the displayed text
        return self.displayedText
    end

    return self
end

return ScrollingText
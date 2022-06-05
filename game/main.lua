screen_height = 320
screen_width = 480
max_meteors = 6
game_over = false

spaceship = {
    src = 'assets/14bis.png',
    height = 63,
    width = 55,
    x = screen_width / 2 - 64 / 2,
    y = screen_height - 64 / 2,
    shoots = {}
}

meteors = {}

function create_meteor()
    meteor = {
        src = 'assets/meteor.png',
        x = math.random(0, screen_width),
        y = -70,
        width = 50,
        height = 44,
        weight = math.random(1, 3),
        horizontal_speed = math.random(-1, 1)
    }

    table.insert(meteors, meteor)
end

function move_meteor()
    for k, meteor in pairs(meteors) do
        meteor.y = meteor.y + meteor.weight
        meteor.x = meteor.x + meteor.horizontal_speed
    end
end

function remove_meteor()
    for i = #meteors, 1, -1 do
        if (meteors[i].y > screen_height) then
            table.remove(meteors, i)
        end
    end
end

function move_spaceship()
    if love.keyboard.isDown('w') then
        spaceship.y = spaceship.y - 1
    end

    if love.keyboard.isDown('s') then
        spaceship.y = spaceship.y + 1
    end

    if love.keyboard.isDown('a') then
        spaceship.x = spaceship.x - 1
    end

    if love.keyboard.isDown('d') then
        spaceship.x = spaceship.x + 1
    end
end

function has_colision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x2 < x1 + w1 and
           x1 < x2 + w2 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function check_colision()
    for i = #meteors, 1, -1 do
        if has_colision(spaceship.x, spaceship.y, spaceship.width, spaceship.height, meteors[i].x, meteors[i].y, meteors[i].width, meteors[i].height) then
            spaceship.src = 'assets/explosao_nave.png'
            spaceship.image = love.graphics.newImage(spaceship.src)
            spaceship.width = spaceship.image:getWidth()
            spaceship.height = spaceship.image:getHeight()

            table.remove(meteors, i)

            env_music:stop()
            destroy_music:play()
            game_over_music:play()

            game_over = true
        end
    end
end

function shoot()
    local shoot = {
        x = spaceship.x,
        y = spacheship.y,
        width = 16,
        height = 16
    }

    table.insert(spaceship.shoots, shoot)
end

function move_shoots()
    for i = #spaceship.shoots, 1, -1 do
        if spaceship.shoots[i].y > 0 then
            spaceship.shoots[i].y = spaceship.shoots[i].y - 1
        else
            table.remove(spaceship.shoots, i)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        shoot()
    end
end

-- Load some default values for our rectangle.
function love.load()
    love.window.setMode(screen_height, screen_width, { resizable = false })
    love.window.setTitle('Armagedon')
   
    math.randomseed(os.time())

    background_img = love.graphics.newImage('assets/background.png')
    spaceship.image = love.graphics.newImage(spaceship.src)
    meteor_img = love.graphics.newImage('assets/meteoro.png')
    shoot_img = love.graphics.newImage('assets/tiro.png')

    env_music = love.audio.newSource('assets/audios/ambiente.wav', 'static')
    env_music:setLooping(true)
    env_music:play()
    
    destroy_music = love.audio.newSource('assets/audios/destruicao.wav', 'static')
    game_over_music = love.audio.newSource('assets/audios/game_over.wav', 'static')
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    if not game_over then
        if love.keyboard.isDown('w', 's', 'a', 'd') then
            move_spaceship()
        end

        remove_meteor()

        if #meteors < max_meteors then
            create_meteor()
        end

        move_meteor()

        check_colision() 
    end
end

-- Draw a coloured rectangle.
function love.draw()
    -- In versions prior to 11.0, color component values are (0, 102, 102)
    love.graphics.draw(background_img, 0, 0)
    love.graphics.draw(spaceship.image, spaceship.x, spaceship.y)
    
    for k, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end

    for k, shoot in pairs(spaceship.shoots) do
        love.graphics.draw(shoot_img, shoot.x, shoot.y)
    end
end
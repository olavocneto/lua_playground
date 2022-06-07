screen_height = 320
screen_width = 480
max_meteors = 6
game_over = false
winner = false
meteors_hit = 0
target_meteor_number = 10

spaceship = {
    src = 'assets/14bis.png',
    height = 63,
    width = 55,
    x = screen_width / 2 - 64 / 2,
    y = screen_height - 64 / 2,
    shots = {}
}

meteors = {}

function shot()
    shot_music:play()

    local shot = {
        x = spaceship.x + spaceship.width / 2,
        y = spaceship.y,
        width = 16,
        height = 16
    }

    table.insert(spaceship.shots, shot)
end

function move_shots()
    shot_music:play()

    for i = #spaceship.shots, 1, -1 do
        if spaceship.shots[i].y > 0 then
            spaceship.shots[i].y = spaceship.shots[i].y - 1
        else
            table.remove(spaceship.shots, i)
        end
    end
end

function destroy_spaceship()
    destroy_music:play()

    spaceship.src = 'assets/explosao_nave.png'
    spaceship.image = love.graphics.newImage(spaceship.src)
    spaceship.width = spaceship.image:getWidth()
    spaceship.height = spaceship.image:getHeight()
end

function has_colision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x2 < x1 + w1 and
           x1 < x2 + w2 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function remove_meteor()
    for i = #meteors, 1, -1 do
        if (meteors[i].y > screen_height) then
            table.remove(meteors, i)
        end
    end
end

function create_meteor()
    meteor = {
        src = 'assets/meteor.png',
        x = math.random(0, screen_width),
        y = -70,
        width = 50,
        height = 44,
        weight = math.random(1),
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

function change_background_music()
    env_music:stop()
    game_over_music:play()
end

function check_colision_with_spaceship()
    for k, meteor in pairs(meteors) do
        if (has_colision(meteor.x, meteor.y, meteor.width, meteor.height,
            spaceship.x, spaceship.y, spaceship.width, spaceship.height)) then
            change_background_music()
            destroy_spaceship()
            game_over = true
        end
    end
end

function check_colision_with_shots()
    for i = #spaceship.shots, 1, -1 do
        for j = #meteors, 1, -1 do
            if has_colision(spaceship.shots[i].x, spaceship.shots[i].y, spaceship.shots[i].width, spaceship.shots[i].height,
                meteors[j].x, meteors[j].y, meteors[j].width, meteors[j].height) then
                meteors_hit = meteors_hit + 1
                table.remove(spaceship.shots, i)
                table.remove(meteors, j)
            end
        end
    end
end

function check_colision()
    check_colision_with_spaceship()
    check_colision_with_shots()
end

function check_mission_accomplished()
    if meteors_hit > target_meteor_number then
        winner = true
        env_music:stop()
        winner_music:play()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' then
        shot()
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
    shot_img = love.graphics.newImage('assets/tiro.png')
    gameover_img = love.graphics.newImage('assets/gameover.png')
    winner_img = love.graphics.newImage('assets/vencedor.png')

    env_music = love.audio.newSource('assets/audios/ambiente.wav', 'static')
    env_music:setLooping(true)
    env_music:play()

    destroy_music = love.audio.newSource('assets/audios/destruicao.wav', 'static')
    game_over_music = love.audio.newSource('assets/audios/game_over.wav', 'static')
    shot_music = love.audio.newSource('assets/audios/disparo.wav', 'static')
    winner_music = love.audio.newSource('assets/audios/winner.wav', 'static')
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

        move_shots()

        check_colision()
    end
end

-- Draw a coloured rectangle.
function love.draw()
    -- In versions prior to 11.0, color component values are (0, 102, 102)
    love.graphics.draw(background_img, 0, 0)
    love.graphics.draw(spaceship.image, spaceship.x, spaceship.y)

    love.graphics.print('Meteoros restantes: ' .. target_meteor_number - meteors_hit, 0, 0)

    for k, meteor in pairs(meteors) do
        love.graphics.draw(meteor_img, meteor.x, meteor.y)
    end

    for k, shot in pairs(spaceship.shots) do
        love.graphics.draw(shot_img, shot.x, shot.y)
    end

    if game_over then
        love.graphics.draw(gameover_img, screen_width / 2 - gameover_img:getWidth() / 2, screen_height / 2 - gameover_img:getHeight() / 2)
    elseif winner then
        love.graphics.draw(winner_img, screen_width / 2 - winner_img:getWidth() / 2, screen_height / 2 - winner_img:getHeight() / 2)
    end
end

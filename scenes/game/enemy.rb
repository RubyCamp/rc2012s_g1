# coding utf-8 

require_relative "character"

class Enemy < Character
  def draw
    if @status == 0
      Window.draw(@x, @y, $images[:enemy][@dir])
    elsif @status ==2
      Window.drawAlpha(@x, @y, $images[:enemy][@dir], 128)
    end
  end

  def sleep(time)
    wait(time)
  end

  def move(map)
    countDown if @status == 2
    dir(rand(4)) if rand(30)==0
    if @status != 1 && @restX==0 && @restY==0
      xy = where
      wall = 20
      
      collision = false
      case getDir
      when Game::RIGHT
        if xy[0]!=17 && map.state(xy[0]+1,xy[1])<wall
          @restX = 32
        else
          collision = true
        end
      when Game::LEFT
        if xy[0]!=0 && map.state(xy[0]-1,xy[1])<wall
          @restX = -32
        else
          collision = true
        end
      when Game::DOWN
        if xy[1]!=17 && map.state(xy[0],xy[1]+1)<wall
          @restY = 32
        else
          collision = true
        end
      when Game::UP
        if xy[1]!=0 && map.state(xy[0],xy[1]-1)<wall
          @restY = -32
        else
          collision = true
        end
      end
      
      if collision
        loop do
          newDir = rand(4)
          if (getDir-newDir).abs != 2
            dir(newDir)
            break;
          end
        end
      end
    end
    goForward
  end
end
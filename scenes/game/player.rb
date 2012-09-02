# coding utf-8 

require_relative "character"

class Player < Character
  def draw
    if @status == 0
      Window.draw(@x, @y, $images[:player][@dir])
    elsif @status == 1
      Window.draw(@x, @y, $images[:muteki][@dir])
    else
      Window.draw(@x, @y, $images[:damage][@dir])
    end
  end
  
  def damage(time)
    wait(time)
  end

  def move(inX, inY, map)
    countDown if @status == 2
    xy = where
    wall = 20

    if inX!=0 && @restX==0 && @restY==0
      if inX>0
        dir(Game::RIGHT)
        @restX = 32 if xy[0]!=17 && map.state(xy[0]+1,xy[1])<wall
      elsif inX<0
        dir(Game::LEFT)
        @restX = -32 if xy[0]!=0 && map.state(xy[0]-1,xy[1])<wall
      end
    end
    if inY!=0 && @restY==0 && @restX==0
      if inY>0
        dir(Game::DOWN)
        @restY = 32 if xy[1]!=17 && map.state(xy[0],xy[1]+1)<wall
      elsif inY<0
        dir(Game::UP)
        @restY = -32 if xy[1]!=0 && map.state(xy[0],xy[1]-1)<wall
      end
    end
  
    goForward
    
    for i in [-2, -1, 0, 1, 2]
      for j in [-2, -1, 0, 1, 2]
        p = [xy[0]+i, xy[1]+j]
        if 0<=p[0] && p[0]<=17 && 0<=p[1] && p[1]<=17
          state = map.state(p[0], p[1])
          map.set(p[0],p[1],state+100) unless map.visible(p[0],p[1])
        end
      end
    end
  end
end
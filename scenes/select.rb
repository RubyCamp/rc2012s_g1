# coding utf-8
class Select
  def initialize
    @type = ["難易度を選んでください(Enterキー)","やさしい　\nふつう　\nむずかしい"]
    @sel = "←"
    @font = Font.new(29, "ＭＳ ゴシック", weight:true)
    @y = 100
    @back = Image.load("scenes/game/images/opening3.png")
  end

  def play
    if @y > 100
      if Input.keyPush?(K_UP)
        @y -= 31
      end
    end
    if @y < 162
      if Input.keyPush?(K_DOWN)
        @y += 31
      end
    end
    Window.draw(0,0,@back)
    Window.drawFont(100,50,@type[0],@font,weight:true) 
    Window.drawFont(100,100,@type[1],@font,weight:true) 
    Window.drawFont(300,@y,@sel,@font,weight:true) 
  end

  def next
    if @y == 100 
      if Input.keyPush?(K_RETURN)
        $DIFFICULTY = :easy
        #Scene.set_scene(:game)
        Scene.set_scene(:tutorial) 
      end
    end
    if @y == 131 && Input.keyPush?(K_RETURN)
        $DIFFICULTY = :normal
        #Scene.set_scene(:game)
        Scene.set_scene(:tutorial)  
    end
    if @y == 162 && Input.keyPush?(K_RETURN)
        $DIFFICULTY = :hard
        #Scene.set_scene(:game)
        Scene.set_scene(:tutorial)  
    end
  end


end

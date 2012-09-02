# coding utf-8
class Ending2
  def initialize
    #@ending = ["無事に結婚！めでたし、めでたし","\nリトライはスペースキー"]
    @font = Font.new(29, "ＭＳ ゴシック", weight:true)
    @back = Image.load("scenes/game/images/ending2.png")
    @n = 0
    soundRoot = "scenes/game/sounds/"
    @bgm = Sound.new("#{soundRoot}end_happy.wav")
    @bgm.loopCount = -1
    @playBGM = true
  end

  def play
    if @playBGM
      @playBGM = false
      @bgm.play
    end
    Window.draw(100,0,@back) 
    #Window.drawFont(100,100,@ending[0],@font,weight:true) 
    #Window.drawFont(100,100,@ending[1],@font,weight:true) 
    $s = 0
    $RETRY = true
  end

 def next
    if Input.keyPush?(K_RETURN)
      exit
    end
    if Input.keyPush?(K_SPACE)
      @bgm.stop
      @playBGM = true
      $opBGM.play
      Scene.set_scene(:title)
    end
 end



end
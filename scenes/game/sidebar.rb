# coding: utf-8
require "dxruby"
require_relative "timer"

class Sidebar
  attr_accessor :score
  attr_accessor :ag
  attr_accessor :tsuruhashi
  attr_accessor :heart
  # attr_accessor :time
  CELLSIZE = 32

  def initialize
    @font1 = Font.new(36, "メイリオ")  # 第２引数を省略するとＭＳ Pゴシックになります
    @font2 = Font.new(32, "Calibri")  # 第２引数を省略するとＭＳ Pゴシックになります。　# , "Calibri"
    @font3 = Font.new(40, "メイリオ")  # 第２引数を省略するとＭＳ Pゴシックになります
    
    resourceRoot = "scenes/game/images/icon/"
    @img_ag = Image.load("#{resourceRoot}ag.png")
    @img_tsuruhashi = Image.load("#{resourceRoot}tsuruhashi.png")
    @img_heart = Image.load("#{resourceRoot}heart.png")
    @score = 0
    @ag = 6
    @tsuruhashi = 7
    @heart = 8

    @timer = Timer.new
    @timer_flg = true
  end

  def draw
    Window.drawFont(610,100,"SCORE : #{@score}",@font1)
    
    if @timer_flg
      @timer.calc
    end
    Window.drawFont(610,500,"TIME : #{@timer.min}:#{sprintf('%02d',@timer.sec)}",@font3)  

    draw_item(@tsuruhashi,@img_tsuruhashi,610,200)
    draw_item(@heart,@img_heart,610,300)
  end

  def get_time_sec
    return @timer.dt.to_i
  end

  def timer_stop
    @timer_flg = false
  end

  def draw_item(item,img,x,y)
    # item を 5個づつ15マス内に表示
    if  item >=10
      (item-10).times do |i|
        Window.draw(x+CELLSIZE*i,y+CELLSIZE*2,img)
      end  
      5.times do |i|
        Window.draw(x+CELLSIZE*i,y+CELLSIZE,img)      
      end
      5.times do |i|
        Window.draw(x+CELLSIZE*i,y,img)      
      end           
    elsif item >=5
      (item-5).times do |i|
        Window.draw(x+CELLSIZE*i,y+CELLSIZE,img)
      end
      5.times do |i|
        Window.draw(x+CELLSIZE*i,y,img)      
      end          
    else
      item.times do |i|
        Window.draw(x+CELLSIZE*i,y,img)      
      end       
    end
  end

end
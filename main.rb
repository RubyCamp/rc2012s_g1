require'dxruby'
require'dxrubyex'
require_relative'./scene.rb'


Window.width = 800
Window.height = 600
Window.caption = "銀山掘りゲーム　～婚活大作戦☆～"

Scene.load_scenes

Scene.set_scene(:title)


Window.loop do

   break if Input.keyPush?(K_ESCAPE)
   unless $s == 1
     if Input.keyPush?(K_RETURN)
       Scene.current.next
     end
     if Input.keyPush?(K_SPACE)
       Scene.current.next
     end
   end
  Scene.play
end

# coding utf-8
class Scene
  @@scenes = {}
  @@current_scene_name = nil

  def self.load_scenes(scenes_dirname = "scenes")
     p target_path = File.join(File.dirname(__FILE__), scenes_dirname, "*.rb")
     Dir.glob(target_path) do |file|
       require file
      base_name  = File.basename(file, ".*")
      class_name = base_name.split("_").map{|part| part.downcase.capitalize}.join("").to_sym
      scene_obj  = Object.const_get(class_name).new
      @@scenes[base_name.to_sym] = scene_obj
    end
  end

  # 表示するシーンを切り替える
  def self.set_scene(scene_name)
    @@current_scene_name = scene_name.to_sym
  end

  # シーンの描画を実行する
  def self.play
    #p @@scenes.keys
    #p @@current_scene_name
    #p @@scenes[@@current_scene_name]
    @@scenes[@@current_scene_name].play
  end

  def self.current
    @@scenes[@@current_scene_name]
  end

  def self.current_name
    @@current_scene_name
  end
end

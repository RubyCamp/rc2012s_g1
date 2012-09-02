class Timer
	attr_accessor :min
  attr_accessor :sec
	attr_accessor :dt
	
	def initialize
		@start_t = Time.now
	end

	def calc
		@dt =  Time.now - @start_t
    @min = @dt.to_i/60
    @sec = @dt.to_i%60
	end		
end
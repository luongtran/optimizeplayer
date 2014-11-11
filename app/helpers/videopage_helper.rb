module VideopageHelper
 def get_ysize dimentions
 		unless dimentions.blank?
 			dim = dimentions.split "x"
 			dim = dim[1].to_i
 			if dim <= 360
 				return 8

 			elsif dim > 360 and dim <= 405
 				return 9

 			elsif dim > 405 and dim <= 680
 				return 12

 			else
 				return 15
 			end
 		end

 		return 8
 end
end
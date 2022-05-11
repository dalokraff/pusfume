import os

contents1 = """common = {
  input = {
    filename = """
    
contents2 ="""
  }

  output = {
		apply_processing = true
		cut_alpha_threshold = 0.5
		enable_cut_alpha_threshold = false
		format = "DXT5"
		mipmap_filter = "kaiser"
		mipmap_filter_wrap_mode = "mirror"
		mipmap_keep_original = false
		mipmap_num_largest_steps_to_discard = 0
		mipmap_num_smallest_steps_to_discard = 0
		srgb = true
	}
}"""

text_path = '"work"\n'

list_filenames = []

for x in os.listdir('inn'):
    x = x.replace(".tga","")
    x = x.replace(".png","")
    file = open('inn/'+x+".texture", 'w')
    file.write(contents1+'"textures/pusfume/inn/'+x+'"\n'+contents2)
    file.close()
    print('textures/pusfume/inn/'+x)






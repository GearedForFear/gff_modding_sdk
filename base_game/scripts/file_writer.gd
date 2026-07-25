class_name FileWriter


static func try_write_skin_collection(skin_collection: SkinCollection):
	if skin_collection.changed_since_last_write:
		write_skin_collection(skin_collection)
		skin_collection.changed_since_last_write = false


static func write_skin_collection(skin_collection: SkinCollection):
	var file: File = skin_collection.file
	file.open(skin_collection.path, File.WRITE)
	file.store_buffer(skin_collection.get_ascii())
	file.close()

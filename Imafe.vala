/* MIT License
#
# Copyright (c) 2020 Ferhat Geçdoğan All Rights Reserved.
# Distributed under the terms of the MIT License.
#
# */

/* Use namespaces. */
using GLib;
using Gtk;

public class Imafe : Object {
	/* UI, Image components from GTK. */
	private Window window;
	private Image image;
	private HeaderBar header;
	
	/* Headerbar button for open an image */
	private Button button;
	private Box box;
			
	public Imafe() {
		window = new Window();
		header = new HeaderBar();
		button = new Button.with_label("Open");
		box = new Box(Orientation.VERTICAL, 5);
		image = new Image();
	
		/* Set title variable of Gtk.Window. */
		window.title = "Fegeya Imafe";
		
		window.set_default_size(400, 400);
		
		header.set_show_close_button(true);
		header.set_title(window.title);
		
		/* Add button on headerbar right position */
		header.pack_start(button);

		/* Set titlebar */		
		window.set_titlebar(header);
		
		/* Add image in Gtk.Box */
		box.pack_start(image, true, true, 0);
		window.add(box);

		/* Show open dialog when click 'open' button. */
		button.clicked.connect(on_open_image);
		
		/* Show */
		window.show_all();
		window.destroy.connect(main_quit);
	}

	public void dialog_response(Dialog dialog, int response_id) {
		switch(response_id) {
			case ResponseType.ACCEPT:
				var filename = (dialog as FileChooserDialog).get_filename();
				image.set_from_file(filename);
				header.set_title(filename);
				break;
			default:
				break;
		}
		
		dialog.destroy();
	}

	
	/* Dialog of FileChooser */
	[CCode (instance_pos = -1)]
	public void on_open_image (Button self) {
		var filter = new FileFilter();
		var dialog = new FileChooserDialog("Open image", 				/* Title */
		                                    window,						
		                                    FileChooserAction.OPEN,		
		                                    Stock.CANCEL, ResponseType.CANCEL,
		                                    Stock.OK,     ResponseType.ACCEPT);
		filter.add_pixbuf_formats();
		dialog.add_filter(filter);
		dialog.response.connect(dialog_response);
		dialog.show();
	}

	static int main (string[] args) {
		Gtk.init(ref args);
		var app = new Imafe();

		Gtk.main();

		return 0;
	}
}

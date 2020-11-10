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
	private Window        window;
	private Image         image;
	private HeaderBar     header;
	private Grid		  grid;
	
	private Label		  image_label;
	
	private Label		  filename;
	private Label		  resolution;
	
	private StackSwitcher switcher;
	private Stack 		  image_stack;
	
	/* Headerbar button for open an image */
	private Button        button;
	private Box       	  box;
	private Box       	  info_box;
			
	public Imafe() {
		window      = new Window();
		header      = new HeaderBar();
		button      = new Button.with_label("Open");
		box         = new Box(Orientation.VERTICAL, 5);
		info_box    = new Box(Orientation.VERTICAL, 5);
		image       = new Image();
		
		grid 	    = new Grid();
		
		image_label = new Label("Image");
		
		resolution  = new Label(null);
		filename    = new Label(null);
		
		switcher    = new StackSwitcher();
		image_stack = new Stack();
		
        image_stack.set_vexpand(true);
        image_stack.set_hexpand(true);
        
        switcher.halign = Gtk.Align.CENTER;
        switcher.set_stack(image_stack);
		
		/* Set title variable of Gtk.Window. */
		window.title = "Fegeya Imafe";
		
		window.set_default_size(700, 400);
		
		header.set_show_close_button(true);
		header.set_title(window.title);

		window.add(grid);

		grid.attach(switcher, 0, 0, 1, 1);
		grid.attach(image_stack, 0, 1, 1, 1);

		image_stack.add_titled(box, "Image", "Image");
		image_stack.add_titled(info_box, "Image", "Info");
		        		
		/* Add button on headerbar right position */
		header.pack_start(button);

		/* Set titlebar */		
		window.set_titlebar(header);
		
		info_box.pack_start(filename, true, true, 0);
		info_box.pack_start(resolution, true, true, 1);
		
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
				var dialog_filename = (dialog as FileChooserDialog).get_filename();
				image.set_from_file(dialog_filename);
				header.set_title(dialog_filename);
				filename.set_label(dialog_filename);
				resolution.set_label(image.pixel_size.to_string());
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

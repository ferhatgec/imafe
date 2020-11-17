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
	
	private Entry		  filename;
	private Entry		  resolution;
	private Entry		  type;
	
	private StackSwitcher switcher;
	private Stack 		  image_stack;
	
	/* Headerbar button for open an image */
	private Button        button;
	private Box       	  box;
	private Box       	  info_box;
			
	private float 		  center = 0.5f;
	private string		  dot 	 = "....";
	
	public static string argument = null;
	
	public Imafe() {
		window      = new Window();
		header      = new HeaderBar();
		button      = new Button.with_label("Open");
		box         = new Box(Orientation.VERTICAL, 5);
		info_box    = new Box(Orientation.VERTICAL, 5);
		image       = new Image();
		
		grid 	    = new Grid();
		
		image_label = new Label("Image");
		
		resolution  = new Entry();
		filename    = new Entry();
		type		= new Entry();
		
		filename.set_text(dot);
		resolution.set_text(dot);
		type.set_text(dot);
		
		switcher    = new StackSwitcher();
		image_stack = new Stack();
		
        image_stack.set_vexpand(true);
        image_stack.set_hexpand(true);
        
        
        if(IsExist("/usr/share/pixmaps/imafe/imafe_main.png") == true) {
        	image.set_from_file("/usr/share/pixmaps/imafe/imafe_main.png");
        }
        
        set_info(filename);
        set_info(resolution);
        set_info(type);
        
        switcher.halign = Gtk.Align.CENTER;
        switcher.set_stack(image_stack);
		
		header.pack_start(switcher);
		
		/* Set title variable of Gtk.Window. */
		window.title = "Fegeya Imafe";
		
		window.set_default_size(700, 400);
		
		header.set_show_close_button(true);
		header.set_title(window.title);

		window.add(grid);

		grid.attach(image_stack, 0, 1, 1, 1);

		image_stack.add_titled(box, "Image", "Image");
		image_stack.add_titled(info_box, "Image", "Info");
		        		
		/* Add button on headerbar right position */
		header.pack_start(button);

		/* Set titlebar */		
		window.set_titlebar(header);
		
		info_box.pack_start(filename, false, true, 0);
		info_box.pack_start(resolution, false, true, 1);
		info_box.pack_start(type, false, true, 2);
		
		/* Add image in Gtk.Box */
		box.pack_start(image, true, true, 0);
		window.add(box);

		if(argument != null) { open_image(); }

		/* Show open dialog when click 'open' button. */
		button.clicked.connect(on_open_image);
		
		/* Show */
		window.show_all();
		window.destroy.connect(main_quit);
	}

	void set_info(Entry entry) {
		entry.can_focus = false;
		entry.editable = false;	

		entry.xalign = center;
		
		entry.halign = Align.FILL;
		entry.valign = Align.CENTER;
		
		entry.margin = 20;
	}
	
	public void open_image() {
		if(argument != null) {
			image.set_from_file(argument);

			header.set_title(argument);
				
			filename.set_text("Path: " + argument);
			resolution.set_text("Resolution: " + image.pixel_size.to_string());
			type.set_text("Type: " + GetTypeOfFile(argument));	
		}
	}

	public void dialog_response(Dialog dialog, int response_id) {
		switch(response_id) {
			case ResponseType.ACCEPT:
				var dialog_filename = (dialog as FileChooserDialog).get_filename();
				image.set_from_file(dialog_filename);
				header.set_title(dialog_filename);
				
				filename.set_text("Path: " + dialog_filename);
				resolution.set_text("Resolution: " + image.pixel_size.to_string());
				type.set_text("Type: " + GetTypeOfFile(dialog_filename));
				
				break;
			default:
				break;
		}
		
		dialog.destroy();
	}

	string GetTypeOfFile(string file) {
		if(file.contains(".png") == true) { 
			file = "PNG-Image";
		} else if(file.contains(".jpg") == true) { 
			file = "JPG-Image";
		} else if(file.contains(".gif") == true) { 
			file = "GIF-Image";
		} else { file = "Regular (?)"; }
		
		return file;
	}
	
	/* From FileOperations (CodeFad & Prism) */
	public bool IsExist(string _directory) {
    	if (GLib.FileUtils.test(_directory, GLib.FileTest.EXISTS)) {
			return true;
		}
		
		return false;
    }
    
	/* Dialog of FileChooser */
	[CCode (instance_pos = -1)]
	public void on_open_image (Button self) {
		var filter = new FileFilter();
		var dialog = new FileChooserDialog("Open Image", 				/* Title */
		                                    window,						
		                                    FileChooserAction.OPEN,		
		                                    Stock.CANCEL, ResponseType.CANCEL,
		                                    Stock.OK,     ResponseType.ACCEPT);
		filter.add_pixbuf_formats();
		dialog.add_filter(filter);
		dialog.response.connect(dialog_response);
		dialog.show();
	}

	static int main(string[] args) {
		Gtk.init(ref args);

		if(args[1] != null) { argument = args[1]; }
  
		var app = new Imafe();

		Gtk.main();

		return 0;
	}
}

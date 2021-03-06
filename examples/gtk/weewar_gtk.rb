$: << File.dirname(__FILE__) + "/../../lib"
$KCODE = 'U'
require 'gtk2'
require 'weewar'

class WeewarWindow < Gtk::Window
  def initialize
    super 'Weewar Ruby/GTK2'
    signal_connect('destroy') { Gtk.main_quit }
    self.icon = Gtk::Image.new(File.expand_path(File.dirname(__FILE__) + '/../cocoa/no_games.png')).pixbuf

    @mainbox = Gtk::VBox.new
    @userbox = Gtk::HBox.new
    @gamesbox = Gtk::VBox.new(true)
    @statusbox = Gtk::HBox.new

    @userbox.add(Gtk::Label.new('Enter your username:'))
    @username = Gtk::Entry.new
    @username.signal_connect('activate') do
      load_data
    end
    @userbox.add(@username)
    @mainbox.add(@userbox)

    @mainbox.add(@gamesbox)

    @status = Gtk::Label.new
    @refresh = Gtk::Button.new('refresh')
    @refresh.signal_connect('clicked') do
      load_data
    end
    @statusbox.add(@status)
    @statusbox.add(@refresh)
    @mainbox.add(@statusbox)

    add(@mainbox)
    show_all
  end

  def load_data
    if @username.text.strip.empty?
      @status.text = "Enter a username!"
      @username.focus
      return
    end
    begin
      user = Weewar::User.find(@username.text.strip)
      clear_games
      user.games.each do |game|
        button = Gtk::Button.new(game.name)
        if game.current_player == user
          button.image = Gtk::Image.new(File.expand_path(File.dirname(__FILE__) + '/../cocoa/games.png'))
        end
        button.signal_connect('clicked') {
          system "gnome-open #{game.url}"
        }
        @gamesbox.add(button)
      end
      if user.games.any? {|game| game.current_player == user }
        self.icon = Gtk::Image.new(File.expand_path(File.dirname(__FILE__) + '/../cocoa/games.png')).pixbuf
      else
        self.icon = Gtk::Image.new(File.expand_path(File.dirname(__FILE__) + '/../cocoa/no_games.png')).pixbuf
      end
      @status.text = "Success"
      @gamesbox.show_all
    rescue Exception => e
      puts e.inspect
      @status.text = "Error connecting to Weewar! Try again later."
    end
  end

  def clear_games
    @gamesbox.each {|child| @gamesbox.remove(child) }
  end
end

Gtk.init
WeewarWindow.new
Gtk.main
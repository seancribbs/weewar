#!/usr/bin/env ruby
$: << File.dirname(__FILE__) + "/../../lib"
require 'osx/cocoa'
require 'weewar'

include OSX

class App < NSObject
  def applicationDidFinishLaunching(aNotification)
    statusbar = NSStatusBar.systemStatusBar
    @item = statusbar.statusItemWithLength(NSVariableStatusItemLength)
    image = NSImage.alloc.initWithContentsOfFile("no_games.png")
    @item.setImage(image)
    WeeController.alloc.init.add_menu_to(@item)
  end
end

class WeeController < NSObject
  def init
    super_init
    @synthesizer = NSSpeechSynthesizer.alloc.init
    self
  end
  
  def add_menu_to(container)
    menu = NSMenu.alloc.init
    container.setMenu(menu)
    
    user = Weewar::User.find('srmoon7')
    user.games.each {|game|
      item = menu.addItemWithTitle_action_keyEquivalent(game.name, "speak", '')
      item.setTarget(self)
    }
    
    item = menu.addItem(NSMenuItem.separatorItem)
    
    item = menu.addItemWithTitle_action_keyEquivalent("Quit", "terminate:", 'q')
    item.setKeyEquivalentModifierMask(NSCommandKeyMask)
    item.setTarget(NSApp)
  end
  
  def speak(sender)
    @synthesizer.startSpeakingString("#{sender.title}, requires your attention")
  end
end

NSApplication.sharedApplication
NSApp.setDelegate(App.alloc.init)
NSApp.run
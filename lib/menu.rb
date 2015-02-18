# The menu system built into Printsly for command line use
# Choices [1] Process single spreadsheet [2] Process all spreadsheets [3] Configure printsly [4] Show configuration [5] Reset configuration
require 'choice'

class Menu

  def initialize
    # Main Menu
    # this greeting is only seen once
    puts "If this is the first time to run Printsly, please choose " + "[3]".yellow + " and configure."
    puts #space
    puts "The configuration file is stored in your home directory by default."
  end

  def choices
    move = 0
    until move == "6"
      begin
        #load_data
        puts # formatting
        puts bar_top.yellow
        #puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
        puts bar_low.yellow
        puts # formatting
        c = Choice.new "Please choose what you would like to do:",
        {
          "1" => "Process Single Spreadsheet",
          "2" => "Process All Spreadsheets",
          "3" => "Configure Printsly",
          "4" => "Show Configuration",
          "5" => "Reset Configuration",
          "6" => "Exit"
        }
        move = c.prompt
      end while not (move == "1" or move == "2" or move == "3" or move == "4" or move == "5" or move == "6")
      case
      when move == "1"
        Printers.new.build
      when move == "2"
        Batch.new.choices
      when move == "3"
        puts "Oh no you did ent!"
      when move == "4"
        puts "No way you weirdo!"
      when move == "5"
        puts "Not yet my friend."
      when move == "6"
        # leave application
        puts #format
        puts "As you wish."
        puts #format
        exit
      end
    end
  end

end

class Batch
  # Process all spreadsheets in specified directory

  def initialize
    puts # formatting
    puts "From here we can process all spreadsheets in the directory of your choice."
    puts # formatting
  end

  def choices
    move = 0
    #load_data
    until move == "3"
      puts # formatting
      puts bar_top.yellow
      #puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
      puts bar_low.yellow
      puts # formatting
      work_dir = ""
      c = Choice.new "Please choose what you would like to do:",
      {
        "1" => "Choose Directory",
        "2" => "Process All Spreadsheets",
        "3" => "Return to Main Menu"
      }
      move = c.prompt
      case
      when move == "1"
        begin
          work_dir = choose_file
          puts #format
          puts "You have chosen #{work_dir}. Is this correct?"
          yes_no
        end while not (@yes_no == "yes")
      when move == "2"
        if work_dir.empty?
          puts #format
          puts "You must choose a directory to process!"
          begin
            work_dir = choose_file
            puts #format
            puts "You have chosen #{work_dir}. Is this correct?"
            yes_no
          end while not (@yes_no == "yes")
        end
        puts #format
        puts "I will process #{work_dir} now."
        puts "Processing..."
        puts "...done!"
      when move == "3"
        puts #format
        puts "Returning to main menu."
        return
      end
    end
  end

end

class Configurator

  # Set and save Printsly defaults - not working yet!
  def initialize
    load_data
    puts # formatting
    puts "You enter the tavern. The air is thick with smoke, but the fire in the hearth"
    puts "is warm and inviting."
    puts if @player.cur_hp < @player.hp # formatting
    puts "Some rest would probably do you good, #{@player.name}." if @player.cur_hp < @player.hp
    puts # formatting
  end

  def choices
    move = 0
    until move == "4"
      begin
        puts # formatting
        puts bar_top.yellow
        puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
        puts bar_low.yellow
        puts # formatting
        room_cost = @player.lvl*2
        nourish_cost = @player.lvl
        c = Choice.new "What would you like to do in the tavern, #{@player.name}?",
        {
          "1" => "Buy some food.    | Cost: #{nourish_cost} coins.",
          "2" => "Buy a drink.      | Cost: #{nourish_cost} coins.",
          "3" => "Rest.             | Cost: #{room_cost} coins.",
          "4" => "Leave the tavern."
        }
        move = c.prompt
      end while not (move == "1" or move == "2" or move == "3" or move == "4")
      case
      when move == "1"
        if @player.coin >= @player.lvl and @player.buff_food != true
          @player.buff_food = true
          puts # formatting
          puts "You find a seat at an open table and the waiter approaches to take your order."
          puts # formatting
          puts "The waiter tells you the food is so darn good, that it will help sustain your"
          puts "health as you travel in the dungeon."
          puts # formatting
          puts "You order and enjoy a delicious meal, #{@player.name}, you really do feel swell!"
          @player.coin = @player.coin - @player.lvl
          save_data
        elsif @player.buff_food == true
          puts #formatting
          puts "You couldn't possibly eat anymore."
        else
          puts # formatting
          puts "You can't afford a meal! Go to the dungeon and earn some money!"
        end
      when move == "2"
        if @player.coin >= @player.lvl and @player.buff_drink != true
          @player.buff_drink = true
          puts # formatting
          puts "You sally up to the bar and the barkeep approaches to take your order."
          puts # formatting
          puts "The barkeep tells you the wine is so fancy, that it will help sustain your"
          puts "mana as you travel in the dungeon."
          puts # formatting
          puts "You swirl the wine, sniff, then take a sip, #{@player.name}, you really do feel superior!"
          @player.coin = @player.coin - @player.lvl
          save_data
        elsif @player.buff_drink == true
          puts #formatting
          puts "You couldn't possibly drink anymore."
        else
          puts # formatting
          puts "You can't afford wine, you churl! Go to the dungeon and earn some money!"
        end
      when move == "3"
        if @player.coin >= @player.lvl*2 and (@player.cur_hp != @player.hp or @player.cur_mana != @player.mana)
          health = @player.cur_hp
          mana   = @player.cur_mana
          @player.coin = @player.coin - @player.lvl*2
          restore_player
          health = @player.cur_hp - health
          mana   = @player.cur_mana - mana
          puts # formatting
          puts "You pay for a small room and get a good night of rest."
          puts "Resting has restored #{health} health points and #{mana} points of mana."
        elsif (@player.cur_hp == @player.hp and @player.cur_mana == @player.mana)
          puts # formatting
          puts "You don't really need to rest, get out there and make your own discoveries!"
        else
          puts # formatting
          puts "You can't afford a room! Hit the dungeon and earn some money!"
        end
      when move == "4"
        puts # formatting
        puts "Feeling much better, you step out of the tavern and back into town."
        save_data
        return
      end
    end
  end

end

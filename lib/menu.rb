# The menu system built into Printsly for command line use

require 'choice'

class Menu

  def initialize
    puts "If this is the first time to run Printsly, please choose " + "[3]".yellow + " and configure."
    puts #format
    puts "The configuration file is stored in your home directory by default."
    # Variables are set this way because Printsly will soon support a config file
    work_dir   = "Not Set" if work_dir.nil? || work_dir.empty?
    batchy     = "Off" if batchy.nil? || batchy.empty?
    auto_mater = "Off" if auto_mater.nil? || auto_mater.empty?
    @cur_conf   = fill_hash(work_dir, batchy, auto_mater)
  end

  def choices
    move = 0
    until move == "6"
      begin
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
        begin
          spread = choose_file
          puts #formatting
          puts "You have chosen " + "#{spread}".yellow + ". Is this correct?"
          yes_no
        end while not (@yes_no == "yes")
        Printers.new.build(spread)
      when move == "2"
        Batch.new.choices
      when move == "3"
        @cur_conf = Configurator.new.choices(@cur_conf)
      when move == "4"
        puts #format
        puts "Current Working Directory:        " + @cur_conf[:work_dir].green
        puts "Current Batch Mode Setting:       " + @cur_conf[:batchy].green
        puts "Current Auto Provision Setting:   " + @cur_conf[:auto_mater].green
      when move == "5"
        puts #format
        puts "Resetting to default configuration...".yellow
        sleep(0.5)
        puts "...".yellow
        sleep(0.5)
        puts "......".red
        @cur_conf   = fill_hash("Not Set", "Off", "Off")
        sleep(0.5)
        puts ".........done!".green
      when move == "6"
        # leave application
        puts #format
        puts "As you wish.".yellow
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
    until move == "3"
      puts # formatting
      puts bar_top.yellow
      #puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
      puts bar_low.yellow
      puts # formatting

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
          @work_dir = choose_file
          puts #format
          puts "You have chosen " + @work_dir.yellow + " Is this correct?"
          yes_no
        end while not (@yes_no == "yes")
      when move == "2"
        if @work_dir.nil? || @work_dir.empty? || @work_dir == "Not Set"
          puts #format
          puts "You must choose a directory to process!".red
          begin
            @work_dir = choose_file
            puts #format
            puts "You have chosen " + @work_dir.yellow + " Is this correct?"
            yes_no
          end while not (@yes_no == "yes")
        end
        puts #format
        puts "I will process " + @work_dir.yellow + " now."
        sleep(0.5)
        puts "...".yellow
        sleep(0.5)
        puts "......".red
        sleep(0.5)
        puts ".........done!".green
      when move == "3"
        puts #format
        puts "Returning to main menu.".yellow
        return
      end
    end
  end

end

class Configurator

  # Set and save Printsly defaults - work in progress!
  def initialize
    puts #format
    puts "Let's configure " + "Printsly".yellow + "."
    work_dir_text
    batchy_text
    auto_text
  end

  def choices(cur_conf)
    work_dir   = cur_conf[:work_dir]
    batchy     = cur_conf[:batchy]
    auto_mater = cur_conf[:auto_mater]
    move = 0
    until move == "4"
      puts # formatting
      puts bar_top.yellow
      #puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
      puts bar_low.yellow
      puts # formatting
      c = Choice.new "What would you like to configure?",
      {
        "1" => "Set Working Directory    | Current: " + work_dir.green,
        "2" => "Batch Mode               | Current: " + batchy.green,
        "3" => "Auto Provision?          | Current: " + auto_mater.green,
        "4" => "Return To Main Menu."
      }
      move = c.prompt
      case
      when move == "1"
      begin
        work_dir_text
        puts #format
        puts "The working directory is currently: " + work_dir.green
        work_dir = choose_file
        puts #format
        puts "You have chosen " + work_dir.yellow + " Is this correct?"
        yes_no
      end while not (@yes_no == "yes")
      when move == "2"
        batchy_text
        puts #format
        puts "Batch mode is currently turned " + batchy.green + "."
        puts #format
        case
        when batchy == "Off"
          puts "Turn batch mode on?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          batchy = "On" if @yes_no == "yes"
        when
          batchy == "On"
          puts "Turn batch mode off?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          batchy = "Off" if @yes_no == "yes"
        end
      when move == "3"
        auto_text
        puts #format
        puts "Auto provision is currently turned " + auto_mater.green + "."
        puts #format
        case
        when auto_mater == "Off"
          puts "Turn auto provision on?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          auto_mater = "On" if @yes_no == "yes"
        when
          auto_mater == "On"
          puts "Turn auto provision off?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          auto_mater = "Off" if @yes_no == "yes"
        end
      when move == "4"
        puts #format
        puts "Returning to main menu."
        @cur_conf = fill_hash(work_dir, batchy, auto_mater)
      return @cur_conf
      end
    end
  end

end

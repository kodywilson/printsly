# The menu system built into Printsly for command line use
# Choices [1] Process single spreadsheet [2] Process all spreadsheets [3] Configure printsly [4] Show configuration [5] Reset configuration
require 'choice'

class Menu

  def initialize
    # Main Menu
    puts "If this is the first time to run Printsly, please choose " + "[3]".yellow + " and configure."
    puts #space
    puts "The configuration file is stored in your home directory by default."
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
          puts "You have chosen #{spread}. Is this correct?"
          yes_no
        end while not (@yes_no == "yes")
        Printers.new.build(spread)
      when move == "2"
        Batch.new.choices
      when move == "3"
        Configurator.new.choices
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
    #@work_dir = "" if @work_dir.nil? || @work_dir.empty?
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
        if @work_dir.nil? || @work_dir.empty?
          puts #format
          puts "You must choose a directory to process!"
          begin
            @work_dir = choose_file
            puts #format
            puts "You have chosen " + @work_dir.yellow + " Is this correct?"
            yes_no
          end while not (@yes_no == "yes")
        end
        puts #format
        puts "I will process " + @work_dir.yellow + " now."
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

  # Set and save Printsly defaults - work in progress!
  def initialize
    puts #format
    puts "Let's configure " + "Printsly".yellow + "."
    puts #format
    puts "The " + "working directory".yellow + " is the location " + "Printsly".yellow + " will look for"
    puts "spreadsheets containing printers to add to " + "CUPS".yellow + "."
    puts #format
    puts "Batch mode".yellow + " means all spreadsheets in " + "working directory".yellow + " will be processed."
    puts #format
    puts "Auto provision".yellow + " means provisioning is done immediately with no"
    puts "confirmation dialogue."
  end

  def choices
    move = 0
    until move == "4"
      puts # formatting
      puts bar_top.yellow
      #puts stat_bar(@player.name, @player.xp, @player.lvl, @player.coin, @player.cur_hp, @player.cur_mana)
      puts bar_low.yellow
      puts # formatting
      @work_dir = "Not Set" if @work_dir.nil? || @work_dir.empty?
      @batchy = "Off" if @batchy.nil? || @batchy.empty?
      @auto_mater = "Off" if @auto_mater.nil? || @auto_mater.empty?
      c = Choice.new "What would you like to configure?",
      {
        "1" => "Set Working Directory    | Current: " + @work_dir.yellow,
        "2" => "Batch Mode               | Current: " + @batchy.yellow,
        "3" => "Auto Provision?          | Current: " + @auto_mater.yellow,
        "4" => "Return To Main Menu."
      }
      move = c.prompt
      case
      when move == "1"
      begin
        puts #format
        puts "The working directory is currently: " + @work_dir.yellow
        @work_dir = choose_file
        puts #format
        puts "You have chosen " + @work_dir.yellow + " Is this correct?"
        yes_no
      end while not (@yes_no == "yes")
      when move == "2"
        puts #format
        puts "Batch mode is currently turned " + @batchy.yellow + "."
        puts #format
        case
        when @batchy == "Off"
          puts "Turn batch mode on?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          @batchy = "On" if @yes_no == "yes"
        when
          @batchy == "On"
          puts "Turn batch mode off?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          @batchy = "Off" if @yes_no == "yes"
        end
      when move == "3"
        puts #format
        puts "Auto provision is currently turned " + @auto_mater.yellow + "."
        puts #format
        case
        when @auto_mater == "Off"
          puts "Turn auto provision on?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          @auto_mater = "On" if @yes_no == "yes"
        when
          @auto_mater == "On"
          puts "Turn auto provision off?"
          begin
            yes_no
          end while not (@yes_no == "yes" or @yes_no == "no")
          @auto_mater = "Off" if @yes_no == "yes"
        end
      when move == "4"
        puts #format
        puts "Returning to main menu."
      return
      end
    end
  end

end

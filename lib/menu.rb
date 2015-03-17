# The menu system for Printsly's command line interface

require 'choice'

class Menu

  def initialize
    case File.exists?(File.join(Dir.home, "printsly.json"))
    when false
      welcome_text
      work_dir   = "Not Set"
      batchy     = "Off"
      auto_mater = "Off"
      @cur_conf  = fill_hash(work_dir, batchy, auto_mater)
    when true
      @cur_conf  = load_config
      puts "Using configuration found in your home directory.".yellow
    end
  end

  def choices
    move = 0
    until move == "6"
      begin
        bar_both
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
      actions(move)
    end
  end

  def actions move
    case
    when move == "1"
      singleton(@cur_conf)
    when move == "2"
      Batch.new.process(@cur_conf)
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
      save_config(@cur_conf)
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

  def singleton cur_conf
    begin
      spread = choose_file
      puts #formatting
      puts "You have chosen " + spread.yellow + ". Is this correct?"
      yes_no
    end while not (@yes_no == "yes")
    book = Spreadsheet.open spread
    sheet = book.worksheet 0
    store = sheet.row(0)[0][6..8]
    printers = Printers.new.hashy(sheet, store)
    Printers.new.provision(printers, store)
  end

end

class Batch
  # Process all spreadsheets in specified directory

  def initialize
    puts #format
  end

  def process(cur_conf)
    if cur_conf[:work_dir] == "Not Set" || cur_conf[:auto_mater] == "Off"
      cur_conf = Configurator.new.choices(cur_conf)
    end
    puts "Processing " + cur_conf[:work_dir].yellow + ":"
    sleep(0.5)
    puts "...".yellow
    sleep(0.5)
    puts "......".red
    sleep(0.5)
    puts ".........done!".green
    Printers.new.batch(cur_conf[:work_dir])
  end

end

class Configurator

  # Set and save Printsly defaults
  def batch_mode batchy
    batchy_text
    puts #format
    puts "Batch mode is currently turned " + batchy.green + "."
    puts #format
    case
    when batchy == "Off"
      puts "Turn batch mode on?"
      @yes_no = yes_no
      batchy = "On" if @yes_no == "yes"
    when batchy == "On"
      puts "Turn batch mode off?"
      @yes_no = yes_no
      puts @yes_no
      batchy = "Off" if @yes_no == "yes"
    end
    puts batchy
    batchy
  end

  def choices(cur_conf)
    move = 0
    until move == "4"
      bar_both
      c = Choice.new "What would you like to configure?",
      {
        "1" => "Set Working Directory    | Current: " + cur_conf[:work_dir].green,
        "2" => "Batch Mode               | Current: " + cur_conf[:batchy].green,
        "3" => "Auto Provision?          | Current: " + cur_conf[:auto_mater].green,
        "4" => "Return To Main Menu."
      }
      move = c.prompt
      cur_conf = actions(move, cur_conf)
    end
    save_config(cur_conf)
    return cur_conf
  end

  def actions move, cur_conf
    case
    when move == "1"
    begin
      work_dir_text
      puts #format
      puts "The working directory is currently: " + cur_conf[:work_dir].green
      cur_conf[:work_dir] = choose_file
      puts #format
      puts "You have chosen " + cur_conf[:work_dir].yellow + " Is this correct?"
      yes_no
    end while not (@yes_no == "yes")
    when move == "2"
      cur_conf[:batchy] = batch_mode(cur_conf[:batchy])
    when move == "3"
      cur_conf[:auto_mater] = provision_mode(cur_conf[:auto_mater])
    when move == "4"
      puts #format
      puts "Returning to main menu."
    end
    cur_conf
  end

  def initialize
    File.new(File.join(Dir.home, "printsly.json"), "w+") unless File.exists?(File.join(Dir.home, "printsly.json"))
    puts #format
    puts "Let's configure " + "Printsly".yellow + "."
    work_dir_text
    batchy_text
    auto_text
  end

  def provision_mode auto_mater
    auto_text
    puts #format
    puts "Auto provision is currently turned " + auto_mater.green + "."
    puts #format
    case
    when auto_mater == "Off"
      puts "Turn auto provision on?"
      @yes_no = yes_no
      auto_mater = "On" if @yes_no == "yes"
    when auto_mater == "On"
      puts "Turn auto provision off?"
      @yes_no = yes_no
      auto_mater = "Off" if @yes_no == "yes"
    end
  end

end

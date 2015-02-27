module CommonStuff

  @@config_file = File.join(Dir.home, "printsly.json")

  def prompt
    print ">> "
  end

  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter " + "[yes]".yellow + " or " + "[no]".yellow + ":"
      prompt; @yes_no = STDIN.gets.chomp.downcase
    end while not (@yes_no == "yes" or @yes_no == "no")
  end

  def choose_file
    puts #formatting
    puts "Please enter the full path to the spreadsheet(s):"
    prompt; gets.chomp
  end

  def bar_top
    "_"*34 + " " + "Printsly" + " " + "_"*34
  end

  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    "  Name: " + "#{name}" + " | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
  end

  def bar_low
    "-"*78
  end

  def fill_hash work_dir, batchy, auto_mater
    cur_conf = Hash.new
    cur_conf[:work_dir]     = work_dir
    cur_conf[:batchy]       = batchy
    cur_conf[:auto_mater]   = auto_mater
    cur_conf
  end

  def load_config
    file_conf = JSON.parse(File.read(@@config_file))
    cur_conf = fill_hash(file_conf['work_dir'], file_conf['batchy'], file_conf['auto_mater'])
    cur_conf
  end

  def save_config(cur_conf)
    File.open(@@config_file, "w") do |f|
      f.write(cur_conf.to_json)
    end
  end

  def work_dir_text
    puts #format
    puts "The " + "working directory".yellow + " is the location " + "Printsly".yellow + " will look for"
    puts "spreadsheets containing printers to add to " + "CUPS".yellow + "."
  end

  def batchy_text
    puts #format
    puts "Batch mode".yellow + " means all spreadsheets in the " + "working directory".yellow + " will be processed."
  end

  def auto_text
    puts #format
    puts "Auto provision".yellow + " means provisioning is done immediately with no"
    puts "confirmation dialogue."
  end

end

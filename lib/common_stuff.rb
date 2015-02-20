module CommonStuff

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

end

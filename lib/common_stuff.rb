module CommonStuff

  def prompt
    print ">> "
  end

  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter [yes] or [no]:"
      prompt; @yes_no = STDIN.gets.chomp.downcase
    end while not (@yes_no == "yes" or @yes_no == "no")
  end

  def choose_file
    puts #formatting
    puts "Please enter the full path to the spreadsheet:"
    prompt; gets.chomp
  end

  def bar_top
    "_"*32 + " " + "Printsly" + " " + "_"*32
  end

  def stat_bar name, xp, lvl, coin, cur_hp, cur_mana
    "  Name: " + "#{name}" + " | XP: #{xp} | Lvl: #{lvl} | Coin: #{coin} | HP: #{cur_hp} | Mana: #{cur_mana}"
  end

  def bar_low
    "-"*72
  end

end

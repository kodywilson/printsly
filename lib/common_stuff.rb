module CommonStuff

  @@config_file = File.join(Dir.home, "printsly.json")

  def bar_both
    puts # formatting
    puts bar_top.yellow
    puts bar_low.yellow
    puts # formatting
  end

  def prov_text store
    "This is what I am planning on provisioning for store " + store + ":"
  end

  def printer_puts printerdata
    "Name: ".yellow + printerdata[0] + " " + "Type: ".yellow + printerdata[2] + " " + "IP: ".yellow + printerdata[1] + " " + "Desc: ".yellow + printerdata[3]
  end

  def log_file
    if Dir.exists?("/var/log/cups")
      File.new("/var/log/cups/provision_log", "w+") unless File.exists?("/var/log/cups/provision_log")
    end
  end

  def log_entry printerdata
    if File.exists?("/var/log/cups/provision_log")
      timey = Time.new
      File.open("/var/log/cups/provision_log", "a") do |f|
        f.puts "Added: " + timey.inspect + " lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
      end
    end
  end

  def mod_name namey, store
    namey = "0" + store + namey if namey.include?('RT') || namey.include?('SIM')
    namey
  end

  def prompt
    print ">> "
  end

  def yes_no
    #restrict input to valid answers, but don't worry about case
    begin
      puts "Please enter " + "[yes]".yellow + " or " + "[no]".yellow + ":"
      prompt; @yes_no = STDIN.gets.chomp.downcase
    end while not (@yes_no == "yes" or @yes_no == "no")
    @yes_no
  end

  def choose_file
    puts #formatting
    puts "Please enter the full path to the spreadsheet(s):"
    prompt; gets.chomp
  end

  def bar_top
    "_"*34 + " " + "Printsly" + " " + "_"*34
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

  def welcome_text
    puts "If this is the first time to run Printsly, please choose " + "[3]".yellow + " and configure."
    puts #format
    puts "The configuration file is stored in your home directory by default."
  end

end

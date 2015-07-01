module CommonStuff

  @@config_file = File.join(Dir.home, "printsly.json")
  @@prov_log = "/var/log/cups/provision_log"

  def log_file
    if Dir.exists?("/var/log/cups")
      File.new(@@prov_log, "w+") unless File.exists?(@@prov_log)
    end
  end

  def log_entry printerdata, status
    if File.exists?(@@prov_log)
      log_entry_write(printerdata, status)
    end
  end

  def log_entry_write printerdata, status
    File.open(@@prov_log, "a") do |f|
      f.puts log_entry_data_woot(printerdata) if status == 0
      f.puts log_entry_data_fail(printerdata) if status == 1
    end
  end

  def log_entry_data_woot printerdata
    timey = Time.new
    "Add: " + timey.inspect + " " + printerdata[0] + " " + printerdata[2] + " IP: " + printerdata[1]
  end

  def log_entry_data_fail printerdata
    timey = Time.new
    "FAILED: " + timey.inspect + " " + printerdata[0] + " " + printerdata[2] + " IP: " + printerdata[1]
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

end

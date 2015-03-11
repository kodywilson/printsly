require 'printsly'

RSpec.describe Printers, "#build" do
  context "when sent a spreadsheet" do
    it "gives the lpadmin command" do
      printys = Printers.new.build("lib/test_data/0777.xls")
      printys.each do | printername, printerdata |
        printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('RT')
        printerdata[0] = "0" + store + printerdata[0] if printerdata[0].include?('SIM')
        @test_page = "lpadmin -p " + printerdata[0] + " -L \"" + printerdata[3] + "\" -D \"" + printerdata[2] + "\" -E -v socket://" + printerdata[1] + ":9100 -m raw"
      end
      expect(@test_page).to eq 'lpadmin -p 0777LAB2 -L "777 Test Printer Lab" -D "Zebra Labeler" -E -v socket://192.168.1.21:9100 -m raw'
    end
  end
end
